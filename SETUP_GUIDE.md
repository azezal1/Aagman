# Quick Setup Guide

## Step 1: Install Flutter

If you haven't already, install Flutter from [flutter.dev](https://flutter.dev)

## Step 2: Install Dependencies

```bash
flutter pub get
```

## Step 3: Set Up Supabase

### Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and create a free account
2. Create a new project
3. Wait for the project to be ready (takes 1-2 minutes)

### Get Your Credentials

1. Go to Project Settings > API
2. Copy your:
   - Project URL (looks like: `https://xxxxx.supabase.co`)
   - Anon/Public Key (long string starting with `eyJ...`)

### Update App Configuration

Open `lib/main.dart` and replace:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',  // Paste your Project URL here
  anonKey: 'YOUR_SUPABASE_ANON_KEY',  // Paste your Anon Key here
);
```

### Create Database Tables

1. In Supabase dashboard, go to SQL Editor
2. Copy the SQL schema from `lib/config/supabase_config.dart`
3. Paste and run it in the SQL Editor
4. This creates all necessary tables

### Add Sample Data (Optional)

Run this SQL to add test data:

```sql
-- Insert sample locations
INSERT INTO locations (name, latitude, longitude) VALUES
('Bus Stand', 23.0225, 72.5714),
('Railway Station', 23.0300, 72.5800),
('City Center', 23.0250, 72.5750),
('Hospital', 23.0280, 72.5780),
('College', 23.0320, 72.5820),
('Market', 23.0260, 72.5760);

-- Insert sample buses
INSERT INTO buses (name, type, fare) VALUES
('Bus 42A', 'Government', 25),
('Express 18', 'Private', 45),
('Bus 7B', 'Government', 20);
```

## Step 4: Run the App

### For Android

```bash
flutter run
```

### For iOS

```bash
flutter run
```

### For Web (Testing)

```bash
flutter run -d chrome
```

## Step 5: Test the App

1. App should open with splash screen
2. Navigate to home screen
3. Select "From" and "To" locations
4. Click "Show Bus Details"
5. View bus list, filters, and tracking screens

## Optional: Google Maps Setup

For live tracking with real maps:

### Android

1. Get Google Maps API key from [Google Cloud Console](https://console.cloud.google.com)
2. Enable Maps SDK for Android
3. Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_API_KEY_HERE"/>
</application>
```

### iOS

1. Enable Maps SDK for iOS
2. Add to `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
```

## Troubleshooting

### "Supabase not initialized" error
- Make sure you've added your credentials in `lib/main.dart`
- Check that credentials are correct (no extra spaces)

### "Table does not exist" error
- Run the SQL schema in Supabase SQL Editor
- Verify tables were created in Table Editor

### Build errors
- Run `flutter clean` then `flutter pub get`
- Make sure Flutter SDK is up to date: `flutter upgrade`

### Map not showing
- Google Maps integration is optional
- The app works without it (shows placeholder)
- Follow Optional Google Maps Setup above to enable

## Next Steps

1. Customize colors in `lib/config/theme.dart`
2. Add real bus data to Supabase tables
3. Implement real-time tracking with GPS coordinates
4. Add push notifications
5. Deploy to Play Store / App Store

## Support

For issues or questions:
- Check Flutter documentation: [flutter.dev/docs](https://flutter.dev/docs)
- Check Supabase documentation: [supabase.com/docs](https://supabase.com/docs)
