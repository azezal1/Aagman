# Aagman - Quick Reference Guide

**Version**: 2.4.0_KIN  
**Status**: ✅ PRODUCTION READY

---

## 🚀 Quick Start Commands

### Run the App
```bash
# Web (Chrome)
flutter run -d chrome

# Android Device/Emulator
flutter run -d android

# Check available devices
flutter devices
```

### Build APK
```bash
# Debug APK
flutter build apk --debug

# Release APK (Production)
flutter build apk --release

# APK location
build/app/outputs/flutter-apk/app-release.apk
```

### Development
```bash
# Get dependencies
flutter pub get

# Check for issues
flutter analyze

# Check Flutter setup
flutter doctor

# Clean build
flutter clean
flutter pub get
flutter run
```

---

## 📁 Key Files

### Configuration
- `lib/config/theme.dart` - Complete design system
- `lib/config/supabase_config.dart` - Database credentials
- `lib/main.dart` - App entry point

### Screens (18 files)
- `lib/screens/video_splash_screen.dart` - Kinetic splash
- `lib/screens/main_navigation.dart` - Bottom navigation
- `lib/screens/home_screen.dart` - Main dashboard
- `lib/screens/search_screen.dart` - Bus search
- `lib/screens/track_screen.dart` - Active buses
- `lib/screens/profile_screen.dart` - User profile
- `lib/screens/live_tracking_screen.dart` - Real-time map
- `lib/screens/route_details_screen.dart` - Route timeline
- `lib/screens/passenger_journey_screen.dart` - Journey status
- `lib/screens/bus_search_results_screen.dart` - Search results
- `lib/screens/notifications_screen.dart` - Notifications
- `lib/screens/travel_analytics_screen.dart` - Analytics
- `lib/screens/rate_bus_screen.dart` - Rate bus
- `lib/screens/rate_driver_screen.dart` - Rate driver
- `lib/screens/report_delay_screen.dart` - Report delay
- `lib/screens/driver_login_screen.dart` - Driver auth
- `lib/screens/driver_tracking_screen.dart` - Driver GPS
- `lib/screens/feedback_screen.dart` - Feedback form

### Widgets (4 files)
- `lib/widgets/bus_card.dart` - Reusable bus card (280px)
- `lib/widgets/capacity_bar.dart` - Capacity indicator
- `lib/widgets/quick_access_button.dart` - Quick action buttons
- `lib/widgets/location_dropdown.dart` - Location selector

### Database
- `supabase_setup.sql` - Main database schema
- `supabase_community_schema.sql` - Community features schema

---

## 🎨 Design System Quick Reference

### Colors
```dart
Primary:      #2563EB  // Blue - interactive elements
Accent:       #6CF8BB  // Green - highlights
Background:   #F9F9F9  // Light grey
Surface:      #FFFFFF  // White cards
Text Primary: #1A1C1C  // Near black
Text Muted:   #434655  // Grey
Border:       #E2E2E2  // Light grey
```

### Typography
```dart
// Headlines/Labels
GoogleFonts.spaceGrotesk(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  letterSpacing: -1,
)

// Body Text
GoogleFonts.publicSans(
  fontSize: 16,
  fontWeight: FontWeight.w400,
)

// Labels (Uppercase)
GoogleFonts.spaceGrotesk(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.5,
)
```

### Layout
```dart
// Sharp corners
BorderRadius.zero

// Bold borders
Border.all(color: AppTheme.textPrimary, width: 3)

// Hard shadows
BoxShadow(
  color: AppTheme.textPrimary,
  offset: Offset(4, 4),
  blurRadius: 0,
)

// Active-press animation
onTapDown: (_) => setState(() => _isPressed = true),
onTapUp: (_) => setState(() => _isPressed = false),
transform: Matrix4.translationValues(
  _isPressed ? 2 : 0,
  _isPressed ? 2 : 0,
  0,
)
```

---

## 🗄️ Database Tables

### Core Tables
1. `buses` - Bus information (id, number, route_id, capacity, status)
2. `locations` - Stop locations (id, name, latitude, longitude, address)
3. `routes` - Route definitions (id, name, start_location_id, end_location_id)
4. `stops` - Route stops (id, route_id, location_id, stop_order, arrival_time)
5. `bus_locations` - Real-time GPS (id, bus_id, latitude, longitude, timestamp)

### Community Tables
6. `feedback` - User feedback (id, user_id, message, rating, created_at)
7. `notifications` - Push notifications (id, user_id, title, message, read)
8. `delay_reports` - Delay reports (id, bus_id, delay_minutes, reason)
9. `bus_ratings` - Bus ratings (id, bus_id, rating, comment)
10. `driver_ratings` - Driver ratings (id, driver_id, rating, comment)
11. `travel_history` - Trip history (id, user_id, bus_id, date, route)

---

## 🔑 Supabase Configuration

### Update Credentials
Edit `lib/config/supabase_config.dart`:
```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### Enable Realtime
1. Go to Supabase Dashboard
2. Navigate to Database > Replication
3. Enable realtime for `bus_locations` table

### Row Level Security
```sql
-- Enable RLS
ALTER TABLE buses ENABLE ROW LEVEL SECURITY;

-- Public read policy
CREATE POLICY "Public read access" ON buses
FOR SELECT USING (true);
```

---

## 📱 Screen Navigation Flow

```
VideoSplashScreen (2s animation)
    ↓
MainNavigation (Bottom Nav)
    ├── HomeScreen (Tab 1)
    │   ├── Search → SearchScreen
    │   ├── Nearby Bus → LiveTrackingScreen
    │   ├── Driver Mode → DriverLoginScreen
    │   └── Analytics → TravelAnalyticsScreen
    ├── SearchScreen (Tab 2)
    │   └── Bus Card → RouteDetailsScreen
    ├── TrackScreen (Tab 3)
    │   └── Bus Card → LiveTrackingScreen
    └── ProfileScreen (Tab 4)
        ├── Stats → TravelAnalyticsScreen
        ├── Achievements → (Future)
        ├── Travel History → (Future)
        └── Settings → (Future)
```

---

## 🛠️ Common Tasks

### Add a New Screen
1. Create file in `lib/screens/`
2. Import in navigation file
3. Add route in MaterialApp or Navigator
4. Follow design system (theme.dart)

### Add a New Widget
1. Create file in `lib/widgets/`
2. Use AppTheme colors and fonts
3. Implement active-press animation if interactive
4. Add 3px borders and 4px shadows

### Update Colors
Edit `lib/config/theme.dart`:
```dart
static const Color primary = Color(0xFF2563EB);
static const Color accent = Color(0xFF6CF8BB);
// ... etc
```

### Add Database Table
1. Write SQL in new file
2. Run in Supabase SQL Editor
3. Enable RLS
4. Create read/write policies
5. Enable realtime if needed

---

## 🐛 Troubleshooting

### App won't build
```bash
flutter clean
flutter pub get
flutter run
```

### Supabase connection error
- Check credentials in `supabase_config.dart`
- Verify Supabase project is active
- Check internet connection

### Location not working
- Enable location permissions in AndroidManifest.xml
- Check device location settings
- For web: use HTTPS or localhost

### Map not displaying
- Check internet connection
- Verify OpenStreetMap tiles are accessible
- Check flutter_map package version

### setState() errors
- Always check `if (!mounted) return` before setState
- Dispose controllers in dispose() method
- Cancel subscriptions in dispose()

---

## 📊 Performance Tips

### Optimize Build
```bash
# Use release mode
flutter build apk --release --split-per-abi

# Reduce APK size
flutter build apk --release --target-platform android-arm64
```

### Optimize Code
- Use `const` constructors where possible
- Implement `ListView.builder` for long lists
- Cache images with `CachedNetworkImage`
- Dispose controllers and subscriptions
- Use `RepaintBoundary` for complex widgets

### Optimize Database
- Add indexes on frequently queried columns
- Use pagination for large datasets
- Cache frequently accessed data
- Use Supabase Edge Functions for complex queries

---

## 📚 Documentation Files

### Must Read
1. **README.md** - Project overview
2. **PROJECT_STATUS_FINAL.md** - Complete status
3. **QUICK_REFERENCE.md** - This file

### Setup
4. **SETUP_GUIDE.md** - Initial setup
5. **SUPABASE_SETUP_INSTRUCTIONS.md** - Database setup

### Features
6. **REALTIME_TRACKING_GUIDE.md** - GPS tracking
7. **DRIVER_MODE_TESTING.md** - Driver mode
8. **COMMUNITY_FEATURES_GUIDE.md** - Community features

### Design
9. **HTML_PROTOTYPE_IMPLEMENTATION.md** - Design system
10. **KINETIC_SPLASH_IMPLEMENTATION.md** - Splash screen
11. **DESIGN_SYSTEM.md** - Design guidelines

---

## 🎯 Next Steps

### For Development
1. Set up Supabase account
2. Run database SQL scripts
3. Update credentials in config
4. Run `flutter pub get`
5. Run `flutter run -d chrome`

### For Production
1. Implement authentication
2. Add payment gateway
3. Set up Firebase notifications
4. Beta test with users
5. Submit to Google Play Store

---

## 📞 Quick Links

- **Supabase Dashboard**: https://supabase.com/dashboard
- **Flutter Docs**: https://docs.flutter.dev
- **OpenStreetMap**: https://www.openstreetmap.org
- **Google Fonts**: https://fonts.google.com

---

## ✅ Checklist

### Before Running
- [ ] Flutter SDK installed (3.41.4+)
- [ ] Supabase account created
- [ ] Database tables created
- [ ] Credentials updated in config
- [ ] Dependencies installed (`flutter pub get`)

### Before Building APK
- [ ] Test all screens
- [ ] Verify database connections
- [ ] Check location permissions
- [ ] Test on real device
- [ ] Run `flutter analyze`

### Before Production
- [ ] Authentication implemented
- [ ] Payment gateway integrated
- [ ] Push notifications set up
- [ ] Beta testing completed
- [ ] App store assets ready

---

**Built with Flutter & Supabase**  
**Design: Brutalist/Kinetic Editorial**  
**Made in India 🇮🇳 | For India 🚌**

*Aagman - Your Journey, Simplified*
