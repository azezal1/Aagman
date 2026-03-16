# Supabase Setup Instructions

Your Supabase credentials are already configured in the app! ✅

## Step 1: Create Database Tables

1. Go to your Supabase project: https://pxtydnqkpjjlzzqnqjff.supabase.co
2. Click on **SQL Editor** in the left sidebar
3. Click **New Query**
4. Copy the entire contents of `supabase_setup.sql` file
5. Paste it into the SQL editor
6. Click **Run** (or press Ctrl+Enter)

You should see: "Success. No rows returned"

## Step 2: Verify Tables Created

1. Click on **Table Editor** in the left sidebar
2. You should see these tables:
   - ✅ locations (10 sample locations)
   - ✅ buses (6 sample buses)
   - ✅ routes (3 sample routes)
   - ✅ stops
   - ✅ feedback
   - ✅ notifications (3 sample notifications)

## Step 3: Test the App

```bash
# Make sure you're in the project directory
cd C:\Users\Hp\Desktop\Aagman

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## What's Already Configured

✅ Supabase URL: `https://pxtydnqkpjjlzzqnqjff.supabase.co`
✅ Anon Key: Added to `lib/main.dart`
✅ Config file: Updated in `lib/config/supabase_config.dart`

## Sample Data Included

### Locations
- Bus Stand, Railway Station, City Center
- Hospital, College, Market
- Airport, Shopping Mall, University, Tech Park

### Buses
- Bus 42A (Government, ₹25)
- Express 18 (Private, ₹45)
- Bus 7B (Government, ₹20)
- Deluxe 101 (Private, ₹60)
- Bus 15 (Government, ₹30)
- Super Express 25 (Private, ₹55)

### Routes
- Bus Stand → Railway Station (Bus 42A, 08:30-09:45)
- Bus Stand → Railway Station (Express 18, 09:00-10:00)
- City Center → Airport (Bus 7B, 09:30-11:00)

## Troubleshooting

### "relation does not exist" error
→ Run the SQL setup script in Supabase SQL Editor

### "Invalid API key" error
→ Credentials are already correct, check internet connection

### App won't connect
→ Make sure you ran `flutter pub get`

## Next Steps

Once database is set up:
1. Run the app
2. Test search functionality
3. View nearby buses
4. Check notifications
5. Try all screens

## Add More Data

To add more locations, buses, or routes, use the Supabase Table Editor or run SQL:

```sql
-- Add a new location
INSERT INTO locations (name, latitude, longitude) 
VALUES ('New Location', 23.0500, 72.6000);

-- Add a new bus
INSERT INTO buses (name, type, fare) 
VALUES ('Bus 99', 'Government', 35);
```

---

**Ready?** Run the SQL script in Supabase and then test your app!
