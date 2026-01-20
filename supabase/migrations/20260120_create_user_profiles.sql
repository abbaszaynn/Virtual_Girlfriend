-- Create user_profiles table for storing user profile information
-- This table links to auth.users and stores additional profile data

CREATE TABLE IF NOT EXISTS user_profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  display_name text,
  avatar_url text,
  preferred_role text DEFAULT 'How do you want Maya to support?',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can view their own profile
CREATE POLICY "Users can view own profile"
  ON user_profiles FOR SELECT
  USING (auth.uid() = user_id);

-- RLS Policy: Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS Policy: Users can insert their own profile
CREATE POLICY "Users can insert own profile"
  ON user_profiles FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_user_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call the function before each update
CREATE TRIGGER update_user_profiles_updated_at
  BEFORE UPDATE ON user_profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_user_profiles_updated_at();

-- Add comment for documentation
COMMENT ON TABLE user_profiles IS 'Stores additional user profile information beyond auth.users';
COMMENT ON COLUMN user_profiles.user_id IS 'References auth.users.id, ensures one profile per user';
COMMENT ON COLUMN user_profiles.display_name IS 'User''s chosen display name';
COMMENT ON COLUMN user_profiles.avatar_url IS 'URL to user''s profile picture';
COMMENT ON COLUMN user_profiles.preferred_role IS 'User''s preferred interaction style with AI';
