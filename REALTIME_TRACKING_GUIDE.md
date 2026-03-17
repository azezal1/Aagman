# Complete Real-Time Bus Tracking Implementation Guide

## Overview
This guide will help you implement real-time GPS tracking for your buses. You'll create a system where bus drivers' phones send location updates, and passengers see buses moving on a map in real-time.

## What You'll Build

1. **GPS Tracker App** - For bus drivers (sends location)
2. **Updated Passenger App** - Shows buses on map (receives location)
3. **Database** - Stores and streams location data

## Prerequisites

✅ Your existing Aagman app
✅ Supabase account (already set up)
✅ 2 Android phones for testing (or 1 phone + emulator)
✅ Internet connection

---

## PHASE 1: Database Setup (10 minutes)

### Step 1.1: Create bus_locations Table

1. Go to your Supabase project: https://pxtydnqkpjjlzzqnqjff.supabase.co
2. Click **SQL Editor** in left sidebar
3. Click **New Query**
4. Copy and paste this SQL:

```sql
-- Create bus_locations table for real-time tracking
CREATE TABLE bus_locations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bus_id UUID REFERENCES buses(id) ON DELETE CASCADE,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  speed DECIMAL(5, 2) DEFAULT 0,
  heading INTEGER DEFAULT 0,
  timestamp TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX idx_bus_locations_bus_id ON bus_locations(bus_id);
CREATE INDEX idx_bus_locations_timestamp ON bus_locations(timestamp DESC);

-- Enable Row Level Security
ALTER TABLE bus_locations ENABLE ROW LEVEL SECURITY;

-- Allow public read access
CREATE POLICY "Anyone can view bus locations" 
  ON bus_locations FOR SELECT 
  USING (true);

-- Allow insert (for GPS tracker app)
CREATE POLICY "Anyone can insert bus locations" 
  ON bus_locations FOR INSERT 
  WITH CHECK (true);

-- Enable real-time
ALTER PUBLICATION supabase_realtime ADD TABLE bus_locations;
```

5. Click **Run** (or Ctrl+Enter)
6. You should see: "Success. No rows returned"

### Step 1.2: Verify Table Created

1. Click **Table Editor** in left sidebar
2. You should see `bus_locations` table
3. It should have columns: id, bus_id, latitude, longitude, speed, heading, timestamp, updated_at

---

## PHASE 2: GPS Tracker App (2 hours)

This app runs on bus driver's phone and sends GPS location every 30 seconds.

### Step 2.1: Create New Flutter Project

```bash
cd C:\Users\Hp\Desktop
flutter create bus_gps_tracker
cd bus_gps_tracker
```

### Step 2.2: Add Dependencies

Open `pubspec.yaml` and add:

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.5.0
  geolocator: ^11.0.0
  permission_handler: ^11.0.0
```

Run:
```bash
flutter pub get
```

### Step 2.3: Update AndroidManifest.xml

File: `android/app/src/main/AndroidManifest.xml`

Add these permissions inside `<manifest>` tag:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

### Step 2.4: Create GPS Tracker App Code

I'll create the complete tracker app code in the next steps...

---

## PHASE 3: Update Passenger App (1 hour)

### Step 3.1: Add Google Maps Dependency

In your Aagman project, update `pubspec.yaml`:

```yaml
dependencies:
  google_maps_flutter: ^2.5.0  # Already added
```

### Step 3.2: Get Google Maps API Key

1. Go to: https://console.cloud.google.com
2. Create new project or select existing
3. Enable "Maps SDK for Android"
4. Create API key
5. Copy the API key

### Step 3.3: Add API Key to Android

File: `android/app/src/main/AndroidManifest.xml`

Find the commented section and uncomment:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual key.

### Step 3.4: Update Live Tracking Screen

The code will be updated to show real map with moving buses.

---

## PHASE 4: Testing (30 minutes)

### Step 4.1: Install GPS Tracker App

1. Build APK: `flutter build apk --release`
2. Install on bus driver's phone
3. Grant location permissions
4. Select a bus from dropdown
5. Click "Start Tracking"

### Step 4.2: Install Passenger App

1. Already built (your existing APK)
2. Install on passenger's phone
3. Open app
4. Go to Live Tracking screen

### Step 4.3: Test Real-Time Tracking

1. **Driver phone**: Start tracking
2. **Passenger phone**: Open live tracking
3. **Driver phone**: Walk around with phone
4. **Passenger phone**: Watch bus marker move in real-time!

---

## PHASE 5: Production Deployment

### For Small Scale (1-10 buses)

**Option A: Use Driver's Personal Phone**
- Install tracker app
- Give ₹200-300/month data allowance
- Total cost: ₹200-300 per bus/month

**Option B: Provide Dedicated Phone**
- Buy cheap Android phone (₹3,000-5,000)
- Install tracker app
- Mount in bus
- Total cost: ₹3,000-5,000 one-time + ₹200/month data

### For Large Scale (10+ buses)

**Option A: Professional GPS Trackers**
- Buy GPS tracker devices (₹2,000-5,000 each)
- Get SIM cards with data
- Configure to send data to Supabase
- Total cost: ₹2,000-5,000 per bus + ₹200/month

**Option B: Fleet Management System**
- Partner with GPS tracking company
- They provide hardware + software
- You integrate with their API
- Total cost: ₹500-1,000 per bus/month

---

## Cost Breakdown

### MVP Testing (Free)
- Use 2 old phones you already have
- Use existing mobile data
- **Total: ₹0**

### Small Deployment (5 buses)
- 5 cheap Android phones: ₹15,000
- 5 SIM cards with data: ₹1,000/month
- **Total: ₹15,000 one-time + ₹1,000/month**

### Professional Deployment (20 buses)
- 20 GPS trackers: ₹60,000
- 20 SIM cards: ₹4,000/month
- Supabase Pro plan: ₹2,000/month
- **Total: ₹60,000 one-time + ₹6,000/month**

---

## Next Steps

Choose your path:

### Path A: Quick Test (Recommended First)
1. I'll create the GPS tracker app code
2. You test with 2 phones
3. See it working in 1 day

### Path B: Production Ready
1. Get Google Maps API key
2. Buy/prepare phones for buses
3. Deploy to all buses
4. Launch to public

---

## Troubleshooting

### GPS Not Working
- Check location permissions granted
- Make sure GPS is enabled on phone
- Test outdoors (GPS doesn't work well indoors)

### Real-Time Not Updating
- Check internet connection
- Verify Supabase real-time is enabled
- Check browser console for errors

### App Crashes
- Check location permissions
- Verify Supabase credentials
- Check Android version (need Android 6+)

---

## Support

If you need help:
1. Check error messages in app
2. Check Supabase logs
3. Test with sample data first
4. Verify permissions granted

---

**Ready to start? Let me know which phase you want to begin with!**
