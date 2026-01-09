-- Fix conversations table to allow null driver_user_id for guest users
-- Guest conversations use guest_session_id instead of driver_user_id

ALTER TABLE conversations 
  ALTER COLUMN driver_user_id DROP NOT NULL;

-- Add comment to clarify the usage
COMMENT ON COLUMN conversations.driver_user_id IS 
  'User ID for authenticated users. NULL for guest users (who use guest_session_id instead)';

COMMENT ON COLUMN conversations.guest_session_id IS 
  'Session ID for guest users. NULL for authenticated users (who use driver_user_id instead)';

-- Ensure at least one of them is set (optional check constraint)
ALTER TABLE conversations
  ADD CONSTRAINT check_user_or_guest 
  CHECK (
    (driver_user_id IS NOT NULL AND guest_session_id IS NULL) OR
    (driver_user_id IS NULL AND guest_session_id IS NOT NULL)
  );
