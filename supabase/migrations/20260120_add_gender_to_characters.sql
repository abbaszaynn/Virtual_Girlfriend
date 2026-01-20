-- Add gender column to characters table
-- This allows male, female, and non-binary character creation

ALTER TABLE characters
ADD COLUMN IF NOT EXISTS gender TEXT DEFAULT 'Female';

-- Add a comment to the column
COMMENT ON COLUMN characters.gender IS 'Character gender: Male, Female, or Non-binary';
