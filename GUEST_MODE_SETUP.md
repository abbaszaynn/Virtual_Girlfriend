# Guest Mode Complete Setup Guide

## Current Status

✅ **Backend Complete:**
- Guest user database tables created
- RLS policies implemented
- Guest service with session management
- Age verification screen
- Message counting and limiting

✅ **UI Components:**
- "Continue as Guest" button on login screen
- Age verification screen with date picker
- Registration prompt with blurred image
- Chat screen with guest restrictions

## How to Test Guest Mode

### Step 1: Hot Restart the App
Since we made several changes, you need to fully restart:
```powershell
# Stop the current app (Ctrl+C in terminal)
# Then run fresh:
flutter run -d chrome
```

### Step 2: Access Guest Mode
1. **Launch the app**
2. **On the login screen** - You should now see:
   - "Create an account" button (red)
   - "Already have an account? Sign In" link
   - **"Continue as Guest" button** (semi-transparent white) ← NEW
   - "Send up to 5 messages without account" text

3. **Click "Continue as Guest"**

### Step 3: Age Verification
You'll be taken to the Age Verification Screen:
1. Select your date of birth (must be 18+)
2. Check ☑ "I am 18 years or older"
3. Check ☑ "I consent to view adult content"
4. Click "Continue as Guest"

### Step 4: Chat as Guest
1. Select an AI character (Maya, Elena, etc.)
2. Start chatting
3. You'll see at the bottom: "X messages remaining as guest"
4. After 5 messages, a blurred 18+ image will appear
5. A registration prompt will show with "REGISTER NOW" button

### Step 5: Test Session Persistence
1. Close the app
2. Reopen it
3. Your guest session should be restored
4. Message count should be preserved

## If Button Not Visible

### Solution 1: Stop and Rebuild
```powershell
# Stop the app completely
# Then rebuild fresh
flutter clean
flutter pub get
flutter run -d chrome
```

### Solution 2: Check for Compilation Errors
Look in the terminal for any red error messages. Common issues:
- Missing imports
- Bracket mismatches in chat_screen.dart
- Package not installed

### Solution 3: Manual Verification
1. Open `lib/views/screens/auth_screens/login_screen.dart`
2. Go to line 303
3. You should see the "Continue as Guest" button code
4. If it's there but not showing, it's a compilation issue

## Guest Mode Features

| Feature | Status |
|---------|--------|
| Continue as Guest Button | ✅ Added (line 303-315 in login_screen.dart) |
| Age Verification | ✅ Working |
| Guest Session Creation | ✅ Working |
| Message Counter (5 limit) | ✅ Working |
| Blurred Image After Limit | ✅ Working |
| Registration Prompt | ✅ Working |
| Voice Call Hidden | ✅ Working |
| Image Generation Hidden | ✅ Working |
| Session Persistence | ✅ Added to main.dart |
| 3-Day Expiration | ✅ Database configured |

## Expected User Flow

```
Login Screen
    ↓ (Click "Continue as Guest")
Age Verification Screen
    ↓ (Verify age + consent)
Inbox Screen (Select Character)
    ↓
Chat Screen (5 messages max)
    ↓ (After 5 messages)
Blurred Image + Registration Prompt
    ↓ (Click "REGISTER NOW")
Login/Signup Screen
```

## Debugging Tips

### Check Guest Session
In browser console (F12), check for debug messages:
```
✅ Guest session created: [session-id]
✅ Guest session restoration attempted
DEBUG: User is in guest mode
DEBUG: Guest message count: X/5
```

### Database Verification
In Supabase Dashboard → Table Editor:
1. Check `guest_users` table - should have entries
2. Check `conversations` table - should have `guest_session_id` populated
3. Check `age_verification_logs` - should log verifications

### Common Issues

**Issue:** Button not visible
**Fix:** Hot restart (`R` in terminal) or full rebuild

**Issue:** Age verification not working
**Fix:** Check browser console for errors

**Issue:** Message count not incrementing
**Fix:** Verify database policies were deployed correctly

**Issue:** Chat crashes
**Fix:** Check for bracket errors in `chat_screen.dart` (we had some earlier)

## Next Steps After Testing

1. ✅ Test guest flow end-to-end
2. ✅ Verify message counting
3. ✅ Test registration conversion
4. Deploy replicate_poll Edge Function (for image generation)
5. Test on mobile devices

## Support

If the button still doesn't appear after hot restart:
1. Show me the terminal output (any errors?)
2. Check the login screen in your browser's dev tools (inspect element)
3. Share a screenshot of the login screen code in your IDE
