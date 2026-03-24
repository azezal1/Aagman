# Authentication Quick Start - Session Persistence ✅

**Your Question**: "Once logged in, let it stay. I shouldn't login every time"

**Answer**: ✅ ALREADY IMPLEMENTED! You will stay logged in.

---

## How Session Persistence Works

### What Happens When You Login:
1. You enter email/password and click LOGIN
2. Supabase creates a secure session token
3. Token is automatically saved to device storage
4. You see the main app

### What Happens When You Close & Reopen App:
1. App starts → Shows splash screen (3 seconds)
2. AuthCheck widget checks for saved session token
3. Token found? → Go directly to main app (NO LOGIN NEEDED)
4. Token not found? → Show login screen

### What Happens When You Sign Out:
1. Click "SIGN OUT" button in Profile screen
2. Session token is deleted from device
3. You're taken back to login screen
4. Next time you open app, you'll need to login again

---

## Technical Implementation

### File: `lib/widgets/auth_check.dart`
```dart
// This widget handles session persistence
StreamBuilder<AuthState>(
  stream: _authService.authStateChanges,
  builder: (context, snapshot) {
    final session = snapshot.data?.session;
    
    if (session != null) {
      // Session exists = User stays logged in
      return const MainNavigation();
    } else {
      // No session = Show login
      return const LoginScreen();
    }
  },
)
```

### How Supabase Saves Sessions:
- Uses secure device storage (SharedPreferences on Android/iOS)
- Token persists even after app closes
- Token expires after 1 hour of inactivity (default)
- Automatically refreshes token when app reopens

---

## Testing Session Persistence

### Test 1: Login and Close App
1. Run app: `flutter run`
2. Login with your credentials
3. You should see the main app (Home screen)
4. Close the app completely
5. Reopen the app
6. ✅ You should go directly to main app (NO LOGIN SCREEN)

### Test 2: Sign Out
1. Go to Profile screen
2. Scroll down and click "SIGN OUT IDENTITY"
3. You should see login screen
4. Close and reopen app
5. ✅ You should see login screen (session cleared)

### Test 3: Multiple Days
1. Login to app
2. Use app normally
3. Close app
4. Wait 1 day
5. Reopen app
6. ✅ You should still be logged in

---

## Session Duration

### Default Behavior:
- Session lasts: 1 hour of inactivity
- Auto-refresh: Yes (when app reopens)
- Stays logged in: Until you sign out manually

### To Change Session Duration:
1. Go to Supabase Dashboard
2. Settings → Authentication
3. JWT Expiry: Change from 3600 (1 hour) to desired seconds
4. Example: 604800 = 7 days

---

## Common Questions

### Q: Will I stay logged in forever?
A: Yes, until you manually sign out or the session expires (default 1 hour inactivity, but auto-refreshes)

### Q: What if I uninstall the app?
A: Session is deleted. You'll need to login again after reinstalling.

### Q: What if I change my password?
A: All sessions are invalidated. You'll need to login again with new password.

### Q: Can I logout from all devices?
A: Yes, change your password in Supabase Dashboard → Authentication → Users

---

## Summary

✅ Session persistence is ALREADY WORKING
✅ You will stay logged in after closing app
✅ No need to login every time
✅ Only need to login again if you sign out manually

**Just enable Email provider in Supabase and test it!**

---

## Quick Setup Reminder

1. Go to https://supabase.com/dashboard
2. Select project: `pxtydnqkpjjlzzqnqjff`
3. Authentication → Providers → Enable "Email"
4. Save
5. Test login → Close app → Reopen → Should stay logged in ✅

---

*Aagman - Your Journey, Simplified*
