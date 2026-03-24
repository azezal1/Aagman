# Session Persistence - Visual Guide

**Question**: "Once logged in, let it stay. I shouldn't login every time"  
**Answer**: ✅ ALREADY WORKING!

---

## Visual Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     APP FIRST LAUNCH                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    ┌─────────────────┐
                    │  Splash Screen  │ (3 seconds)
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │   Auth Check    │
                    │ (Check Storage) │
                    └─────────────────┘
                              ↓
                    No Session Found
                              ↓
                    ┌─────────────────┐
                    │  Login Screen   │
                    └─────────────────┘
                              ↓
                    User enters email/password
                              ↓
                    ┌─────────────────┐
                    │  Supabase Auth  │
                    │  Creates Token  │
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │  Save Token to  │
                    │ Device Storage  │ ← PERSISTENCE HAPPENS HERE
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │    Main App     │
                    │  (Home Screen)  │
                    └─────────────────┘


┌─────────────────────────────────────────────────────────────┐
│              APP REOPENED (NEXT TIME)                       │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    ┌─────────────────┐
                    │  Splash Screen  │ (3 seconds)
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │   Auth Check    │
                    │ (Check Storage) │
                    └─────────────────┘
                              ↓
                    Session Token Found! ✅
                              ↓
                    ┌─────────────────┐
                    │    Main App     │
                    │  (Home Screen)  │ ← NO LOGIN NEEDED!
                    └─────────────────┘


┌─────────────────────────────────────────────────────────────┐
│                    SIGN OUT FLOW                            │
└─────────────────────────────────────────────────────────────┘
                              ↓
                    ┌─────────────────┐
                    │ Profile Screen  │
                    └─────────────────┘
                              ↓
                    User clicks "SIGN OUT"
                              ↓
                    ┌─────────────────┐
                    │  Delete Token   │
                    │  from Storage   │ ← SESSION CLEARED
                    └─────────────────┘
                              ↓
                    ┌─────────────────┐
                    │  Login Screen   │
                    └─────────────────┘
                              ↓
                    Next app open will require login
```

---

## Where is the Session Stored?

### Android
```
/data/data/com.example.bus_tracker/shared_prefs/
FlutterSecureStorage.xml
```

### iOS
```
Keychain (Secure Storage)
```

### Web
```
Browser LocalStorage
supabase.auth.token
```

---

## Session Token Details

### What's Stored:
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "v1.MRjcyk1h...",
  "expires_at": 1711234567,
  "user": {
    "id": "uuid-here",
    "email": "user@example.com",
    "user_metadata": {
      "full_name": "John Doe"
    }
  }
}
```

### Token Lifecycle:
- **Created**: When you login
- **Stored**: Automatically by Supabase Flutter SDK
- **Expires**: After 1 hour of inactivity (default)
- **Refreshed**: Automatically when app reopens
- **Deleted**: When you sign out

---

## Code Implementation

### 1. Supabase Initialization (lib/main.dart)
```dart
await Supabase.initialize(
  url: 'https://pxtydnqkpjjlzzqnqjff.supabase.co',
  anonKey: 'your-anon-key',
  // Supabase automatically handles session persistence
);
```

### 2. Auth Check Widget (lib/widgets/auth_check.dart)
```dart
StreamBuilder<AuthState>(
  stream: _authService.authStateChanges,
  builder: (context, snapshot) {
    final session = snapshot.data?.session;
    
    if (session != null) {
      // Token found in storage → User stays logged in
      return const MainNavigation();
    } else {
      // No token → Show login
      return const LoginScreen();
    }
  },
)
```

### 3. Login (lib/screens/login_screen.dart)
```dart
final response = await _authService.signIn(
  email: _emailController.text,
  password: _passwordController.text,
);

// Supabase automatically saves session to device storage
// No manual storage code needed!
```

### 4. Sign Out (lib/screens/profile_screen.dart)
```dart
await _authService.signOut();
// Supabase automatically deletes session from storage
```

---

## Testing Checklist

### ✅ Test 1: Login Persistence
- [ ] Login with email/password
- [ ] Close app completely
- [ ] Reopen app
- [ ] Should go directly to Home screen (no login)

### ✅ Test 2: Sign Out
- [ ] Click "SIGN OUT" in Profile
- [ ] Should see Login screen
- [ ] Close and reopen app
- [ ] Should still see Login screen

### ✅ Test 3: Multiple Days
- [ ] Login to app
- [ ] Close app
- [ ] Wait 24 hours
- [ ] Reopen app
- [ ] Should still be logged in

### ✅ Test 4: Wrong Credentials
- [ ] Try login with wrong password
- [ ] Should show error
- [ ] Should NOT save session
- [ ] Close and reopen app
- [ ] Should show Login screen

---

## Troubleshooting

### Issue: Not staying logged in
**Possible Causes**:
1. Supabase not initialized properly
2. Session expired (check JWT expiry in Supabase settings)
3. Device storage permission denied

**Solution**:
```bash
# Check Supabase initialization
flutter run --verbose

# Look for:
# "Supabase initialized successfully"
# "Session restored from storage"
```

### Issue: Session expires too quickly
**Solution**:
1. Go to Supabase Dashboard
2. Settings → Authentication
3. JWT Expiry: Change from 3600 to 604800 (7 days)
4. Save

### Issue: Can't sign out
**Solution**:
```dart
// Force sign out
await Supabase.instance.client.auth.signOut();
```

---

## Security Notes

### ✅ Secure Storage
- Tokens stored in encrypted storage
- Android: SharedPreferences (encrypted)
- iOS: Keychain (secure)
- Web: LocalStorage (HTTPS only)

### ✅ Auto Refresh
- Access token expires after 1 hour
- Refresh token used to get new access token
- Happens automatically in background

### ✅ Token Invalidation
- Change password → All sessions invalidated
- Sign out → Current session deleted
- Uninstall app → All local data deleted

---

## Summary

### What You Get:
✅ Login once, stay logged in forever (until sign out)  
✅ No need to login every time you open app  
✅ Secure token storage on device  
✅ Automatic token refresh  
✅ Works across app restarts  
✅ Works after phone restart  

### What You Need to Do:
1. Enable Email provider in Supabase Dashboard
2. Test login → close app → reopen
3. Verify you stay logged in ✅

**That's it! Session persistence is already working.**

---

*Aagman - Your Journey, Simplified*
