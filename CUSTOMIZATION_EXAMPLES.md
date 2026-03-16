# Customization Examples

Common customizations you might want to make to the Bus Tracker app.

## Change App Name

### 1. In Code
`lib/main.dart`:
```dart
MaterialApp(
  title: 'Your App Name', // Change this
  // ...
)
```

### 2. Android
`android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Your App Name" <!-- Change this -->
```

### 3. iOS
`ios/Runner/Info.plist`:
```xml
<key>CFBundleName</key>
<string>Your App Name</string> <!-- Change this -->
```

## Change Color Scheme

### Example: Blue Theme

`lib/config/theme.dart`:
```dart
class AppTheme {
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E3A5F);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color accent = Color(0xFF4A90E2); // Blue accent
  static const Color border = Color(0xFFE2E8F0);
  static const Color statusBlue = Color(0xFF60A5FA);
  static const Color statusAmber = Color(0xFFFBBF24);
  static const Color lightGrey = Color(0xFFF8FAFC);
}
```

### Example: Warm Theme

```dart
class AppTheme {
  static const Color background = Color(0xFFFAF8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF3E2723);
  static const Color textSecondary = Color(0xFF795548);
  static const Color accent = Color(0xFFD4845C); // Warm orange
  static const Color border = Color(0xFFE7DDD3);
  static const Color statusBlue = Color(0xFF8B9DC3);
  static const Color statusAmber = Color(0xFFDDA15E);
  static const Color lightGrey = Color(0xFFF5F1ED);
}
```

## Add App Logo

### 1. Add Image
Place your logo in `assets/images/logo.png`

### 2. Update Splash Screen
`lib/screens/splash_screen.dart`:
```dart
// Replace the Container with:
Image.asset(
  'assets/images/logo.png',
  width: 120,
  height: 120,
),
```

### 3. Update pubspec.yaml
Make sure assets are declared:
```yaml
flutter:
  assets:
    - assets/images/
```

## Change Font

### 1. Add Font Files
Create `assets/fonts/` and add your font files:
```
assets/fonts/
  - Poppins-Regular.ttf
  - Poppins-Medium.ttf
  - Poppins-SemiBold.ttf
```

### 2. Update pubspec.yaml
```yaml
flutter:
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
          weight: 400
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
```

### 3. Update Theme
`lib/config/theme.dart`:
```dart
static ThemeData lightTheme = ThemeData(
  fontFamily: 'Poppins', // Add this
  // ... rest of theme
)
```

## Add More Locations

### In Supabase SQL Editor:
```sql
INSERT INTO locations (name, latitude, longitude) VALUES
('Airport', 23.0640, 72.6347),
('Shopping Mall', 23.0350, 72.5650),
('University', 23.0400, 72.5900),
('Tech Park', 23.0500, 72.6000);
```

## Customize Bottom Navigation

`lib/screens/home_screen.dart`:
```dart
BottomNavigationBar(
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home', // Change labels
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search_outlined),
      label: 'Find', // Custom label
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.map_outlined), // Different icon
      label: 'Map',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline), // Add profile
      label: 'Profile',
    ),
  ],
)
```

## Add Language Support

### 1. Add Package
`pubspec.yaml`:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
```

### 2. Create Translations
`lib/l10n/app_en.dart`:
```dart
class AppLocalizationsEn {
  static const String appTitle = 'Bus Tracker';
  static const String searchBuses = 'Search Buses';
  static const String from = 'From';
  static const String to = 'To';
}
```

`lib/l10n/app_hi.dart`:
```dart
class AppLocalizationsHi {
  static const String appTitle = 'बस ट्रैकर';
  static const String searchBuses = 'बस खोजें';
  static const String from = 'से';
  static const String to = 'तक';
}
```

### 3. Use in Code
```dart
Text(AppLocalizations.of(context).searchBuses)
```

## Add Bus Capacity

### 1. Update Model
`lib/models/bus.dart`:
```dart
class Bus {
  final String id;
  final String name;
  final String type;
  final String departureTime;
  final String arrivalTime;
  final int fare;
  final int capacity; // Add this
  final int occupancy; // Add this

  Bus({
    required this.id,
    required this.name,
    required this.type,
    required this.departureTime,
    required this.arrivalTime,
    required this.fare,
    this.capacity = 50, // Default
    this.occupancy = 0, // Default
  });
}
```

### 2. Update Database
```sql
ALTER TABLE buses ADD COLUMN capacity INTEGER DEFAULT 50;
ALTER TABLE buses ADD COLUMN occupancy INTEGER DEFAULT 0;
```

### 3. Show in UI
`lib/screens/bus_search_results_screen.dart`:
```dart
// Add to bus card:
Row(
  children: [
    Icon(Icons.people_outline, size: 16),
    SizedBox(width: 4),
    Text('${bus.occupancy}/${bus.capacity}'),
  ],
)
```

## Add Favorites

### 1. Create Favorites Table
```sql
CREATE TABLE favorites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID,
  route_id UUID REFERENCES routes(id),
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 2. Add Favorite Button
```dart
IconButton(
  icon: Icon(
    isFavorite ? Icons.favorite : Icons.favorite_border,
    color: isFavorite ? AppTheme.accent : AppTheme.textSecondary,
  ),
  onPressed: () => toggleFavorite(),
)
```

### 3. Save to Supabase
```dart
Future<void> toggleFavorite(String routeId) async {
  if (isFavorite) {
    await supabase
        .from('favorites')
        .delete()
        .eq('route_id', routeId);
  } else {
    await supabase
        .from('favorites')
        .insert({'route_id': routeId});
  }
}
```

## Add Push Notifications

### 1. Add Package
`pubspec.yaml`:
```yaml
dependencies:
  firebase_messaging: ^14.7.0
```

### 2. Initialize
`lib/main.dart`:
```dart
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Request permission
  await FirebaseMessaging.instance.requestPermission();
  
  // Get token
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token');
  
  runApp(BusTrackerApp());
}
```

### 3. Handle Messages
```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Got a message: ${message.notification?.title}');
  // Show local notification
});
```

## Add Search History

### 1. Save to Local Storage
```dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSearch(String from, String to) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('search_history') ?? [];
  history.insert(0, '$from|$to');
  if (history.length > 10) history = history.sublist(0, 10);
  await prefs.setStringList('search_history', history);
}
```

### 2. Show Recent Searches
```dart
Future<List<Map<String, String>>> getSearchHistory() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('search_history') ?? [];
  return history.map((item) {
    final parts = item.split('|');
    return {'from': parts[0], 'to': parts[1]};
  }).toList();
}
```

## Add Rating System

### 1. Create Ratings Table
```sql
CREATE TABLE ratings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bus_id UUID REFERENCES buses(id),
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 2. Add Rating Widget
```dart
Row(
  children: List.generate(5, (index) {
    return IconButton(
      icon: Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: AppTheme.statusAmber,
      ),
      onPressed: () => setRating(index + 1),
    );
  }),
)
```

## Change Border Radius

For a more rounded look:

`lib/config/theme.dart`:
```dart
// Change all BorderRadius.circular(12) to:
BorderRadius.circular(16) // More rounded

// Or for very rounded:
BorderRadius.circular(20)
```

## Add Dark Mode

### 1. Create Dark Theme
`lib/config/theme.dart`:
```dart
static ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: Color(0xFF1A1D23),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF6BA58E),
    surface: Color(0xFF252932),
    background: Color(0xFF1A1D23),
  ),
  // ... rest of dark theme
);
```

### 2. Use in App
`lib/main.dart`:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme, // Add this
  themeMode: ThemeMode.system, // Add this
  // ...
)
```

## Add Splash Screen Animation

`lib/screens/splash_screen.dart`:
```dart
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: // ... your splash content
    );
  }
}
```

---

These are just examples! The app is designed to be easily customizable. Explore the code and make it your own.
