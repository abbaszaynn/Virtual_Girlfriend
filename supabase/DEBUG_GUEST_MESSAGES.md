# Guest Message Sending Debug Guide

## Quick Checks

### 1. Verify All Migrations Applied

In Supabase Dashboard → Database → Policies, check each table:

**guest_users** - Should have 3 policies:
- ✅ Allow anonymous guest creation (INSERT)
- ✅ Read guest sessions (SELECT)  
- ✅ Allow guest session updates (UPDATE)

**characters** - Should have:
- ✅ Allow guest read characters (SELECT)

**conversations** - Should have:
- ✅ Guest can create conversations (INSERT)
- ✅ Guest can read conversations (SELECT)
- ✅ Guest can update conversations (UPDATE)

**messages** - Should have:
- ✅ Allow message creation (INSERT)
- ✅ Allow message reads (SELECT)

### 2. Check Browser Console

1. Open Chrome DevTools (F12)
2. Go to Console tab
3. Try sending a message
4. Look for any RED errors
5. Screenshot and share any errors you see

### 3. Check Network Tab

1. In DevTools, go to Network tab
2. Try sending a message
3. Look for failed requests (red text or 4xx/5xx status codes)
4. Check for any `401 Unauthorized` or `403 Forbidden` errors

### 4. Verify Guest Session Created

In DevTools → Application → Storage:
- Look for `flutter.guest_session_id`
- Should have a UUID value

### 5. Check Supabase Database

Go to Supabase → Table Editor:

**guest_users** table:
- Should have your session record
- Check `session_id` matches what's in local storage

**conversations** table:
- After clicking "Chat Now", a conversation should be created
- Check if `guest_session_id` field is populated

## Common Issues & Fixes

### Issue: No policies found
**Fix**: Rerun the migrations

### Issue: 403 Forbidden on INSERT
**Fix**: RLS policies not applied correctly. Check policies in dashboard.

### Issue: Message doesn't appear
**Fix**: Check if conversation was created. Look in console for errors.

### Issue: "User not logged in" error
**Fix**: Ensure you restarted the Flutter app after code changes.

## Still Not Working?

Share screenshots of:
1. Browser console errors
2. Network tab (failed requests)
3. Supabase policies for `messages` table
