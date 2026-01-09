# Guest User Database Migration Guide

This guide explains how to apply the database migrations to enable guest user functionality.

## Overview

We need to apply 3 migration files to fix RLS policies that were blocking guest users:

1. **20260106_fix_guest_rls.sql** - Fix guest_users table RLS
2. **20260107_allow_guest_read_characters.sql** - Allow guests to read characters
3. **20260107_fix_guest_conversations.sql** - Fix conversations/messages RLS

## Option 1: Using Supabase CLI (Recommended)

### Prerequisites
- Supabase CLI installed (`npm install -g supabase`)
- Project linked to your Supabase project

### Steps

```bash
# Navigate to your project directory
cd e:\AI gF\craveai

# Link to your Supabase project (if not already linked)
supabase link --project-ref <your-project-ref>

# Push all migrations to Supabase
supabase db push

# Verify migrations were applied
supabase db diff
```

## Option 2: Using Supabase Dashboard SQL Editor

### Steps

1. Open your Supabase project dashboard
2. Go to **SQL Editor** in the left sidebar
3. Create a new query
4. Copy and paste the contents of each migration file **in order**:

#### Migration 1: Fix guest_users RLS
```sql
-- Copy contents from: supabase/migrations/20260106_fix_guest_rls.sql
```

#### Migration 2: Allow guest read characters
```sql
-- Copy contents from: supabase/migrations/20260107_allow_guest_read_characters.sql
```

#### Migration 3: Fix conversations/messages RLS
```sql
-- Copy contents from: supabase/migrations/20260107_fix_guest_conversations.sql
```

5. Run each migration by clicking **RUN** button
6. Verify no errors in the output

## Verification

After applying migrations, verify the policies in your Supabase dashboard:

### Check guest_users policies
1. Go to **Database** → **Tables** → **guest_users**
2. Click **Policies** tab
3. Verify these policies exist:
   - ✅ "Allow anonymous guest creation" (INSERT)
   - ✅ "Read guest sessions" (SELECT)
   - ✅ "Allow guest session updates" (UPDATE)

### Check characters policies
1. Go to **Database** → **Tables** → **characters**
2. Click **Policies** tab
3. Verify policy exists:
   - ✅ "Allow guest read characters" (SELECT)

### Check conversations policies
1. Go to **Database** → **Tables** → **conversations**
2. Click **Policies** tab
3. Verify policies exist:
   - ✅ "Guest can create conversations" (INSERT)
   - ✅ "Guest can read conversations" (SELECT)
   - ✅ "Guest can update conversations" (UPDATE)

### Check messages policies
1. Go to **Database** → **Tables** → **messages**
2. Click **Policies** tab
3. Verify policies exist:
   - ✅ "Allow message creation" (INSERT)
   - ✅ "Allow message reads" (SELECT)

## Testing

After applying migrations:

1. **Restart your Flutter app** (hot reload may not be enough)
2. **Test guest flow**:
   - Complete age verification as guest
   - Select a character (e.g., Maya)
   - Click "Chat Now"
   - Send messages (up to 5)
   - Verify no RLS errors

## Troubleshooting

### Error: "relation already exists"
- This means the migration was partially applied
- Check which policies exist in the dashboard
- Manually drop conflicting policies before rerunning

### Error: "permission denied"
- Ensure you're using the Service Role key for CLI
- Or use the Supabase dashboard which has full permissions

### Guest still can't create session
- Check browser console for exact error
- Verify all 3 migrations were applied
- Check the `guest_users` table policies in dashboard

## Rollback (If Needed)

If you need to rollback these changes:

```sql
-- Drop guest-related policies
DROP POLICY IF EXISTS "Allow anonymous guest creation" ON guest_users;
DROP POLICY IF EXISTS "Read guest sessions" ON guest_users;
DROP POLICY IF EXISTS "Allow guest session updates" ON guest_users;
DROP POLICY IF EXISTS "Allow guest read characters" ON characters;
DROP POLICY IF EXISTS "Guest can create conversations" ON conversations;
DROP POLICY IF EXISTS "Guest can read conversations" ON conversations;
DROP POLICY IF EXISTS "Guest can update conversations" ON conversations;
DROP POLICY IF EXISTS "Allow message creation" ON messages;
DROP POLICY IF EXISTS "Allow message reads" ON messages;

-- Re-apply original restrictive policies if needed
```

## Next Steps

After successful deployment:
1. Test complete guest user flow
2. Verify 5-message limit works
3. Test registration prompt after limit
4. Monitor for any RLS errors in production
