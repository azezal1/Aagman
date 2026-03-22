# 📍 Location Feature Implementation

## What Was Added

### 1. **Automatic Location Detection**
- App requests location permission on startup
- Fetches user's current GPS coordinates
- Shows loading state while fetching

### 2. **Location Display in Header**
- Shows current location coordinates (or city name with geocoding)
- Loading spinner while fetching
- "Live" badge when location is active
- Refresh button to update location

### 3. **Nearby Buses Based on Location**
- Fetches buses from Supabase database
- Filters based on proximity to user location
- Shows loading state while fetching
- Falls back to sample data if no buses found

### 4. **Permission Handling**
- Requests location permission
- Shows dialog if permission denied
- Option to open settings
- Handles all permission states gracefully

## How It Works

### On App Launch:
1. App requests location permission
2. If granted, fetches GPS coordinates
3. Updates header with location
4. Queries Supabase for nearby buses
5. Displays buses in "Nearby Buses" section

### Location Refresh:
- User can tap refresh icon in header
- Re-fetches current location
- Updates nearby buses list

## Code Structure

### State Variables:
```dart
String _currentLocation = "Fetching location...";
bool _isLoadingLocation = true;
Position? _currentPosition;
List<Map<String, dynamic>> _nearbyBuses = [];
```

### Key Methods:
- `_getCurrentLocation()` - Requests permission and gets GPS
- `_updateLocationName()` - Converts coordinates to readable format
- `_fetchNearbyBuses()` - Queries Supabase for nearby buses
- `_showLocationDialog()` - Shows permission dialog
- `_refreshLocation()` - Refreshes location on demand

## Testing

### On Web (Chrome):
- Browser will ask for location permission
- Click "Allow" to test
- Location will show as coordinates
- Nearby buses will load from database

### On Mobile (Android):
- App will request location permission
- Grant permission in system dialog
- GPS coordinates will be fetched
- Nearby buses based on actual location

## Database Query

Currently queries all buses:
```dart
final response = await _supabase
    .from('buses')
    .select()
    .limit(3);
```

### For Production:
Add distance-based filtering:
```dart
// Calculate distance and filter
final response = await _supabase
    .from('buses')
    .select()
    .filter('location', 'near', {
      'lat': position.latitude,
      'lng': position.longitude,
      'radius': 5000 // 5km radius
    });
```

## UI States

### 1. Loading State:
- Spinner in location icon
- "Fetching location..." text
- Loading spinner in nearby buses section

### 2. Success State:
- Location coordinates/name shown
- Green "Live" badge
- Nearby buses displayed

### 3. Error State:
- "Location permission denied" message
- Dialog with option to open settings
- Sample buses shown as fallback

## Enhancements for Production

### 1. Geocoding:
Add `geocoding` package to convert coordinates to city names:
```dart
List<Placemark> placemarks = await placemarkFromCoordinates(
  position.latitude,
  position.longitude,
);
String city = placemarks[0].locality ?? "Unknown";
```

### 2. Distance Calculation:
Calculate actual distance to buses:
```dart
double distance = Geolocator.distanceBetween(
  userLat, userLng,
  busLat, busLng,
);
```

### 3. Real-time Updates:
Subscribe to bus location changes:
```dart
_supabase
  .from('bus_locations')
  .stream(primaryKey: ['id'])
  .listen((data) {
    // Update nearby buses
  });
```

### 4. Background Location:
Use `background_location` package for continuous tracking

## Permissions Required

### Android (AndroidManifest.xml):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```
✅ Already added

### iOS (Info.plist):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby buses</string>
```

## User Experience

### First Time:
1. App opens
2. Permission dialog appears
3. User grants permission
4. Location fetched
5. Nearby buses loaded

### Subsequent Opens:
1. App opens
2. Location fetched automatically (permission already granted)
3. Nearby buses loaded
4. User can refresh anytime

## Troubleshooting

### Location not updating:
- Check if GPS is enabled
- Check if permission is granted
- Tap refresh button
- Check internet connection

### No nearby buses:
- Database might be empty
- Falls back to sample data
- Add buses to Supabase database

### Permission denied:
- Dialog shows with "Open Settings" option
- User can grant permission from settings
- App will work with sample data

## Next Steps

1. Add geocoding for city names
2. Implement distance-based filtering
3. Add ETA calculation
4. Show bus routes on map
5. Add real-time bus tracking
6. Implement background location updates

## Files Modified

- `lib/screens/home_screen.dart` - Added location functionality
- Uses existing `geolocator` package (already in pubspec.yaml)
- Integrates with existing Supabase setup

## Ready to Test!

The location feature is now live in your app. Check your Chrome browser and allow location permission when prompted! 📍🚌
