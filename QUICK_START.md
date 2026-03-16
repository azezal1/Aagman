# Quick Start Checklist

Get your Bus Tracker app running in 15 minutes!

## ☐ Step 1: Install Flutter (5 min)

If you don't have Flutter installed:

```bash
# Check if Flutter is installed
flutter --version

# If not installed, visit: https://flutter.dev/docs/get-started/install
```

## ☐ Step 2: Get Dependencies (1 min)

```bash
cd bus_tracker
flutter pub get
```

## ☐ Step 3: Create Supabase Project (3 min)

1. Go to [supabase.com](https://supabase.com)
2. Click "Start your project"
3. Create a new project (wait 1-2 minutes)
4. Go to Settings > API
5. Copy:
   - Project URL
   - Anon/Public Key

## ☐ Step 4: Add Credentials (1 min)

Open `lib/main.dart` and replace:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',        // ← Paste here
  anonKey: 'YOUR_SUPABASE_ANON_KEY', // ← Paste here
);
```

## ☐ Step 5: Create Database (2 min)

1. In Supabase, go to SQL Editor
2. Copy this SQL and run it:

```sql
-- Locations
CREATE TABLE locations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Buses
CREATE TABLE buses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  fare INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Routes
CREATE TABLE routes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bus_id UUID REFERENCES buses(id),
  from_location_id UUID REFERENCES locations(id),
  to_location_id UUID REFERENCES locations(id),
  departure_time TIME NOT NULL,
  arrival_time TIME NOT NULL,
  route_type TEXT DEFAULT 'Direct',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Stops
CREATE TABLE stops (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  route_id UUID REFERENCES routes(id),
  location_id UUID REFERENCES locations(id),
  stop_order INTEGER NOT NULL,
  arrival_time TIME NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Feedback
CREATE TABLE feedback (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  issue_type TEXT NOT NULL,
  message TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Notifications
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Sample Data
INSERT INTO locations (name, latitude, longitude) VALUES
('Bus Stand', 23.0225, 72.5714),
('Railway Station', 23.0300, 72.5800),
('City Center', 23.0250, 72.5750),
('Hospital', 23.0280, 72.5780),
('College', 23.0320, 72.5820),
('Market', 23.0260, 72.5760);

INSERT INTO buses (name, type, fare) VALUES
('Bus 42A', 'Government', 25),
('Express 18', 'Private', 45),
('Bus 7B', 'Government', 20);
```

## ☐ Step 6: Run the App (1 min)

```bash
# Connect your phone or start emulator
flutter devices

# Run the app
flutter run
```

## ☐ Step 7: Test It Out (2 min)

1. ✓ Splash screen appears
2. ✓ Home screen loads
3. ✓ Select "From" location
4. ✓ Select "To" location
5. ✓ Click "Show Bus Details"
6. ✓ See bus list
7. ✓ Try filters (All, Government, Private)
8. ✓ Click "Track Live"
9. ✓ Navigate through all screens

## 🎉 Done!

Your app is running! Now you can:

- Customize colors in `lib/config/theme.dart`
- Add more locations and buses in Supabase
- Integrate Google Maps for live tracking
- Deploy to Play Store / App Store

## Troubleshooting

### "Supabase not initialized"
→ Check credentials in `lib/main.dart`

### "Table does not exist"
→ Run the SQL in Supabase SQL Editor

### Build errors
→ Run `flutter clean` then `flutter pub get`

### No locations showing
→ Make sure sample data was inserted

## Next Steps

Read these for more details:
- `SETUP_GUIDE.md` - Detailed setup instructions
- `SUPABASE_INTEGRATION.md` - Connect real data
- `DESIGN_SYSTEM.md` - Customize the look
- `PROJECT_SUMMARY.md` - Complete overview

## Need Help?

- Flutter: [flutter.dev/docs](https://flutter.dev/docs)
- Supabase: [supabase.com/docs](https://supabase.com/docs)
- Issues: Check the documentation files

---

**Total Time**: ~15 minutes
**Difficulty**: Easy
**Result**: Fully functional bus tracking app! 🚌
