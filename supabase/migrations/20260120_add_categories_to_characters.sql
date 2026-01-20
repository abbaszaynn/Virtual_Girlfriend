-- Add categories column to characters table to support filtering
ALTER TABLE characters
ADD COLUMN IF NOT EXISTS categories text[] DEFAULT ARRAY['Custom']::text[];

-- Add comment for documentation
COMMENT ON COLUMN characters.categories IS 'Array of category tags for filtering (Flirty, Romantic, Shy, etc.)';

-- Create index for faster category filtering
CREATE INDEX IF NOT EXISTS idx_characters_categories ON characters USING GIN (categories);
