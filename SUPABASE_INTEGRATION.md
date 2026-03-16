# Supabase Integration Guide

This guide shows how to integrate Supabase with the Bus Tracker app for real data.

## Setup

### 1. Initialize Supabase

Already done in `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### 2. Access Supabase Client

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
```

## Database Operations

### Fetch Buses

Replace sample data in `bus_search_results_screen.dart`:

```dart
Future<List<Bus>> fetchBuses(String from, String to) async {
  try {
    final response = await supabase
        .from('routes')
        .select('''
          *,
          buses(*),
          from_location:locations!from_location_id(*),
          to_location:locations!to_location_id(*)
        ''')
        .eq('from_location.name', from)
        .eq('to_location.name', to);

    return (response as List)
        .map((json) => Bus.fromJson(json['buses']))
        .toList();
  } catch (e) {
    print('Error fetching buses: $e');
    return [];
  }
}
```

### Fetch Locations

For the location dropdown:

```dart
Future<List<String>> fetchLocations() async {
  try {
    final response = await supabase
        .from('locations')
        .select('name')
        .order('name');

    return (response as List)
        .map((item) => item['name'] as String)
        .toList();
  } catch (e) {
    print('Error fetching locations: $e');
    return [];
  }
}
```

### Fetch Route Stops

For route details screen:

```dart
Future<List<Map<String, dynamic>>> fetchRouteStops(String routeId) async {
  try {
    final response = await supabase
        .from('stops')
        .select('''
          *,
          location:locations(*)
        ''')
        .eq('route_id', routeId)
        .order('stop_order');

    return (response as List).cast<Map<String, dynamic>>();
  } catch (e) {
    print('Error fetching stops: $e');
    return [];
  }
}
```

### Submit Feedback

For feedback screen:

```dart
Future<bool> submitFeedback(String issueType, String message) async {
  try {
    await supabase.from('feedback').insert({
      'issue_type': issueType,
      'message': message,
      'created_at': DateTime.now().toIso8601String(),
    });
    return true;
  } catch (e) {
    print('Error submitting feedback: $e');
    return false;
  }
}
```

### Fetch Notifications

For notifications screen:

```dart
Future<List<Map<String, dynamic>>> fetchNotifications() async {
  try {
    final response = await supabase
        .from('notifications')
        .select()
        .order('created_at', ascending: false)
        .limit(20);

    return (response as List).cast<Map<String, dynamic>>();
  } catch (e) {
    print('Error fetching notifications: $e');
    return [];
  }
}
```

## Real-Time Tracking

### Subscribe to Bus Location Updates

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveTrackingScreen extends StatefulWidget {
  // ... existing code
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  RealtimeChannel? _channel;
  
  @override
  void initState() {
    super.initState();
    _subscribeToLocationUpdates();
  }
  
  void _subscribeToLocationUpdates() {
    _channel = supabase
        .channel('bus_locations')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bus_locations',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'bus_id',
            value: widget.bus.id,
          ),
          callback: (payload) {
            setState(() {
              // Update bus location on map
              final newLocation = payload.newRecord;
              _updateBusMarker(
                newLocation['latitude'],
                newLocation['longitude'],
              );
            });
          },
        )
        .subscribe();
  }
  
  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }
  
  void _updateBusMarker(double lat, double lng) {
    // Update Google Maps marker
  }
}
```

### Create Bus Locations Table

Add this to your Supabase SQL:

```sql
CREATE TABLE bus_locations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bus_id UUID REFERENCES buses(id),
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  speed DECIMAL(5, 2),
  heading INTEGER,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Enable real-time
ALTER PUBLICATION supabase_realtime ADD TABLE bus_locations;
```

## Authentication (Optional)

### Sign Up User

```dart
Future<bool> signUp(String email, String password) async {
  try {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    return response.user != null;
  } catch (e) {
    print('Error signing up: $e');
    return false;
  }
}
```

### Sign In User

```dart
Future<bool> signIn(String email, String password) async {
  try {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user != null;
  } catch (e) {
    print('Error signing in: $e');
    return false;
  }
}
```

### Get Current User

```dart
User? getCurrentUser() {
  return supabase.auth.currentUser;
}
```

### Sign Out

```dart
Future<void> signOut() async {
  await supabase.auth.signOut();
}
```

## Row Level Security (RLS)

Protect your data with RLS policies:

```sql
-- Enable RLS on all tables
ALTER TABLE buses ENABLE ROW LEVEL SECURITY;
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE stops ENABLE ROW LEVEL SECURITY;

-- Allow public read access
CREATE POLICY "Public read access" ON buses
  FOR SELECT USING (true);

CREATE POLICY "Public read access" ON routes
  FOR SELECT USING (true);

CREATE POLICY "Public read access" ON locations
  FOR SELECT USING (true);

CREATE POLICY "Public read access" ON stops
  FOR SELECT USING (true);

-- Feedback: Anyone can insert
CREATE POLICY "Anyone can submit feedback" ON feedback
  FOR INSERT WITH CHECK (true);

-- Notifications: Users can only see their own
CREATE POLICY "Users see own notifications" ON notifications
  FOR SELECT USING (auth.uid() = user_id);
```

## Error Handling

### Wrap API Calls

```dart
Future<T?> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    return await apiCall();
  } on PostgrestException catch (e) {
    print('Database error: ${e.message}');
    return null;
  } on AuthException catch (e) {
    print('Auth error: ${e.message}');
    return null;
  } catch (e) {
    print('Unexpected error: $e');
    return null;
  }
}

// Usage
final buses = await safeApiCall(() => fetchBuses(from, to));
if (buses != null) {
  // Use buses
}
```

## Caching

### Cache Locations

```dart
class LocationCache {
  static List<String>? _cachedLocations;
  static DateTime? _cacheTime;
  
  static Future<List<String>> getLocations() async {
    // Cache for 1 hour
    if (_cachedLocations != null && 
        _cacheTime != null &&
        DateTime.now().difference(_cacheTime!) < Duration(hours: 1)) {
      return _cachedLocations!;
    }
    
    _cachedLocations = await fetchLocations();
    _cacheTime = DateTime.now();
    return _cachedLocations!;
  }
}
```

## Offline Support

### Store Data Locally

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class OfflineStorage {
  static Future<void> saveBuses(List<Bus> buses) async {
    final prefs = await SharedPreferences.getInstance();
    final busesJson = buses.map((b) => b.toJson()).toList();
    await prefs.setString('cached_buses', jsonEncode(busesJson));
  }
  
  static Future<List<Bus>?> getCachedBuses() async {
    final prefs = await SharedPreferences.getInstance();
    final busesString = prefs.getString('cached_buses');
    if (busesString == null) return null;
    
    final busesJson = jsonDecode(busesString) as List;
    return busesJson.map((json) => Bus.fromJson(json)).toList();
  }
}
```

## Performance Tips

### 1. Use Select Specific Columns

```dart
// Bad - fetches everything
.select('*')

// Good - only what you need
.select('id, name, type, fare')
```

### 2. Limit Results

```dart
.select()
.limit(20)
```

### 3. Use Indexes

```sql
-- Add indexes for frequently queried columns
CREATE INDEX idx_routes_from_location ON routes(from_location_id);
CREATE INDEX idx_routes_to_location ON routes(to_location_id);
CREATE INDEX idx_stops_route ON stops(route_id);
```

### 4. Pagination

```dart
Future<List<Bus>> fetchBusesPaginated(int page, int pageSize) async {
  final from = page * pageSize;
  final to = from + pageSize - 1;
  
  final response = await supabase
      .from('buses')
      .select()
      .range(from, to);
      
  return (response as List).map((json) => Bus.fromJson(json)).toList();
}
```

## Testing

### Mock Supabase for Tests

```dart
class MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  test('Fetch buses returns list', () async {
    final mockClient = MockSupabaseClient();
    
    when(mockClient.from('buses').select())
        .thenAnswer((_) async => [
          {'id': '1', 'name': 'Bus 42A', 'type': 'Government', 'fare': 25}
        ]);
    
    // Test your function
  });
}
```

## Complete Example

Here's a complete example of updating `home_screen.dart`:

```dart
class _HomeScreenState extends State<HomeScreen> {
  List<String> _locations = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadLocations();
  }
  
  Future<void> _loadLocations() async {
    try {
      final response = await supabase
          .from('locations')
          .select('name')
          .order('name');
      
      setState(() {
        _locations = (response as List)
            .map((item) => item['name'] as String)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading locations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // Rest of your UI
  }
}
```

## Resources

- [Supabase Flutter Docs](https://supabase.com/docs/reference/dart)
- [Supabase Realtime](https://supabase.com/docs/guides/realtime)
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)
