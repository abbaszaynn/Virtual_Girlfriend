-- Create guest_users table for temporary guest sessions
CREATE TABLE IF NOT EXISTS guest_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id TEXT UNIQUE NOT NULL,
  device_fingerprint TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_active_at TIMESTAMPTZ DEFAULT NOW(),
  expires_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '3 days'),
  converted_to_user_id UUID REFERENCES auth.users(id),
  is_converted BOOLEAN DEFAULT FALSE,
  age_verified BOOLEAN DEFAULT FALSE,
  consent_given BOOLEAN DEFAULT FALSE,
  ip_address TEXT,
  user_agent TEXT
);

-- Create indexes for performance
CREATE INDEX idx_guest_session ON guest_users(session_id);
CREATE INDEX idx_guest_expires ON guest_users(expires_at);
CREATE INDEX idx_guest_converted ON guest_users(is_converted);

-- Create age_verification_logs table for audit trail
CREATE TABLE IF NOT EXISTS age_verification_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  guest_session_id TEXT REFERENCES guest_users(session_id),
  user_id UUID REFERENCES auth.users(id),
  verified_at TIMESTAMPTZ DEFAULT NOW(),
  ip_address TEXT,
  verification_method TEXT,
  country_code TEXT,
  consent_version TEXT
);

-- Add guest tracking columns to conversations table
ALTER TABLE conversations 
ADD COLUMN IF NOT EXISTS guest_message_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS guest_limit_reached BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS guest_session_id TEXT REFERENCES guest_users(session_id);

-- Create index for guest session lookups
CREATE INDEX IF NOT EXISTS idx_conversation_guest_session ON conversations(guest_session_id);

-- Comment for documentation
COMMENT ON TABLE guest_users IS 'Stores temporary guest user sessions with 3-day expiration';
COMMENT ON TABLE age_verification_logs IS 'Audit trail for age verification compliance (18+ platform)';
COMMENT ON COLUMN conversations.guest_message_count IS 'Tracks message count for 5-message guest limit';
