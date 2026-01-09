# Database Deployment Guide

## Prerequisites

Before deploying, ensure you have:
- Access to your Supabase project dashboard
- Supabase CLI installed (optional but recommended)
- Database connection credentials

---

## Method 1: Supabase Dashboard (Recommended for Beginners)

### Step 1: Access SQL Editor

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: **CraveAI**
3. Click on **SQL Editor** in the left sidebar

### Step 2: Run Migration Files

You need to run the migration files in order:

#### Migration 1: Create Guest System Tables

1. Open file: `supabase/migrations/20260106_create_guest_system.sql`
2. Copy the entire contents
3. In Supabase SQL Editor, paste the SQL
4. Click **Run** button
5. Verify success message appears

#### Migration 2: Set Up Security Policies

1. Open file: `supabase/migrations/20260106_guest_system_policies.sql`
2. Copy the entire contents  
3. In a new SQL Editor tab, paste the SQL
4. Click **Run** button
5. Verify success message appears

### Step 3: Verify Tables Created

1. Click **Table Editor** in left sidebar
2. You should see these new tables:
   - `guest_users`
   - `age_verification_logs`
3. Click **Database** → **Tables** to see the updated `conversations` table with new columns:
   - `guest_message_count`
   - `guest_limit_reached`
   - `guest_session_id`

### Step 4: Enable Scheduled Cleanup (Optional)

> **Note**: This requires pg_cron extension which may need to be enabled first.

1. Go to **Database** → **Extensions**
2. Search for `pg_cron` and enable it
3. In SQL Editor, run:
   ```sql
   SELECT cron.schedule(
     'cleanup-expired-guests',
     '0 2 * * *',
     $$SELECT cleanup_expired_guests()$$
   );
   ```
4. This will run cleanup daily at 2 AM

---

## Method 2: Supabase CLI (Recommended for Production)

### Step 1: Install Supabase CLI

```bash
# Windows (PowerShell)
scoop install supabase

# Or download from GitHub releases
```

### Step 2: Link to Your Project

```bash
cd "e:\AI gF\craveai"
supabase login
supabase link --project-ref YOUR_PROJECT_REF
```

To find your project ref:
- Go to Supabase Dashboard → Settings → General
- Copy the "Reference ID"

### Step 3: Push Migrations

```bash
# This will apply all migrations in supabase/migrations/
supabase db push
```

### Step 4: Verify Deployment

```bash
# Check migration status
supabase migration list

# You should see:
# ✓ 20260106_create_guest_system
# ✓ 20260106_guest_system_policies
```

---

## Method 3: Direct Database Connection (Advanced)

If you prefer to connect directly:

### Step 1: Get Connection String

1. Go to Supabase Dashboard → Settings → Database
2. Copy the **Connection string** (choose Transaction or Session mode)
3. Replace `[YOUR-PASSWORD]` with your database password

### Step 2: Connect via psql

```bash
psql "postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres"
```

### Step 3: Run Migrations

```sql
-- Copy and paste the contents of each migration file
\i supabase/migrations/20260106_create_guest_system.sql
\i supabase/migrations/20260106_guest_system_policies.sql
```

---

## Verification Checklist

After deployment, verify everything is working:

### ✅ Tables Exist

Run this query in SQL Editor:
```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('guest_users', 'age_verification_logs');
```

Expected: 2 rows returned

### ✅ Columns Added to Conversations

```sql
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'conversations' 
AND column_name IN ('guest_message_count', 'guest_limit_reached', 'guest_session_id');
```

Expected: 3 rows returned

### ✅ RLS Policies Active

```sql
SELECT schemaname, tablename, policyname 
FROM pg_policies 
WHERE tablename IN ('guest_users', 'age_verification_logs', 'conversations', 'messages');
```

Expected: Multiple policies listed

### ✅ Cleanup Function Exists

```sql
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_name = 'cleanup_expired_guests';
```

Expected: 1 row returned

---

## Rollback (If Needed)

If something goes wrong, you can rollback:

```sql
-- Drop tables in reverse order
DROP TABLE IF EXISTS age_verification_logs CASCADE;
DROP TABLE IF EXISTS guest_users CASCADE;

-- Remove columns from conversations
ALTER TABLE conversations 
DROP COLUMN IF EXISTS guest_message_count,
DROP COLUMN IF EXISTS guest_limit_reached,
DROP COLUMN IF EXISTS guest_session_id;

-- Drop function
DROP FUNCTION IF EXISTS cleanup_expired_guests CASCADE;
```

---

## Common Issues & Solutions

### Issue: "relation already exists"
**Solution**: Tables already created. Safe to ignore or drop and recreate.

### Issue: "permission denied"
**Solution**: Make sure you're using the service role key or have proper permissions.

### Issue: "extension pg_cron not available"
**Solution**: pg_cron might not be available on your plan. Skip the scheduled cleanup or implement it in your application.

### Issue: RLS blocking operations
**Solution**: Verify you're using the correct authentication token in your app.

---

## Next Steps

After successful deployment:

1. ✅ Test guest user creation from Flutter app
2. ✅ Verify message counting works
3. ✅ Test age verification logging
4. ✅ Confirm 3-day expiration works
5. ✅ Test guest-to-user conversion

---

## Support

If you encounter issues:
- Check Supabase logs: Dashboard → Logs → Database
- Review migration files for syntax errors
- Ensure your Supabase project is on a plan that supports all features
