# Google Sign-In Setup Information

## Your App Details for Google Cloud Console

### 📱 Application Type
**Android Application**

---

### 📦 Package Name
```
com.aagman.app
```

---

### 🔐 SHA-1 Fingerprint Certificate

#### Debug Certificate (for development/testing):
```
2F:B6:19:54:A2:DF:69:A1:E3:AC:15:83:F3:D4:0D:FB:B5:37:8F:7B
```

#### SHA-256 (also available):
```
EF:AF:C3:A8:D4:4F:08:66:BA:E6:5E:E5:01:A5:0D:E0:9A:3C:31:5F:CD:79:46:13:3C:A2:BB:88:CD:EF:67:27
```

#### Certificate Details:
- **Store**: `C:\Users\Hp\.android\debug.keystore`
- **Alias**: AndroidDebugKey
- **Valid Until**: Sunday, February 27, 2056

---

## Step-by-Step Setup Guide

### Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Click "Select a project" → "New Project"
3. Enter project name: **Aagman Bus Tracker**
4. Click "Create"

---

### Step 2: Enable Google+ API

1. In your project, go to "APIs & Services" → "Library"
2. Search for "Google+ API"
3. Click on it and click "Enable"

---

### Step 3: Create OAuth 2.0 Credentials

1. Go to "APIs & Services" → "Credentials"
2. Click "Create Credentials" → "OAuth client ID"
3. If prompted, configure OAuth consent screen first:
   - User Type: **External**
   - App name: **Aagman**
   - User support email: Your email
   - Developer contact: Your email
   - Click "Save and Continue"
   - Scopes: Skip for now
   - Test users: Add your email
   - Click "Save and Continue"

4. Back to Create OAuth client ID:
   - Application type: **Android**
   - Name: **Aagman Android App**
   - Package name: `com.aagman.app`
   - SHA-1 certificate fingerprint: `2F:B6:19:54:A2:DF:69:A1:E3:AC:15:83:F3:D4:0D:FB:B5:37:8F:7B`
   - Click "Create"

5. You'll see your Client ID - copy it!

---

### Step 4: Configure Supabase

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project: `pxtydnqkpjjlzzqnqjff`
3. Go to "Authentication" → "Providers"
4. Find "Google" and click to expand
5. Enable the toggle
6. Enter your credentials:
   - **Client ID**: (paste from Google Cloud Console)
   - **Client Secret**: (paste from Google Cloud Console)
7. Copy the "Authorized redirect URIs":
   ```
   https://pxtydnqkpjjlzzqnqjff.supabase.co/auth/v1/callback
   ```
8. Click "Save"

---

### Step 5: Add Redirect URI to Google Cloud

1. Go back to Google Cloud Console
2. Go to "APIs & Services" → "Credentials"
3. Click on your OAuth 2.0 Client ID
4. Under "Authorized redirect URIs", click "Add URI"
5. Paste: `https://pxtydnqkpjjlzzqnqjff.supabase.co/auth/v1/callback`
6. Click "Save"

---

## Quick Copy-Paste Values

### For Google Cloud Console:

**Application Type:**
```
Android
```

**Package Name:**
```
com.aagman.app
```

**SHA-1 Fingerprint:**
```
2F:B6:19:54:A2:DF:69:A1:E3:AC:15:83:F3:D4:0D:FB:B5:37:8F:7B
```

### For Supabase:

**Redirect URI:**
```
https://pxtydnqkpjjlzzqnqjff.supabase.co/auth/v1/callback
```

---

## Testing Google Sign-In

### After Setup:

1. Run your app:
   ```bash
   flutter run
   ```

2. On login screen, ensure "PASSENGER" is selected

3. Click "CONTINUE WITH GOOGLE"

4. Select your Google account

5. ✅ Should navigate to Home screen

6. Close and reopen app

7. ✅ Should stay logged in

---

## Important Notes

### ⚠️ Debug vs Release Certificates

**Current Setup**: Debug certificate (for development)

**For Production Release**, you'll need to:
1. Generate a release keystore
2. Get the SHA-1 from release keystore
3. Add it to Google Cloud Console
4. Update your app's signing config

### Generate Release Keystore:
```bash
keytool -genkey -v -keystore aagman-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias aagman
```

### Get Release SHA-1:
```bash
keytool -list -v -keystore aagman-release-key.jks -alias aagman
```

---

## Troubleshooting

### Issue: "Sign-in failed"
**Solution**: 
- Verify package name matches exactly
- Verify SHA-1 fingerprint is correct
- Check Google Cloud Console credentials are enabled

### Issue: "Developer Error"
**Solution**:
- Package name mismatch
- SHA-1 fingerprint mismatch
- OAuth client not properly configured

### Issue: "Redirect URI mismatch"
**Solution**:
- Add Supabase redirect URI to Google Cloud Console
- Format: `https://[PROJECT_REF].supabase.co/auth/v1/callback`

---

## Summary

✅ **Application Type**: Android  
✅ **Package Name**: `com.aagman.app`  
✅ **SHA-1 Debug**: `2F:B6:19:54:A2:DF:69:A1:E3:AC:15:83:F3:D4:0D:FB:B5:37:8F:7B`  
✅ **Redirect URI**: `https://pxtydnqkpjjlzzqnqjff.supabase.co/auth/v1/callback`  

**Next Steps**:
1. Create Google Cloud project
2. Enable Google+ API
3. Create OAuth credentials with above details
4. Configure Supabase with Client ID/Secret
5. Test Google Sign-In in your app

---

*Aagman - Your Journey, Simplified*
