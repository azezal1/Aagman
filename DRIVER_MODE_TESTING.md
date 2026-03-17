# Driver Mode Testing Guide

## What We Just Added

✅ Driver Login Screen
✅ Driver Tracking Screen with GPS
✅ Automatic location updates every 30 seconds
✅ Driver Mode button in home screen

## How to Test

### Step 1: Build New APK

```bash
flutter build apk --release
```

The APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Step 2: Install on Phone

Transfer and install the new APK on your phone.

### Step 3: Access Driver Mode

1. Open the app
2. On home screen, tap the **car icon** (🚗) in top right
3. You'll see "Driver Login" screen

### Step 4: Login as Driver

1. Enter any Driver ID (e.g., "DRIVER001")
2. Select a bus from dropdown (e.g., "Bus 42A")
3. Tap "Start Tracking"

### Step 5: Grant Permissions

When prompted:
- ✅ Allow location access "While using the app"
- ✅ Or "Allow all the time" for background tracking

### Step 6: Start Tracking

1. You'll see "Driver Mode" screen
2. Tap "Start Tracking" button
3. Status will change to "Tracking active"
4. You'll see:
   - Current location (latitude, longitude)
   - Speed in km/h
   - Number of updates sent

### Step 7: Verify Data in Supabase

1. Go to your Supabase project
2. Click "Table Editor"
3. Open "bus_locations" table
4. You should see new rows appearing every 30 seconds with:
   - bus_id
   - latitude
   - longitude
   - speed
   - timestamp

### Step 8: Test Movement

1. Keep tracking active
2. Walk around with your phone
3. Watch the location and speed update
4. Check Supabase - new locations should appear

### Step 9: Stop Tracking

1. Tap "Stop Tracking" button
2. Or tap back button (will ask for confirmation)
3. Tracking stops, no more updates sent

## What Happens Behind the Scenes

```
Driver Phone (GPS)
      ↓
Every 30 seconds
      ↓
Send location to Supabase
      ↓
bus_locations table
      ↓
Real-time broadcast
      ↓
Passenger App (will show on map)
```

## Troubleshooting

### "Location services disabled"
- Go to phone Settings → Location
- Turn on Location

### "Location permission denied"
- Go to phone Settings → Apps → Bus Tracker → Permissions
- Allow Location access

### "Upload error"
- Check internet connection
- Verify Supabase credentials
- Check bus_locations table exists

### Location not updating
- Make sure you're outdoors (GPS works poorly indoors)
- Check if GPS icon shows in phone status bar
- Try restarting the app

### Speed shows 0
- Normal when standing still
- Walk/drive to see speed update

## Testing Checklist

- [ ] Driver Mode button visible on home screen
- [ ] Can access Driver Login screen
- [ ] Can select bus from dropdown
- [ ] Can start tracking
- [ ] Location permissions granted
- [ ] GPS location appears
- [ ] Speed shows correctly
- [ ] Data appears in Supabase
- [ ] Updates every 30 seconds
- [ ] Can stop tracking
- [ ] Back button shows confirmation

## Next Steps

Once driver mode is working:

1. **Test with 2 phones:**
   - Phone 1: Driver mode (tracking)
   - Phone 2: Passenger app (viewing)

2. **Update passenger app:**
   - Add Google Maps
   - Show bus location in real-time
   - See bus moving on map

3. **Deploy to actual buses:**
   - Give phones to drivers
   - Train them to use driver mode
   - Monitor in Supabase

## Tips for Drivers

**Before Starting Route:**
1. Open app
2. Tap car icon
3. Enter your ID
4. Select your bus
5. Start tracking

**During Route:**
- Keep app open (or in background)
- Phone should have data connection
- Battery should be charged

**After Route:**
- Stop tracking
- Close app

## Battery Optimization

**To save battery:**
- Reduce update frequency (change from 30 to 60 seconds)
- Use "Battery Saver" mode on phone
- Keep phone plugged into charger in bus

**Current settings:**
- Updates every 30 seconds
- High accuracy GPS
- Estimated battery usage: 10-15% per hour

## Data Usage

**Per hour of tracking:**
- ~120 location updates
- ~5-10 KB per update
- Total: ~1 MB per hour
- Daily (8 hours): ~8 MB

Very minimal data usage!

## Production Recommendations

1. **Increase update frequency for busy routes:**
   - Change from 30 to 15 seconds
   - More accurate tracking

2. **Add driver authentication:**
   - Verify driver ID with database
   - Prevent unauthorized access

3. **Add offline support:**
   - Store locations locally if no internet
   - Upload when connection restored

4. **Add notifications:**
   - Alert if tracking stops unexpectedly
   - Remind driver to start tracking

5. **Add analytics:**
   - Track total distance
   - Average speed
   - Route completion time

---

**Ready to test? Build the APK and try it out!** 🚗📱
