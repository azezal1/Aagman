# App Architecture

## System Overview

```
┌─────────────────────────────────────────────┐
│           Bus Tracker Mobile App            │
│              (Flutter/Dart)                 │
└─────────────────────────────────────────────┘
                    │
                    ├─── UI Layer (Screens)
                    ├─── Widget Layer (Components)
                    ├─── Config Layer (Theme/Setup)
                    ├─── Model Layer (Data)
                    └─── Backend (Supabase)
```

## Layer Architecture

### 1. UI Layer (Screens)
```
lib/screens/
├── splash_screen.dart          → Welcome
├── home_screen.dart            → Main interface
├── bus_search_results_screen.dart → Bus list
├── live_tracking_screen.dart   → Map view
├── route_details_screen.dart   → Timeline
├── passenger_journey_screen.dart → Progress
├── feedback_screen.dart        → Help
└── notifications_screen.dart   → Alerts
```

### 2. Widget Layer
```
lib/widgets/
└── location_dropdown.dart      → Reusable dropdown
```

### 3. Config Layer
```
lib/config/
├── theme.dart                  → Design system
└── supabase_config.dart        → Backend setup
```

### 4. Model Layer
```
lib/models/
└── bus.dart                    → Data structures
```

## Data Flow

```
User Input
    ↓
Screen (UI)
    ↓
State Management
    ↓
Supabase Client
    ↓
Database
    ↓
Response
    ↓
Update UI
```

## Navigation Flow

```
Splash Screen (3s)
    ↓
Home Screen
    ├→ Search → Bus Results → Live Tracking
    ├→ Search → Bus Results → Route Details
    ├→ Nearby Bus → Live Tracking
    ├→ Notifications
    └→ Help/Feedback
```

## Backend Architecture

```
Supabase
├── PostgreSQL Database
│   ├── buses
│   ├── locations
│   ├── routes
│   ├── stops
│   ├── feedback
│   └── notifications
├── Real-time Subscriptions
├── RESTful API
└── Authentication (optional)
```

## Complete documentation in other files.
