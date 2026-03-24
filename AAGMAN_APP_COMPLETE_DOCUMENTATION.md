# AAGMAN - Complete App Documentation

**Your Journey, Simplified**

---

## 📱 App Overview

**App Name:** Aagman  
**Package Name:** com.aagman.app  
**Type:** Bus Tracking & Public Transit App  
**Design Style:** Brutalist Design System  
**Platform:** Flutter (Android & iOS)  
**Database:** Supabase (PostgreSQL)  

---

## 🎨 Design System

### Color Palette
- **Primary:** #6366F1 (Indigo)
- **Secondary:** #8B5CF6 (Purple)
- **Accent:** #FDE047 (Yellow)
- **Success:** #10B981 (Green)
- **Error:** #EF4444 (Red)
- **Background:** #F8FAFC (Light Gray)
- **Surface:** #FFFFFF (White)
- **Text Primary:** #0F172A (Dark Blue)
- **Text Muted:** #64748B (Gray)
- **Border:** #CBD5E1 (Light Gray)

### Typography
- **Primary Font:** Space Grotesk (Bold, Heavy weights)
- **Secondary Font:** Public Sans (Body text)
- **Style:** ALL CAPS for headings, high contrast, thick borders

### Design Principles
- Thick 3px borders everywhere
- Hard shadows (4px offset, no blur)
- Zero border radius (sharp corners)
- High contrast colors
- Bold, geometric layouts
- Brutalist aesthetic

---

## 📊 Database Schema

### Supabase Project Details
- **Project ID:** pxtydnqkpjjlzzqnqjff
- **URL:** https://pxtydnqkpjjlzzqnqjff.supabase.co
- **Anon Key:** (stored in lib/config/supabase_config.dart)

### Database Tables (11 Total)

#### 1. users
- id (UUID, Primary Key)
- email (TEXT, Unique)
- name (TEXT)
- phone (TEXT)
- role (TEXT: 'passenger' or 'driver')
- created_at (TIMESTAMP)

#### 2. buses
- id (UUID, Primary Key)
- bus_number (TEXT, Unique)
- route_id (UUID, Foreign Key → routes)
- capacity (INTEGER)
- current_occupancy (INTEGER)
- status (TEXT: 'active', 'inactive', 'maintenance')
- last_updated (TIMESTAMP)

#### 3. routes
- id (UUID, Primary Key)
- route_number (TEXT, Unique)
- route_name (TEXT)
- start_point (TEXT)
- end_point (TEXT)
- total_stops (INTEGER)
- estimated_duration (INTEGER, minutes)

#### 4. stops
- id (UUID, Primary Key)
- stop_name (TEXT)
- latitude (DECIMAL)
- longitude (DECIMAL)
- stop_order (INTEGER)
- route_id (UUID, Foreign Key → routes)

#### 5. bus_locations
- id (UUID, Primary Key)
- bus_id (UUID, Foreign Key → buses)
- latitude (DECIMAL)
- longitude (DECIMAL)
- speed (DECIMAL)
- heading (DECIMAL)
- timestamp (TIMESTAMP)

#### 6. driver_assignments
- id (UUID, Primary Key)
- driver_id (UUID, Foreign Key → users)
- bus_id (UUID, Foreign Key → buses)
- shift_start (TIMESTAMP)
- shift_end (TIMESTAMP)
- status (TEXT: 'active', 'completed')

#### 7. notifications
- id (UUID, Primary Key)
- user_id (UUID, Foreign Key → users)
- title (TEXT)
- message (TEXT)
- type (TEXT: 'delay', 'arrival', 'general')
- is_read (BOOLEAN)
- created_at (TIMESTAMP)

#### 8. favorites
- id (UUID, Primary Key)
- user_id (UUID, Foreign Key → users)
- route_id (UUID, Foreign Key → routes)
- created_at (TIMESTAMP)

#### 9. bus_ratings
- id (UUID, Primary Key)
- user_id (UUID, Foreign Key → users)
- bus_id (UUID, Foreign Key → buses)
- rating (INTEGER, 1-5)
- comment (TEXT)
- created_at (TIMESTAMP)

#### 10. driver_ratings
- id (UUID, Primary Key)
- user_id (UUID, Foreign Key → users)
- driver_id (UUID, Foreign Key → users)
- rating (INTEGER, 1-5)
- comment (TEXT)
- created_at (TIMESTAMP)

#### 11. delay_reports
- id (UUID, Primary Key)
- user_id (UUID, Foreign Key → users)
- bus_id (UUID, Foreign Key → buses)
- delay_minutes (INTEGER)
- reason (TEXT)
- created_at (TIMESTAMP)

---

## 🔐 Authentication System

### Authentication Methods

#### 1. Email/Password Authentication
- **Sign Up:** Email, password, name
- **Login:** Email and password
- **Password Reset:** Email-based reset flow
- **Session Persistence:** Automatic (stays logged in)

#### 2. Google Sign-In (Passengers Only)
- One-tap Google authentication
- Automatic account creation
- Profile data sync
- Only available for passenger accounts

### User Roles
- **Passenger:** Regular users tracking buses
- **Driver:** Bus drivers with tracking capabilities

### Security Features
- Secure password hashing (Supabase Auth)
- JWT token-based sessions
- Automatic session refresh
- Role-based access control
- Secure API key storage

---

## 📱 App Screens (22 Total)

### Authentication Screens (4)
1. **Login Screen**
   - Passenger/Driver toggle
   - Email/password login
   - Google Sign-In (passengers only)
   - Forgot password link
   - Sign up navigation

2. **Signup Screen**
   - Passenger registration
   - Email, name, password fields
   - Terms acceptance
   - Brutalist form design

3. **Driver Signup Screen**
   - Driver-specific registration
   - License number field
   - Bus selection dropdown
   - Email, name, password fields

4. **Forgot Password Screen**
   - Email input for reset
   - Reset link sent confirmation
   - Back to login navigation

### Main Navigation Screens (4)
5. **Home Screen**
   - Quick access buttons
   - Nearby buses display
   - Route search
   - Real-time updates

6. **Search Screen**
   - Route search functionality
   - Bus number search
   - Stop search
   - Search results display

7. **Track Screen**
   - Live bus tracking
   - Map integration
   - Bus location markers
   - ETA display

8. **Profile Screen**
   - User information display
   - Travel statistics
   - Saved routes
   - Travel history
   - Account settings
   - Edit profile button
   - Sign out functionality

### Feature Screens (14)
9. **Route Details Screen**
   - Route information
   - Stop list
   - Bus schedule
   - Estimated times

10. **Live Tracking Screen**
    - Real-time bus location
    - OpenStreetMap integration
    - Route visualization
    - ETA calculations

11. **Bus Search Results Screen**
    - Search results display
    - Bus cards with details
    - Capacity indicators
    - Quick actions

12. **Notifications Screen**
    - Push notifications list
    - Delay alerts
    - Arrival notifications
    - Mark as read functionality

13. **Passenger Journey Screen**
    - Journey planning
    - Route suggestions
    - Multi-stop planning
    - Save journey option

14. **Travel Analytics Screen**
    - Trip statistics
    - CO2 savings
    - Travel patterns
    - Monthly reports

15. **Rate Bus Screen**
    - Bus rating (1-5 stars)
    - Comment section
    - Submit feedback
    - Previous ratings

16. **Rate Driver Screen**
    - Driver rating (1-5 stars)
    - Comment section
    - Submit feedback
    - Anonymous option

17. **Report Delay Screen**
    - Delay reporting
    - Delay duration input
    - Reason selection
    - Submit report

18. **Edit Profile Screen**
    - Name editing
    - Email display (read-only)
    - Profile picture upload
    - Save changes

### Driver Screens (3)
19. **Driver Login Screen**
    - Driver-specific login
    - License verification
    - Bus assignment check

20. **Driver Tracking Screen**
    - Start/stop tracking
    - Real-time location updates
    - Current route display
    - Passenger count
    - "AAGMAN DRIVER" branding

21. **Driver Dashboard**
    - Shift information
    - Route details
    - Passenger statistics
    - Performance metrics

### Utility Screens (1)
22. **Video Splash Screen**
    - App intro animation
    - Kinetic typography
    - Skip option
    - Auto-navigation

---

## 🔧 Technical Implementation

### Core Technologies
- **Framework:** Flutter 3.41.4
- **Language:** Dart
- **State Management:** StatefulWidget/StatelessWidget
- **Database:** Supabase (PostgreSQL)
- **Authentication:** Supabase Auth
- **Maps:** OpenStreetMap (flutter_map)
- **Location:** Geolocator package
- **Fonts:** Google Fonts

### Key Packages
```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.0.0
  google_fonts: ^6.3.3
  geolocator: ^11.1.0
  geocoding: ^3.0.0
  flutter_map: ^6.2.1
  latlong2: ^0.9.0
  google_sign_in: ^6.1.5
  connectivity_plus: ^5.0.2
  flutter_local_notifications: ^17.2.4
  shared_preferences: ^2.2.2
  url_launcher: ^6.2.2
  video_player: ^2.8.1
  intl: ^0.19.0
```

### Project Structure
```
lib/
├── main.dart
├── config/
│   ├── theme.dart
│   └── supabase_config.dart
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── driver_signup_screen.dart
│   ├── forgot_password_screen.dart
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── track_screen.dart
│   ├── profile_screen.dart
│   ├── edit_profile_screen.dart
│   ├── route_details_screen.dart
│   ├── live_tracking_screen.dart
│   ├── bus_search_results_screen.dart
│   ├── notifications_screen.dart
│   ├── passenger_journey_screen.dart
│   ├── travel_analytics_screen.dart
│   ├── rate_bus_screen.dart
│   ├── rate_driver_screen.dart
│   ├── report_delay_screen.dart
│   ├── driver_login_screen.dart
│   ├── driver_tracking_screen.dart
│   ├── video_splash_screen.dart
│   └── main_navigation.dart
├── services/
│   └── auth_service.dart
└── widgets/
    ├── bus_card.dart
    ├── capacity_bar.dart
    ├── quick_access_button.dart
    ├── location_dropdown.dart
    └── auth_check.dart
```

---

## 🚀 Setup Instructions

### Prerequisites
1. Flutter SDK (3.41.4 or higher)
2. Android Studio / VS Code
3. Supabase account
4. Google Cloud Console account (for Google Sign-In)

### Installation Steps

#### 1. Clone and Setup
```bash
# Navigate to project directory
cd Aagman

# Install dependencies
flutter pub get

# Clean build
flutter clean
```

#### 2. Supabase Configuration
1. Create Supabase project at https://supabase.com
2. Copy project URL and anon key
3. Update `lib/config/supabase_config.dart`:
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```
4. Run SQL setup script from `supabase_setup.sql`
5. Enable Email Auth in Supabase Dashboard
6. Configure email templates

#### 3. Google Sign-In Setup

**Google Cloud Console:**
1. Create project at https://console.cloud.google.com
2. Enable Google+ API
3. Create OAuth 2.0 credentials:
   - Application Type: Android
   - Package Name: `com.aagman.app`
   - SHA-1: `2F:B6:19:54:A2:DF:69:A1:E3:AC:15:83:F3:D4:0D:FB:B5:37:8F:7B`

**Supabase Configuration:**
1. Go to Authentication → Providers
2. Enable Google provider
3. Add Client ID and Client Secret from Google Cloud
4. Add redirect URI to Google Cloud Console:
   ```
   https://pxtydnqkpjjlzzqnqjff.supabase.co/auth/v1/callback
   ```

#### 4. Android Configuration
The app is already configured with:
- Package name: `com.aagman.app`
- App name: "Aagman"
- Minimum SDK: 21
- Target SDK: Latest

#### 5. Build and Run
```bash
# Debug build
flutter run

# Release build
flutter build apk --release

# Install on device
flutter install
```

---

## 📱 App Features

### For Passengers

#### Real-Time Tracking
- Live bus location on map
- ETA calculations
- Route visualization
- Stop-by-stop tracking

#### Search & Discovery
- Search by route number
- Search by bus number
- Search by stop name
- Nearby buses display

#### Journey Planning
- Multi-stop journey planning
- Route suggestions
- Estimated travel time
- Save favorite routes

#### Notifications
- Bus arrival alerts
- Delay notifications
- Route change updates
- Custom notification preferences

#### Community Features
- Rate buses (1-5 stars)
- Rate drivers (1-5 stars)
- Report delays
- View community ratings

#### Analytics
- Trip history
- CO2 savings calculation
- Travel patterns
- Monthly statistics

#### Profile Management
- Edit profile information
- View travel history
- Manage saved routes
- Account settings

### For Drivers

#### Location Tracking
- Start/stop tracking
- Automatic location updates
- Real-time position sharing
- Route adherence monitoring

#### Dashboard
- Current route information
- Passenger count
- Shift details
- Performance metrics

#### Bus Management
- Bus assignment
- Capacity updates
- Status reporting
- Maintenance alerts

---

## 🔑 Important Credentials

### Package Information
- **Package Name:** com.aagman.app
- **App Name:** Aagman
- **SHA-1 (Debug):** 2F:B6:19:54:A2:DF:69:A1:E3:AC:15:83:F3:D4:0D:FB:B5:37:8F:7B
- **Keystore:** C:\Users\Hp\.android\debug.keystore
- **Alias:** AndroidDebugKey

### Supabase
- **Project ID:** pxtydnqkpjjlzzqnqjff
- **URL:** https://pxtydnqkpjjlzzqnqjff.supabase.co
- **Redirect URI:** https://pxtydnqkpjjlzzqnqjff.supabase.co/auth/v1/callback

---

## 🧪 Testing Checklist

### Authentication Testing
- [ ] Email/password signup (passenger)
- [ ] Email/password signup (driver)
- [ ] Email/password login (passenger)
- [ ] Email/password login (driver)
- [ ] Google Sign-In (passenger only)
- [ ] Forgot password flow
- [ ] Session persistence (close/reopen app)
- [ ] Sign out functionality
- [ ] Edit profile

### Navigation Testing
- [ ] Bottom navigation works
- [ ] All screens accessible
- [ ] Back button navigation
- [ ] Deep linking (if implemented)

### Feature Testing
- [ ] Search functionality
- [ ] Live tracking
- [ ] Notifications
- [ ] Rate bus/driver
- [ ] Report delay
- [ ] View analytics
- [ ] Save favorite routes

### Driver Testing
- [ ] Driver login
- [ ] Start tracking
- [ ] Stop tracking
- [ ] Location updates
- [ ] Dashboard display

### UI/UX Testing
- [ ] Brutalist design consistent
- [ ] All buttons functional
- [ ] Forms validate properly
- [ ] Loading states display
- [ ] Error messages show
- [ ] Success messages show

---

## 🐛 Known Issues & Solutions

### Issue: Google Sign-In Not Working
**Solution:** Verify Google Cloud Console OAuth credentials match:
- Package name: `com.aagman.app`
- SHA-1 fingerprint is correct
- Redirect URI added to Google Cloud Console

### Issue: Location Not Updating
**Solution:** 
- Check location permissions granted
- Verify GPS is enabled
- Check internet connectivity
- Ensure Supabase connection active

### Issue: Session Not Persisting
**Solution:**
- Verify Supabase configuration
- Check auth token storage
- Ensure AuthCheck widget implemented

---

## 📈 Future Enhancements

### Planned Features
1. **Payment Integration**
   - Digital ticketing
   - Wallet integration
   - Payment history

2. **Offline Mode**
   - Cached routes
   - Offline maps
   - Sync when online

3. **Social Features**
   - Share journey
   - Friend tracking
   - Group travel

4. **Advanced Analytics**
   - Predictive ETAs
   - Traffic integration
   - Route optimization

5. **Accessibility**
   - Screen reader support
   - High contrast mode
   - Voice commands

6. **Multi-Language**
   - Hindi support
   - Regional languages
   - RTL support

---

## 📞 Support & Maintenance

### Regular Maintenance Tasks
1. Update Flutter SDK regularly
2. Update dependencies monthly
3. Monitor Supabase usage
4. Review user feedback
5. Update Google Play listing
6. Backup database regularly

### Performance Monitoring
- Track app crashes
- Monitor API response times
- Check database query performance
- Review user retention metrics

---

## 📄 License & Credits

### App Information
- **Developer:** Your Name/Team
- **Version:** 1.0.0
- **Last Updated:** March 24, 2026
- **Platform:** Android (iOS coming soon)

### Technologies Used
- Flutter by Google
- Supabase for backend
- OpenStreetMap for maps
- Google Fonts for typography
- Material Design icons

---

## 🎯 Quick Start Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk

# Analyze code
flutter analyze

# Run tests
flutter test

# Clean build
flutter clean

# Get SHA-1
cd android && ./gradlew signingReport
```

---

## 📝 Notes

### Design Philosophy
Aagman uses a brutalist design approach to stand out in the crowded transit app market. The bold, geometric aesthetic creates a memorable user experience while maintaining excellent usability.

### Performance Considerations
- Optimized for low-end devices
- Efficient location tracking
- Minimal battery drain
- Fast app startup
- Smooth animations

### Security Best Practices
- No sensitive data in code
- Secure API key storage
- HTTPS only connections
- JWT token authentication
- Role-based access control

---

**AAGMAN - Your Journey, Simplified**

*This documentation covers the complete Aagman bus tracking application. For specific implementation details, refer to individual documentation files in the project.*

---

**Document Version:** 1.0  
**Last Updated:** March 24, 2026  
**Total Pages:** This document  
**Status:** Production Ready ✅
