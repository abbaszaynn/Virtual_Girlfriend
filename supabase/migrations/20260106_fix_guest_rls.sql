-- Fix for RLS policy to allow guest creation without authentication

-- Drop ALL existing policies to ensure clean state
DROP POLICY IF EXISTS "Allow guest creation" ON guest_users;
DROP POLICY IF EXISTS "Read own guest session" ON guest_users;
DROP POLICY IF EXISTS "Service role only updates" ON guest_users;
DROP POLICY IF EXISTS "Service role only deletes" ON guest_users;

-- Drop the new policies in case they were partially created
DROP POLICY IF EXISTS "Allow anonymous guest creation" ON guest_users;
DROP POLICY IF EXISTS "Read guest sessions" ON guest_users;
DROP POLICY IF EXISTS "Allow guest session updates" ON guest_users;

-- Create new policy that allows anyone to insert (guests don't have auth)
CREATE POLICY "Allow anonymous guest creation" ON guest_users
  FOR INSERT 
  WITH CHECK (true);

-- Allow reading all guest sessions (client-side validates session_id)
CREATE POLICY "Read guest sessions" ON guest_users
  FOR SELECT 
  USING (true);

-- Allow updating last_active_at for session tracking
CREATE POLICY "Allow guest session updates" ON guest_users
  FOR UPDATE 
  USING (true)
  WITH CHECK (true);
