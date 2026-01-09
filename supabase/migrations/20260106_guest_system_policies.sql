-- Row Level Security Policies for Guest System

-- ============================================
-- GUEST_USERS TABLE POLICIES
-- ============================================

-- Enable RLS
ALTER TABLE guest_users ENABLE ROW LEVEL SECURITY;

-- Policy 1: Allow anyone to create a guest session
CREATE POLICY "Allow guest creation" ON guest_users
  FOR INSERT 
  WITH CHECK (true);

-- Policy 2: Allow users to read their own session via custom claim
CREATE POLICY "Read own guest session" ON guest_users
  FOR SELECT 
  USING (
    session_id = current_setting('request.jwt.claims', true)::json->>'guest_session_id'
  );

-- Policy 3: Only service role can update (prevent user tampering)
CREATE POLICY "Service role only updates" ON guest_users
  FOR UPDATE 
  USING (false);

-- Policy 4: Only service role can delete (for cleanup jobs)
CREATE POLICY "Service role only deletes" ON guest_users
  FOR DELETE 
  USING (false);

-- ============================================
-- CONVERSATIONS TABLE POLICIES UPDATE
-- ============================================

-- Policy: Allow guest users to create conversations
CREATE POLICY "Guest can create conversations" ON conversations
  FOR INSERT 
  WITH CHECK (
    guest_session_id IS NOT NULL 
    AND guest_session_id = current_setting('request.jwt.claims', true)::json->>'guest_session_id'
  );

-- Policy: Allow guest users to read their own conversations
CREATE POLICY "Guest can read own conversations" ON conversations
  FOR SELECT 
  USING (
    guest_session_id = current_setting('request.jwt.claims', true)::json->>'guest_session_id'
    OR driver_user_id = auth.uid()
  );

-- Policy: Allow guest users to update their own conversations (for message counting)
CREATE POLICY "Guest can update own conversations" ON conversations
  FOR UPDATE 
  USING (
    guest_session_id = current_setting('request.jwt.claims', true)::json->>'guest_session_id'
    OR driver_user_id = auth.uid()
  );

-- ============================================
-- AGE_VERIFICATION_LOGS TABLE POLICIES
-- ============================================

-- Enable RLS
ALTER TABLE age_verification_logs ENABLE ROW LEVEL SECURITY;

-- Policy: Allow insertion of verification logs
CREATE POLICY "Allow verification log creation" ON age_verification_logs
  FOR INSERT 
  WITH CHECK (true);

-- Policy: Only service role can read logs (privacy compliance)
CREATE POLICY "Service role only reads logs" ON age_verification_logs
  FOR SELECT 
  USING (false);

-- ============================================
-- MESSAGES TABLE POLICIES UPDATE
-- ============================================

-- Policy: Allow guests to insert messages to their conversations
CREATE POLICY "Guest can send messages" ON messages
  FOR INSERT 
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM conversations 
      WHERE conversations.id = messages.conversation_id 
      AND conversations.guest_session_id = current_setting('request.jwt.claims', true)::json->>'guest_session_id'
    )
  );

-- Policy: Allow guests to read messages from their conversations
CREATE POLICY "Guest can read messages" ON messages
  FOR SELECT 
  USING (
    EXISTS (
      SELECT 1 FROM conversations 
      WHERE conversations.id = messages.conversation_id 
      AND (
        conversations.guest_session_id = current_setting('request.jwt.claims', true)::json->>'guest_session_id'
        OR conversations.driver_user_id = auth.uid()
      )
    )
  );

-- ============================================
-- CLEANUP FUNCTION FOR EXPIRED GUESTS
-- ============================================

-- Function to delete expired guest sessions and associated data
CREATE OR REPLACE FUNCTION cleanup_expired_guests()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  -- Delete messages from expired guest conversations
  DELETE FROM messages
  WHERE conversation_id IN (
    SELECT c.id FROM conversations c
    JOIN guest_users g ON c.guest_session_id = g.session_id
    WHERE g.expires_at < NOW() AND g.is_converted = false
  );
  
  -- Delete expired guest conversations
  DELETE FROM conversations
  WHERE guest_session_id IN (
    SELECT session_id FROM guest_users
    WHERE expires_at < NOW() AND is_converted = false
  );
  
  -- Delete expired guest users
  DELETE FROM guest_users
  WHERE expires_at < NOW() AND is_converted = false;
  
  RAISE NOTICE 'Cleaned up expired guest data';
END;
$$;

-- Schedule cleanup to run daily (requires pg_cron extension)
-- Note: This requires enabling pg_cron in Supabase dashboard
-- SELECT cron.schedule('cleanup-expired-guests', '0 2 * * *', $$SELECT cleanup_expired_guests()$$);

COMMENT ON FUNCTION cleanup_expired_guests IS 'Automatically deletes expired guest sessions and associated data (unconverted guests older than 3 days)';
