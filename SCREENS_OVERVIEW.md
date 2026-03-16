# Screens Overview

This document describes all 8 screens in the Bus Tracker app with their layouts and functionality.

## 1. Splash Screen
**File:** `lib/screens/splash_screen.dart`

**Layout:**
```
┌─────────────────────────────┐
│                             │
│                             │
│         [Bus Icon]          │
│       80×80, muted green    │
│                             │
│      Bus Tracker            │
│   (24sp, semibold)          │
│                             │
│  Track your bus in          │
│      real-time              │
│   (14sp, secondary)         │
│                             │
│                             │
└─────────────────────────────┘
```

**Features:**
- Centered logo with soft background
- Simple app name and tagline
- Auto-navigates to home after 3 seconds
- Clean, minimal design

---

## 2. Home Screen
**File:** `lib/screens/home_screen.dart`

**Layout:**
```
┌─────────────────────────────┐
│ Bus Tracker        [🔔]     │ App Bar
├─────────────────────────────┤
│                             │
│  ┌─ Plan Your Journey ────┐ │
│  │                         │ │
│  │ From: [Dropdown ▼]     │ │
│  │                         │ │
│  │ To: [Dropdown ▼]       │ │
│  │                         │ │
│  │ Date: [📅 16/03/2026]  │ │
│  │                         │ │
│  │ [Show Bus Details]     │ │
│  └─────────────────────────┘ │
│                             │
│  Nearby Buses               │
│  ┌─────────────────────────┐ │
│  │ [🚌] Bus 42A           │ │
│  │      Arriving in 5 min  │ │
│  │                Govt     │ │
│  └─────────────────────────┘ │
│  ┌─────────────────────────┐ │
│  │ [🚌] Bus 18            │ │
│  │      Arriving in 12 min │ │
│  │               Private   │ │
│  └─────────────────────────┘ │
├─────────────────────────────┤
│ [Home] [Search] [Track] [?] │ Bottom Nav
└─────────────────────────────┘
```

**Features:**
- Search form with location dropdowns
- Date picker for journey planning
- Nearby buses with ETA
- Bottom navigation bar
- Notification bell icon

---

## 3. Bus Search Results Screen
**File:** `lib/screens/bus_search_results_screen.dart`

**Layout:**
```
┌─────────────────────────────┐
│ ← Bus Stand → Railway Stn   │
│   3 buses available         │
├─────────────────────────────┤
│ [All] [Govt] [Private] [⋮] │ Filters
├─────────────────────────────┤
│  ┌─────────────────────────┐ │
│  │ [🚌] Bus 42A      ₹25  │ │
│  │      Government         │ │
│  │                         │ │
│  │ Departure    →  Arrival │ │
│  │ 08:30 AM        09:45 AM│ │
│  │                         │ │
│  │ [View Route] [Track]   │ │
│  └─────────────────────────┘ │
│                             │
│  ┌─────────────────────────┐ │
│  │ [🚌] Express 18   ₹45  │ │
│  │      Private            │ │
│  │                         │ │
│  │ Departure    →  Arrival │ │
│  │ 09:00 AM        10:00 AM│ │
│  │                         │ │
│  │ [View Route] [Track]   │ │
│  └─────────────────────────┘ │
└─────────────────────────────┘
```

**Features:**
- Route summary in header
- Filter chips (All, Government, Private)
- Sort menu (by price)
- Bus cards with all details
- Two action buttons per bus

---

## 4. Live Tracking Screen
**File:** `lib/screens/live_tracking_screen.dart`

**Layout:**
```
┌─────────────────────────────┐
│ ← Live Tracking             │
├─────────────────────────────┤
│                             │
│                             │
│        [Map View]           │
│     (Google Maps)           │
│   • Bus marker              │
│   • Route line              │
│   • Stop markers            │
│                             │
│                             │
├─────────────────────────────┤
│ ═══ (drag handle)           │
│                             │
│ [🚌] Bus 42A                │
│      Government             │
│                             │
│ ┌─ On the way ────────────┐ │
│ │ 📍 Arriving at City      │ │
│ │    Center in 5 min       │ │
│ └─────────────────────────┘ │
│                             │
│ Next Stops                  │
│ ○ City Center      5 min    │
│ ○ Hospital        15 min    │
│ ○ College         25 min    │
└─────────────────────────────┘
```

**Features:**
- Full-screen map view
- Draggable bottom sheet
- Current bus status
- ETA to next stop
- List of upcoming stops

---

## 5. Route Details Screen
**File:** `lib/screens/route_details_screen.dart`

**Layout:**
```
┌─────────────────────────────┐
│ ← Bus 42A                   │
│   Direct Route              │
├─────────────────────────────┤
│                             │
│  ✓─┐ Bus Stand              │
│    │  08:30 AM               │
│    │                         │
│  ✓─┐ City Center            │
│    │  08:45 AM               │
│    │                         │
│  ●─┐ Hospital               │
│    │  09:00 AM               │
│    │  (highlighted)          │
│    │                         │
│  ○─┐ College                │
│    │  09:20 AM               │
│    │                         │
│  ○─┐ Market                 │
│    │  09:35 AM               │
│    │                         │
│  ○─  Railway Station        │
│      09:45 AM               │
│                             │
└─────────────────────────────┘
```

**Features:**
- Timeline layout
- Completed stops (checkmark)
- Current stop (filled circle)
- Upcoming stops (empty circle)
- Time at each stop
- Route type indicator

---

## 6. Passenger Journey Screen
**File:** `lib/screens/passenger_journey_screen.dart`

**Layout:**
```
┌─────────────────────────────┐
│ ← Your Journey              │
├─────────────────────────────┤
│                             │
│  ┌─────────────────────────┐ │
│  │                         │ │
│  │      [🚌 Icon]          │ │
│  │       80×80             │ │
│  │                         │ │
│  │      Onboard            │ │
│  │      Bus 42A            │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│  Journey Progress           │
│                             │
│  ✓  Bus Stand               │
│  │  08:30 AM                │
│  │                          │
│  ✓  City Center             │
│  │  08:45 AM                │
│  │                          │
│  ●  Hospital                │
│     09:00 AM                │
│     (current)               │
│                             │
│  ○  College                 │
│     09:20 AM                │
│                             │
│  ○  Railway Station         │
│     09:45 AM                │
│                             │
│  [Mark as Reached]          │
│                             │
└─────────────────────────────┘
```

**Features:**
- Status card (Waiting/Onboard/Reached)
- Journey progress timeline
- Current location highlighted
- Action button

---

## 7. Feedback/Help Screen
**File:** `lib/screens/feedback_screen.dart`

**Layout:**
```
┌─────────────────────────────┐
│ ← Help & Feedback           │
├─────────────────────────────┤
│                             │
│  How can we help you?       │
│  Select an issue or write   │
│                             │
│  Select Issue               │
│                             │
│  ○ Where is my bus?         │
│                             │
│  ○ Bus delayed              │
│                             │
│  ○ Wrong route information  │
│                             │
│  ○ App not working          │
│                             │
│  ○ Other                    │
│                             │
│  Describe your issue        │
│  ┌─────────────────────────┐ │
│  │                         │ │
│  │ Tell us more...         │ │
│  │                         │ │
│  │                         │ │
│  └─────────────────────────┘ │
│                             │
│  [Submit Feedback]          │
│                             │
└─────────────────────────────┘
```

**Features:**
- Radio button issue selection
- Multi-line text input
- Simple, approachable form
- Submit button

---

## 8. Notifications Screen
**File:** `lib/screens/notifications_screen.dart`

**Layout:**
```
┌─────────────────────────────┐
│ ← Notifications             │
├─────────────────────────────┤
│                             │
│  ┌─────────────────────────┐ │
│  │ [🔔] Bus 42A arriving   │ │
│  │      soon               │ │
│  │                         │ │
│  │      Your bus will      │ │
│  │      arrive in 5 min    │ │
│  │                         │ │
│  │      2 min ago          │ │
│  └─────────────────────────┘ │
│                             │
│  ┌─────────────────────────┐ │
│  │ [⏰] Bus 18 delayed     │ │
│  │                         │ │
│  │      Expected delay     │ │
│  │      of 10 minutes      │ │
│  │                         │ │
│  │      15 min ago         │ │
│  └─────────────────────────┘ │
│                             │
│  ┌─────────────────────────┐ │
│  │ [🚌] Boarding reminder  │ │
│  │                         │ │
│  │      Bus 7B is at       │ │
│  │      your stop          │ │
│  │                         │ │
│  │      1 hour ago         │ │
│  └─────────────────────────┘ │
│                             │
└─────────────────────────────┘
```

**Features:**
- List of notifications
- Icon based on type
- Title and message
- Timestamp
- Empty state when no notifications

---

## Design Consistency

All screens follow these principles:

✓ **Muted color palette** - No bright colors
✓ **Clean spacing** - 16px standard padding
✓ **Rounded corners** - 12px on cards
✓ **Subtle borders** - 0.5px light grey
✓ **Large touch targets** - 48dp minimum
✓ **Simple icons** - Line style only
✓ **Readable text** - 16sp body, 14sp secondary
✓ **Minimal shadows** - Only where needed

## Navigation Flow

```
Splash → Home → Search Results → Live Tracking
                                → Route Details
                                
Home → Nearby Bus → Live Tracking → Journey Screen

Home → Notifications

Home → Help/Feedback
```

## Color Usage

- **Accent (Muted Green)**: Buttons, active states, live indicators
- **Status Blue**: Government buses
- **Status Amber**: Private buses
- **Text Primary**: All headings and body text
- **Text Secondary**: Supporting text, timestamps
- **Border**: Card outlines, dividers
