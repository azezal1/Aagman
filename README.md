# Aagman - Real-Time Bus Tracking App

> **Modern, Bold, Kinetic** - A civic-tech bus tracking solution for India

![Version](https://img.shields.io/badge/version-2.4.0_KIN-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.41.4-02569B?logo=flutter)
![License](https://img.shields.io/badge/license-MIT-green)

## 🎨 Design Philosophy

**Brutalist/Kinetic Editorial** - Bold typography, sharp corners, hard shadows
**Map-First** - Full-screen maps with sliding panels
**Motion-First** - Active-press animations and kinetic energy
**Accessibility** - High contrast, large text, simple navigation

## ✨ Features

### Core Features
- �️ **Real-Time Bus Tracking** - Live GPS tracking with OpenStreetMap
- � **Map-First Interface** - Full-screen map with draggable info panels
- 📍 **Location-Based Search** - Find nearby buses automatically
- 🎯 **Route Timeline** - Bold vertical timeline with current position
- 📊 **Journey Progress** - Clear progress display with time remaining
- ⚡ **Kinetic Splash Screen** - Animated blueprint grid with massive logo

### Community Features
- ⭐ **Rate Buses & Drivers** - Community feedback system
- ⚠️ **Report Delays** - Real-time delay reporting
- 📈 **Travel Analytics** - Monthly travel statistics
- 🔔 **Push Notifications** - Bus arrival and delay alerts

### Driver Features
- 🚗 **Driver Mode** - GPS tracking for bus operators
- 📡 **Real-Time Updates** - Location broadcast every 30 seconds
- 🎛️ **Simple Interface** - Easy-to-use driver dashboard

## 🎯 Design System

### Colors (HTML Prototype Palette)
```
Primary:      #2563EB  (Blue - interactive elements)
Accent:       #6CF8BB  (Green - highlights)
Background:   #F9F9F9  (Light grey)
Surface:      #FFFFFF  (White cards)
Text Primary: #1A1C1C  (Near black)
Text Muted:   #434655  (Grey)
Border:       #E2E2E2  (Light grey)
```

### Typography
- **Headlines/Labels**: Space Grotesk (700-800 weight, tight tracking)
- **Body Text**: Public Sans (400-600 weight)
- **Labels**: All caps, 700 weight, 1.5-2px letter spacing

### Layout
- **Sharp corners**: BorderRadius.zero (0px)
- **Bold borders**: 3px solid borders
- **Hard shadows**: 4px offset, no blur
- **Active-press**: Translate 2px on tap, remove shadow
- **Grid spacing**: 8px base unit (8, 16, 24, 32)

## 🚀 Quick Start

### Prerequisites
- Flutter 3.41.4 or higher
- Dart SDK
- Android Studio / VS Code
- Supabase account

### Installation

```bash
# Clone the repository
git clone https://github.com/azezal1/Aagman.git
cd Aagman

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

## 📱 Screens (22 Total)

### 1. Kinetic Splash Screen
- Blueprint grid background (radial dots, 40px spacing)
- Kinetic diagonal lines pattern
- Massive "AAGMAN" logo (18vw, italic, bold)
- Accent dot with 4px hard shadow
- System status + version badges
- "INITIALIZE" button with offset shadow
- 2-second fade/slide animations

### 2. Home Screen
- Top app bar with AAGMAN branding
- Large search bar (3px border, 4px shadow)
- 3-column quick access grid
- Horizontal scrolling bus cards (280px wide)
- Analytics card with mini bar chart
- Map section with status badge
- Sharp corners and bold borders

### 3. Profile Screen
- Hero section with citizen ID (CITIZEN_092)
- 4-column stats grid (trips, CO2, rank, points)
- Achievements with icon badges
- Travel history with pricing
- Saved routes (HOME, WORK, GYM)
- Account settings

### 4. Route Details (Timeline)
- Route header with "LINE 502" badge
- Vertical timeline with 4px center line
- Current stop: BLACK background, NOW badge
- Past stops: 40% opacity
- Upcoming stops: white background
- Live geoposition section

### 5. Search & Track
- Real-time bus search with Supabase
- Active bus tracking with LIVE badges
- Bus cards with 3px borders
- Status indicators

### 6. Additional Screens
- Live Tracking (map-first)
- Passenger Journey (progress)
- Bus Search Results
- Notifications
- Travel Analytics
- Rate Bus/Driver
- Report Delay
- Driver Login/Tracking
- Feedback

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform framework
- **Material Design 3** - UI components
- **flutter_map** - OpenStreetMap integration
- **google_fonts** - Space Grotesk + Public Sans
- **Custom Painters** - Blueprint grid, kinetic lines

### Backend
- **Supabase** - Backend as a Service
- **PostgreSQL** - Database
- **Real-time subscriptions** - Live updates
- **Row Level Security** - Data protection

### Services
- **Geolocator** - GPS location
- **Geocoding** - Address lookup
- **Local Notifications** - Push alerts
- **Shared Preferences** - Local storage

## 📊 Database Schema

### Tables
- `buses` - Bus information
- `locations` - Location data
- `routes` - Route definitions
- `stops` - Bus stops
- `bus_locations` - Real-time GPS data
- `feedback` - User feedback
- `notifications` - Push notifications
- `delay_reports` - Community reports
- `bus_ratings` - Bus ratings
- `driver_ratings` - Driver ratings
- `travel_history` - User journey data

## 🎨 UI/UX Highlights

### Brutalist/Kinetic Design
- Bold, chunky typography (700-800 weight)
- Sharp geometric shapes (BorderRadius.zero)
- 3px borders, 4px hard shadows
- Active-press animations (translate 2px)
- High contrast (#2563EB primary, #6CF8BB accent)
- Kinetic energy throughout

### Accessibility
- ✅ High contrast ratios (7:1 - 21:1)
- ✅ Large touch targets (48px+)
- ✅ Clear focus states
- ✅ Bold, readable text (16-40px)
- ✅ Simple navigation

### Performance
- ✅ Low bandwidth friendly
- ✅ Fast rendering (no gradients)
- ✅ Efficient animations
- ✅ Optimized for rural areas

## 📁 Project Structure

```
lib/
├── config/
│   ├── theme.dart              # Brutalist design system
│   └── supabase_config.dart    # Backend configuration
├── models/
│   └── bus.dart                # Data models
├── screens/
│   ├── live_tracking_screen.dart      # Map-first tracking
│   ├── route_details_screen.dart      # Timeline view
│   ├── passenger_journey_screen.dart  # Progress display
│   ├── home_screen.dart               # Main screen
│   ├── search_screen.dart             # Bus search
│   ├── track_screen.dart              # Active buses
│   ├── profile_screen.dart            # User profile
│   ├── driver_login_screen.dart       # Driver auth
│   ├── driver_tracking_screen.dart    # Driver mode
│   └── ...
├── widgets/
│   ├── app_logo.dart           # SVG logo widget
│   └── location_dropdown.dart  # Location picker
├── services/
│   └── notification_service.dart  # Push notifications
├── providers/
│   ├── theme_provider.dart     # Theme state
│   └── favorites_provider.dart # Favorites state
└── main.dart                   # App entry point
```

## 🔧 Configuration

### Supabase Setup

1. Create a Supabase project
2. Run the SQL schema: `supabase_setup.sql`
3. Enable real-time for `bus_locations` table
4. Update `lib/config/supabase_config.dart` with your credentials

### Logo Setup

1. Add your logo: `assets/logo/logo.svg`
2. Convert to PNG: `assets/images/logo.png` (1024x1024)
3. Generate icons: `flutter pub run flutter_launcher_icons`

## 📖 Documentation

### Essential
- [Final Project Status](FINAL_PROJECT_STATUS.md) - Complete overview
- [Project Complete](PROJECT_COMPLETE.md) - Completion summary
- [Connectivity Verification](CONNECTIVITY_VERIFICATION.md) - All connections verified
- [Architecture](ARCHITECTURE.md) - System architecture

### Setup Guides
- [Setup Guide](SETUP_GUIDE.md) - Initial setup
- [Supabase Setup](SUPABASE_SETUP_INSTRUCTIONS.md) - Database setup
- [Supabase Integration](SUPABASE_INTEGRATION.md) - Integration guide

### Feature Guides
- [Real-time Tracking](REALTIME_TRACKING_GUIDE.md) - GPS tracking setup
- [OpenStreetMap Setup](OPENSTREETMAP_SETUP.md) - Map configuration
- [Community Features](COMMUNITY_FEATURES_GUIDE.md) - Rating system
- [Driver Mode Testing](DRIVER_MODE_TESTING.md) - Driver mode
- [Location Feature Guide](LOCATION_FEATURE_GUIDE.md) - Location services

### Design Documentation
- [HTML Prototype Implementation](HTML_PROTOTYPE_IMPLEMENTATION.md) - Design system
- [Kinetic Splash Implementation](KINETIC_SPLASH_IMPLEMENTATION.md) - Splash screen
- [Profile Screen Implementation](PROFILE_SCREEN_IMPLEMENTATION.md) - Profile screen
- [Design System](DESIGN_SYSTEM.md) - Design guidelines
- [Color Palette](COLOR_PALETTE.md) - Color system

## 🎯 Target Users

### Passengers
- Urban and rural commuters
- Students and daily travelers
- First-time bus users
- Elderly passengers

### Bus Operators
- Government bus services
- Private bus operators
- Small city transport
- Rural bus services

### Administrators
- Transport departments
- City planners
- Service managers

## 🌟 Key Benefits

### For Passengers
- ✅ Know exact bus arrival time
- ✅ Track bus in real-time
- ✅ Plan journey efficiently
- ✅ Reduce waiting time
- ✅ Community feedback

### For Operators
- ✅ Real-time fleet tracking
- ✅ Passenger feedback
- ✅ Service improvement data
- ✅ Delay reporting
- ✅ Analytics dashboard

### For Cities
- ✅ Improved public transport
- ✅ Reduced congestion
- ✅ Better accessibility
- ✅ Data-driven decisions
- ✅ Civic engagement

## 🚧 Roadmap

### Phase 1 (Complete) ✅
- ✅ Real-time tracking with Supabase
- ✅ Map-first interface with OpenStreetMap
- ✅ Community features (ratings, delay reports)
- ✅ Driver mode with GPS tracking
- ✅ Brutalist/kinetic redesign (22 screens)
- ✅ Kinetic splash screen with animations
- ✅ Profile with achievements and analytics
- ✅ All setState() errors fixed
- ✅ Project cleanup completed

### Phase 2 (Planned)
- User authentication system
- Payment gateway integration
- Ticket booking
- Push notifications (Firebase)
- Multi-language support
- Offline mode

### Phase 3 (Future)
- AI-based ETA prediction
- Crowding information
- Advanced accessibility features
- Integration with other transport modes
- Rewards and gamification
- Social features

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

Built with ❤️ for Indian commuters

## 📞 Support

For support, email support@aagman.app or open an issue on GitHub.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for backend infrastructure
- OpenStreetMap for free mapping
- Indian bus operators for inspiration

---

**Made in India 🇮🇳 | For India 🚌**

*Aagman - Your Journey, Simplified*
