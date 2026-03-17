# Complete Real-Time Tracking Setup Guide

## Current Status
✅ Driver Mode implemented and working
✅ Passenger Live Tracking screen updated with Google Maps
✅ Database configured for real-time updates
✅ Code pushed to GitHub

## What You Need to Do Now

### Step 1: Get Google Maps API Key (REQUIRED)

1. Go to: https://console.cloud.google.com
2. Create a new project or select existing one
3. Enable these APIs:
   - Maps SDK for Android
   - Maps SDK for iOS (if you plan iOS support)
4. Go to "Credentials" → "Create Credentials" → "API Key"
5. Copy your API key
6. (Recommended) Restrict the key to only Maps SDK for Android

### Step 2: Add API Key to Android App

Open file: `android/app/src/main/AndroidManifest.xml`

Find this commented section:
```xml
<!-- <meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/> -->
```

Uncomment it and replace with your actual key:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"/>
```

### Step 3: Build New APK

Run this command:
```bash
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Step 4: Test Real-Time Tracking

You need TWO phones:

**Phone 1 (Driver):**
1. Install the APK
2. Open app → Tap car icon (top right on home screen)
3. Enter driver ID: `DRV001`
4. Select a bus (e.g., "Express 101")
5. Tap "Start Tracking"
6. Keep this phone with you and move around

**Phone 2 (Passenger):**
1. Install the APK
2. Open app → Search for buses
3. Find the same bus (e.g., "Express 101")
4. Tap on the bus card
5. You should see the map with the bus location
6. As Phone 1 moves, the bus marker should update every 30 seconds

## How It Works

1. **Driver Phone** sends GPS location to Supabase every 30 seconds
2. **Supabase** stores location in `bus_locations` table
3. **Passenger Phone** subscribes to real-time updates for that bus
4. When new location arrives, map updates automatically

## Troubleshooting

### Map shows blank/grey screen
- Check if you added the Google Maps API key correctly
- Make sure Maps SDK for Android is enabled in Google Cloud Console
- Rebuild the APK after adding the key

### Bus location not updating
- Check if driver phone has GPS enabled
- Check if driver phone has internet connection
- Check if "Start Tracking" is active on driver phone
- Check Supabase dashboard → Table Editor → `bus_locations` to see if data is being inserted

### "No location data" message
- Driver needs to start tracking first
- Wait 30 seconds for first location update
- Check if bus_id matches between driver and passenger screens

### Real-time updates not working
- Check if Supabase Realtime is enabled (you already did this)
- Check internet connection on passenger phone
- Try closing and reopening the live tracking screen

## Database Check

You can verify data in Supabase:
1. Go to: https://pxtydnqkpjjlzzqnqjff.supabase.co
2. Table Editor → `bus_locations`
3. You should see new rows appearing every 30 seconds when driver is tracking

## Next Steps After Testing

Once real-time tracking works:
1. Add route polylines on map (show the bus route path)
2. Add multiple bus markers if tracking multiple buses
3. Add ETA calculation based on distance
4. Add notifications when bus is nearby
5. Improve UI with better status indicators

## Important Notes

- Driver mode uses real GPS from the phone
- Location updates every 30 seconds (configurable in `driver_tracking_screen.dart`)
- Passenger app subscribes to real-time updates via Supabase Realtime
- Both phones need internet connection
- GPS works best outdoors with clear sky view

## Files Modified

- `lib/screens/live_tracking_screen.dart` - Now uses real Google Maps
- `android/app/src/main/AndroidManifest.xml` - Needs your API key
- `pubspec.yaml` - Already has google_maps_flutter package

## Quick Commands

Build APK:
```bash
flutter build apk --release
```

Run in debug mode:
```bash
flutter run
```

Check for errors:
```bash
flutter doctor
```

Clean build:
```bash
flutter clean
flutter pub get
flutter build apk --release
```
