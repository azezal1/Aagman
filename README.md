# Bus Tracker - Real-Time Public Transport App

A clean, minimal, and user-friendly mobile application for tracking buses in real-time, designed for small cities and rural areas in India.

## Design Philosophy

- **Minimal & Subtle**: Clean interface with muted colors and soft tones
- **Accessible**: Large readable text, simple navigation for all users
- **Trustworthy**: Civic-tech aesthetic, grounded and practical
- **Low-bandwidth friendly**: Optimized for rural connectivity

## Features

- 🔍 Search buses by route and location
- 📍 Real-time bus tracking on map
- 🚏 View detailed route and stop timings
- 🔔 Arrival and delay notifications
- 📊 Journey progress tracking
- 💬 Feedback and help system
- 🏛️ Government and private bus filtering

## Color Palette

- Background: `#F8F9FA` (Off-white)
- Surface: `#FFFFFF` (White)
- Text Primary: `#2C3E50` (Slate grey)
- Text Secondary: `#6C757D` (Muted grey)
- Accent: `#5A8F7B` (Muted green)
- Status Blue: `#7B9AAD` (Dusty blue)
- Status Amber: `#D4A574` (Soft amber)

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure Supabase

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Get your project URL and anon key from Settings > API
3. Update credentials in `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### 3. Set Up Database

Run the SQL schema provided in `lib/config/supabase_config.dart` in your Supabase SQL editor to create the required tables.

### 4. Configure Google Maps (Optional)

For live tracking functionality:

1. Get a Google Maps API key
2. Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY"/>
```

3. Add to `ios/Runner/AppDelegate.swift`:

```swift
GMSServices.provideAPIKey("YOUR_API_KEY")
```

### 5. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── config/
│   ├── theme.dart              # App theme and colors
│   └── supabase_config.dart    # Supabase configuration
├── models/
│   └── bus.dart                # Bus data model
├── screens/
│   ├── splash_screen.dart      # Welcome screen
│   ├── home_screen.dart        # Main search screen
│   ├── bus_search_results_screen.dart
│   ├── live_tracking_screen.dart
│   ├── route_details_screen.dart
│   ├── passenger_journey_screen.dart
│   ├── feedback_screen.dart
│   └── notifications_screen.dart
├── widgets/
│   └── location_dropdown.dart  # Reusable dropdown
└── main.dart                   # App entry point
```

## Screens

1. **Splash Screen** - Simple welcome with app logo
2. **Home Screen** - Search form and nearby buses
3. **Bus Search Results** - Filtered list with sorting
4. **Live Tracking** - Map view with real-time location
5. **Route Details** - Timeline of all stops
6. **Passenger Journey** - Travel progress tracker
7. **Feedback/Help** - Issue reporting form
8. **Notifications** - Alerts and reminders

## Database Schema

See `lib/config/supabase_config.dart` for complete SQL schema including:
- Buses table
- Locations table
- Routes table
- Stops table
- Feedback table
- Notifications table

## Customization

### Change Colors

Edit `lib/config/theme.dart` to modify the color palette.

### Add Languages

The app is designed to support bilingual layouts. Add localization packages and update text strings as needed.

### Modify Sample Data

Replace sample data in screens with actual Supabase queries using:

```dart
final response = await SupabaseConfig.client
    .from('buses')
    .select()
    .execute();
```

## Target Users

- Daily commuters in tier-2 towns and rural areas
- Users with varying digital literacy levels
- Students, workers, and general public

## Design Principles

- No flashy gradients or neon effects
- No glassmorphism or heavy shadows
- Clean spacing and clear hierarchy
- Rounded corners (12px)
- Subtle elevation (2-4 only)
- Large touch targets (48dp minimum)
- Simple line icons

## License

This project is open source and available for public use.
