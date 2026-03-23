# Complete App Redesign Plan - HTML Prototype Style

## Overview
Systematically updating all screens in the Aagman app to match the HTML prototype design with consistent brutalist aesthetics, sharp corners, bold borders, and Space Grotesk/Public Sans typography.

## Screens to Update

### ✓ Completed
1. **Theme System** (lib/config/theme.dart) - Done
2. **Home Screen** (lib/screens/home_screen.dart) - Done
3. **Route Details Screen** (lib/screens/route_details_screen.dart) - Done
4. **Profile Screen** (lib/screens/profile_screen.dart) - Done
5. **Main Navigation** (lib/screens/main_navigation.dart) - Done
6. **Video Splash Screen** (lib/screens/video_splash_screen.dart) - Done
7. **Reusable Widgets** (lib/widgets/*) - Done

### 🔄 In Progress
8. **Search Screen** (lib/screens/search_screen.dart)
9. **Track Screen** (lib/screens/track_screen.dart)
10. **Bus Search Results** (lib/screens/bus_search_results_screen.dart)
11. **Live Tracking Screen** (lib/screens/live_tracking_screen.dart)
12. **Passenger Journey Screen** (lib/screens/passenger_journey_screen.dart)
13. **Notifications Screen** (lib/screens/notifications_screen.dart)
14. **Driver Login Screen** (lib/screens/driver_login_screen.dart)
15. **Driver Tracking Screen** (lib/screens/driver_tracking_screen.dart)
16. **Travel Analytics Screen** (lib/screens/travel_analytics_screen.dart)
17. **Rate Bus Screen** (lib/screens/rate_bus_screen.dart)
18. **Rate Driver Screen** (lib/screens/rate_driver_screen.dart)
19. **Report Delay Screen** (lib/screens/report_delay_screen.dart)

## Design System Checklist

For each screen, ensure:

### Typography
- [ ] Headlines: Space Grotesk, 700-900 weight
- [ ] Labels: Space Grotesk, uppercase, wide letter spacing
- [ ] Body: Public Sans, 400 weight
- [ ] All sizes match HTML prototype

### Colors
- [ ] Primary: #2563EB
- [ ] Accent: #6CF8BB
- [ ] Background: #F9F9F9
- [ ] Surface: #FFFFFF
- [ ] Text Primary: #1A1C1C
- [ ] Text Muted: #434655
- [ ] Border: #E2E2E2

### Layout
- [ ] BorderRadius.zero (sharp corners)
- [ ] 3px borders on all cards/buttons
- [ ] 4px shadow offset (no blur)
- [ ] Consistent spacing (16px, 24px, 32px)
- [ ] Grid-based layouts

### Components
- [ ] Top app bar with 2px bottom border
- [ ] Search bars with 3px border + 4px shadow
- [ ] Cards with 3px border + 4px shadow
- [ ] Buttons with 3px border
- [ ] Active-press animation where applicable

### Functionality
- [ ] All navigation works
- [ ] All buttons functional
- [ ] Data loads from Supabase
- [ ] Real-time updates work
- [ ] Forms submit correctly
- [ ] Error handling in place

## Implementation Strategy

### Phase 1: Core Navigation Screens (Priority 1)
1. Search Screen - Search functionality with results
2. Track Screen - Active buses list
3. Bus Search Results - Filter and sort

### Phase 2: Tracking Screens (Priority 2)
4. Live Tracking Screen - Map with real-time updates
5. Passenger Journey Screen - Current journey status
6. Route Details Screen - Already done

### Phase 3: User Interaction Screens (Priority 3)
7. Notifications Screen - Alert list
8. Travel Analytics Screen - Statistics dashboard
9. Rate Bus Screen - Rating form
10. Rate Driver Screen - Rating form
11. Report Delay Screen - Delay reporting form

### Phase 4: Driver Screens (Priority 4)
12. Driver Login Screen - Authentication
13. Driver Tracking Screen - GPS tracking

## Key Updates Per Screen

### Search Screen
- Top app bar with AAGMAN branding
- Large search input with 3px border
- Results in cards with 3px borders
- Bus icon boxes with colored backgrounds
- Sharp corners throughout

### Track Screen
- Active buses grid/list
- Each bus card with status indicator
- "LIVE" badges for active tracking
- Refresh functionality
- Sharp corners and bold borders

### Bus Search Results
- Filter chips with 3px borders
- Sort dropdown
- Bus cards with departure/arrival times
- Price display in large text
- Action buttons (View Route, Track Live)

### Live Tracking Screen
- Full-screen map
- Draggable bottom sheet (25%-75%)
- Bold timing display "BUS 23 — 2 MIN"
- Pulsing bus marker
- Sharp-edged controls

### Passenger Journey Screen
- HUGE time display "15 MIN" (40px)
- Bold "ONBOARD" status
- Progress timeline
- Stops counter
- Sharp action buttons

### Notifications Screen
- Notification cards with icons
- Time stamps
- Read/unread states
- Clear all button
- 3px borders on cards

### Driver Screens
- Login form with 3px borders
- GPS tracking interface
- Status indicators
- Location update display
- Sharp, functional design

## Testing Checklist

After each screen update:
- [ ] No diagnostic errors
- [ ] Screen renders correctly
- [ ] Navigation works
- [ ] Data loads properly
- [ ] Buttons are functional
- [ ] Typography matches
- [ ] Colors match
- [ ] Borders and shadows correct
- [ ] Responsive layout
- [ ] Performance is good

## Final Verification

Before completion:
- [ ] All screens updated
- [ ] Consistent design throughout
- [ ] All functionality works
- [ ] No errors in console
- [ ] App builds successfully
- [ ] APK can be generated
- [ ] Documentation updated
- [ ] README reflects new design

## Notes

- Maintain existing Supabase integration
- Keep real-time functionality intact
- Preserve all user features
- Ensure backward compatibility
- Test on both web and mobile
- Verify all navigation flows
- Check all form submissions
- Test error states

## Timeline

- Phase 1: 30 minutes
- Phase 2: 30 minutes
- Phase 3: 30 minutes
- Phase 4: 20 minutes
- Testing: 20 minutes
- Total: ~2.5 hours

## Success Criteria

1. All screens match HTML prototype design
2. All functionality preserved and working
3. No diagnostic errors
4. Consistent user experience
5. App builds and runs successfully
6. Performance is maintained
7. Code is clean and maintainable
