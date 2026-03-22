# 👥 Community Features & Travel Analytics - Complete Guide

## ✅ What's Been Implemented

All community features and travel analytics are now fully functional!

### 1. Report Delay 🚨
- Report bus delays in real-time
- Specify delay duration (5-60 minutes)
- Select reason from dropdown
- Add optional location
- Helps other passengers plan better

### 2. Rate Bus ⭐
- Overall rating (1-5 stars)
- Detailed ratings:
  - Cleanliness
  - Comfort
  - Punctuality
- Optional written review
- Helps improve service quality

### 3. Rate Driver 👤
- Overall driver rating (1-5 stars)
- Detailed ratings:
  - Driving quality
  - Behavior & courtesy
- Optional feedback
- Encourages better service

### 4. Travel Analytics 📊
- Monthly travel summary
- Total trips count
- Distance traveled
- Money spent
- CO₂ saved (environmental impact)
- Most used routes with frequency
- Recent trip history
- Trees equivalent calculation

---

## 📁 Files Created

### Screens:
1. `lib/screens/report_delay_screen.dart` - Report bus delays
2. `lib/screens/rate_bus_screen.dart` - Rate bus service
3. `lib/screens/rate_driver_screen.dart` - Rate driver performance
4. `lib/screens/travel_analytics_screen.dart` - View travel statistics

### Database Schema:
- `supabase_community_schema.sql` - All tables and policies

---

## 🗄️ Database Tables

### 1. delay_reports
```sql
- id (UUID)
- bus_id (TEXT)
- bus_name (TEXT)
- reported_by (TEXT) - optional user_id
- delay_minutes (INTEGER)
- reason (TEXT)
- location (TEXT)
- created_at (TIMESTAMP)
- verified (BOOLEAN)
```

### 2. bus_ratings
```sql
- id (UUID)
- bus_id (TEXT)
- bus_name (TEXT)
- user_id (TEXT)
- rating (INTEGER 1-5)
- review (TEXT)
- cleanliness_rating (INTEGER 1-5)
- comfort_rating (INTEGER 1-5)
- punctuality_rating (INTEGER 1-5)
- created_at (TIMESTAMP)
```

### 3. driver_ratings
```sql
- id (UUID)
- driver_id (TEXT)
- bus_id (TEXT)
- user_id (TEXT)
- rating (INTEGER 1-5)
- feedback (TEXT)
- driving_quality (INTEGER 1-5)
- behavior_rating (INTEGER 1-5)
- created_at (TIMESTAMP)
```

### 4. travel_history
```sql
- id (UUID)
- user_id (TEXT)
- bus_id (TEXT)
- bus_name (TEXT)
- from_location (TEXT)
- to_location (TEXT)
- travel_date (DATE)
- travel_time (TIME)
- duration_minutes (INTEGER)
- fare (DECIMAL)
- created_at (TIMESTAMP)
```

---

## 🚀 How to Use

### Access Community Features:

**From Live Tracking Screen:**
1. Track any bus
2. Scroll down in the bottom sheet
3. See "Community" section with 3 buttons:
   - Report Delay
   - Rate Bus
   - Rate Driver

**From Home Screen:**
1. Tap the Analytics icon (📊) in the header
2. View your travel analytics

### Report a Delay:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ReportDelayScreen(
      busId: 'bus_id',
      busName: 'Bus 42A',
    ),
  ),
);
```

### Rate a Bus:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RateBusScreen(
      busId: 'bus_id',
      busName: 'Bus 42A',
    ),
  ),
);
```

### Rate a Driver:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RateDriverScreen(
      driverId: 'driver_id',
      busId: 'bus_id',
      busName: 'Bus 42A',
    ),
  ),
);
```

### View Analytics:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TravelAnalyticsScreen(
      userId: 'user_id',
    ),
  ),
);
```

---

## 📊 Travel Analytics Features

### Monthly Summary Card:
- Shows current month and year
- Beautiful gradient header
- Quick overview

### Statistics Grid (4 Cards):
1. **Total Trips** - Number of trips this month
2. **Distance** - Total kilometers traveled
3. **Money Spent** - Total fare paid (₹)
4. **CO₂ Saved** - Environmental impact (kg)

### Most Used Routes:
- Shows top 5 routes
- Trip count for each route
- Percentage bar visualization
- Helps identify favorite routes

### Environmental Impact:
- CO₂ saved vs driving a car
- Trees equivalent calculation
- Encourages sustainable transport

### Recent Trips List:
- Last 10 trips
- Bus name and route
- Date and fare
- Duration if available

---

## 🎨 UI Design

### Color Coding:
- **Report Delay**: Warning (Orange) - `AppTheme.warning`
- **Rate Bus**: Primary (Blue) - `AppTheme.primary`
- **Rate Driver**: Secondary (Green) - `AppTheme.secondary`
- **Analytics**: Primary (Blue) - `AppTheme.primary`

### Design Principles:
- Clean, professional interface
- Consistent with app theme
- Easy to use
- Clear visual hierarchy
- Helpful info messages

---

## 🔄 Data Flow

### Reporting Delay:
1. User selects bus
2. Opens live tracking
3. Taps "Report Delay"
4. Adjusts slider (5-60 min)
5. Selects reason
6. Adds location (optional)
7. Submits → Saved to Supabase
8. Success message shown

### Rating Bus/Driver:
1. User travels on bus
2. Opens live tracking
3. Taps "Rate Bus" or "Rate Driver"
4. Gives overall rating (stars)
5. Provides detailed ratings (sliders)
6. Writes review/feedback (optional)
7. Submits → Saved to Supabase
8. Thank you message shown

### Travel Analytics:
1. User taps analytics icon
2. App fetches current month's data
3. Calculates statistics
4. Displays in organized sections
5. Pull to refresh for updates

---

## 📱 Testing Guide

### Test Report Delay:
1. Open any bus tracking screen
2. Scroll to Community section
3. Tap "Report Delay"
4. Set delay to 15 minutes
5. Select "Heavy traffic"
6. Add location "City Center"
7. Submit
8. Check Supabase for new entry

### Test Rate Bus:
1. Open any bus tracking screen
2. Tap "Rate Bus"
3. Give 4 stars overall
4. Rate cleanliness: 4
5. Rate comfort: 3
6. Rate punctuality: 5
7. Write review
8. Submit
9. Check Supabase

### Test Rate Driver:
1. Open any bus tracking screen
2. Tap "Rate Driver"
3. Give 5 stars overall
4. Rate driving quality: 5
5. Rate behavior: 5
6. Write feedback
7. Submit
8. Check Supabase

### Test Travel Analytics:
1. First, add sample data to travel_history table:
```sql
INSERT INTO travel_history (user_id, bus_id, bus_name, from_location, to_location, travel_date, duration_minutes, fare) VALUES
('user_001', '1', 'Bus 42A', 'Potheri', 'Chennai', '2026-03-15', 45, 50),
('user_001', '2', 'Express 18', 'Chennai', 'Potheri', '2026-03-15', 40, 50),
('user_001', '1', 'Bus 42A', 'Potheri', 'Chennai', '2026-03-16', 45, 50),
('user_001', '3', 'Bus 7B', 'Potheri', 'Tambaram', '2026-03-17', 30, 30),
('user_001', '1', 'Bus 42A', 'Potheri', 'Chennai', '2026-03-18', 45, 50);
```

2. Tap analytics icon in home screen
3. View monthly summary
4. Check statistics
5. See most used routes
6. View environmental impact
7. Scroll through recent trips
8. Pull to refresh

---

## 🔐 Security & Privacy

### Row Level Security (RLS):
- All tables have RLS enabled
- Public read access for transparency
- Public insert for anonymous reporting
- Users can read their own travel history

### Anonymous Reporting:
- Delay reports don't require login
- Ratings can be anonymous
- Helps encourage honest feedback

---

## 🎯 Future Enhancements

### Potential Additions:
1. **Aggregate Statistics**:
   - Show average ratings per bus
   - Display delay frequency
   - Community trust scores

2. **Notifications**:
   - Alert when your frequent route has delays
   - Notify about highly-rated buses
   - Monthly analytics summary

3. **Gamification**:
   - Badges for frequent travelers
   - Points for helpful reports
   - Leaderboards

4. **Social Features**:
   - Share analytics on social media
   - Compare with friends
   - Community challenges

5. **Advanced Analytics**:
   - Yearly comparison
   - Peak travel times
   - Cost optimization suggestions
   - Route recommendations

6. **Driver Dashboard**:
   - View their own ratings
   - See feedback
   - Track improvements

---

## 🐛 Troubleshooting

### Issue: Data not showing in analytics
**Solution**: 
- Check if travel_history has data for current month
- Verify user_id matches
- Check Supabase connection

### Issue: Can't submit rating
**Solution**:
- Check internet connection
- Verify Supabase credentials
- Check RLS policies

### Issue: Delay report not saving
**Solution**:
- Check bus_id is valid
- Verify table exists in Supabase
- Check insert policy

---

## ✅ Checklist

- [x] Report Delay Screen created
- [x] Rate Bus Screen created
- [x] Rate Driver Screen created
- [x] Travel Analytics Screen created
- [x] Database schema created
- [x] Navigation added to Live Tracking
- [x] Analytics button added to Home
- [x] All imports added
- [x] UI matches app theme
- [x] Error handling implemented
- [x] Loading states added
- [x] Success messages shown

---

## 🎉 All Features Complete!

The community features and travel analytics are fully implemented and ready to use. Users can now:

1. ✅ Report delays to help others
2. ✅ Rate buses to improve service
3. ✅ Rate drivers to encourage quality
4. ✅ View their travel analytics
5. ✅ Track environmental impact
6. ✅ See most used routes

Just run the app and test all features! 🚀

---

## 📞 Support

If you need to add more features or modify existing ones, all the code is modular and well-documented. Each screen is independent and can be enhanced without affecting others.

Happy coding! 🎊
