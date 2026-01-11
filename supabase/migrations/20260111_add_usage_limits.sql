-- Add usage tracking for daily limits
-- This migration adds user usage tracking for registered users
-- Guest users continue using their existing limit system

-- Create user_usage_tracking table
CREATE TABLE IF NOT EXISTS user_usage_tracking (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  usage_date DATE NOT NULL DEFAULT CURRENT_DATE,
  message_count INTEGER DEFAULT 0,
  image_count INTEGER DEFAULT 0,
  voice_count INTEGER DEFAULT 0,
  is_premium BOOLEAN DEFAULT FALSE,
  premium_expires_at TIMESTAMPTZ,
  last_reset_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Ensure one record per user per day
  UNIQUE(user_id, usage_date)
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_usage_user_date ON user_usage_tracking(user_id, usage_date);
CREATE INDEX IF NOT EXISTS idx_usage_premium ON user_usage_tracking(is_premium);
CREATE INDEX IF NOT EXISTS idx_usage_date ON user_usage_tracking(usage_date);

-- Enable RLS
ALTER TABLE user_usage_tracking ENABLE ROW LEVEL SECURITY;

-- Policy: Users can read their own usage data
CREATE POLICY "Users can read own usage" ON user_usage_tracking
  FOR SELECT
  USING (auth.uid() = user_id);

-- Policy: Users can insert their own usage data
CREATE POLICY "Users can insert own usage" ON user_usage_tracking
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Policy: Users can update their own usage data
CREATE POLICY "Users can update own usage" ON user_usage_tracking
  FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_usage_tracking_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update timestamp on every update
CREATE TRIGGER update_usage_tracking_timestamp
  BEFORE UPDATE ON user_usage_tracking
  FOR EACH ROW
  EXECUTE FUNCTION update_usage_tracking_timestamp();

-- Function to clean up old usage data (keep last 30 days)
CREATE OR REPLACE FUNCTION cleanup_old_usage_data()
RETURNS void AS $$
BEGIN
  DELETE FROM user_usage_tracking
  WHERE usage_date < CURRENT_DATE - INTERVAL '30 days';
END;
$$ LANGUAGE plpgsql;

-- Add comments for documentation
COMMENT ON TABLE user_usage_tracking IS 'Tracks daily usage limits for registered users (10 messages, 2 images, 2 voice per day). Premium users bypass all limits.';
COMMENT ON COLUMN user_usage_tracking.message_count IS 'Number of messages sent today (max 10 for free users)';
COMMENT ON COLUMN user_usage_tracking.image_count IS 'Number of images generated today (max 2 for free users)';
COMMENT ON COLUMN user_usage_tracking.voice_count IS 'Number of voice messages played today (max 2 for free users)';
COMMENT ON COLUMN user_usage_tracking.is_premium IS 'Whether user has premium access (unlimited usage)';
