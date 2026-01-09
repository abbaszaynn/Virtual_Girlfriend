-- Add RLS policy to allow guests to read characters
-- This allows unauthenticated users to look up characters by name

-- Enable RLS if not already enabled
ALTER TABLE characters ENABLE ROW LEVEL SECURITY;

-- Drop existing read policy if it exists
DROP POLICY IF EXISTS "Allow guest read characters" ON characters;

-- Create policy to allow anyone (including guests) to read characters
CREATE POLICY "Allow guest read characters" ON characters
  FOR SELECT 
  USING (true);

-- Note: Guests can only READ characters, not CREATE/UPDATE/DELETE
-- Those operations remain restricted to authenticated users via existing policies

COMMENT ON POLICY "Allow guest read characters" ON characters IS 
  'Allows guest users to read character information to enable chat functionality';
