import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Replace these with your actual Supabase credentials
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
  
  static SupabaseClient get client => Supabase.instance.client;
  
  // Database Tables
  static const String busesTable = 'buses';
  static const String routesTable = 'routes';
  static const String stopsTable = 'stops';
  static const String locationsTable = 'locations';
  static const String feedbackTable = 'feedback';
  static const String notificationsTable = 'notifications';
}

// Example Supabase Database Schema:
/*

-- Buses Table
CREATE TABLE buses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  type TEXT NOT NULL, -- 'Government' or 'Private'
  fare INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Locations Table
CREATE TABLE locations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Routes Table
CREATE TABLE routes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bus_id UUID REFERENCES buses(id),
  from_location_id UUID REFERENCES locations(id),
  to_location_id UUID REFERENCES locations(id),
  departure_time TIME NOT NULL,
  arrival_time TIME NOT NULL,
  route_type TEXT DEFAULT 'Direct', -- 'Direct' or 'Via'
  created_at TIMESTAMP DEFAULT NOW()
);

-- Stops Table
CREATE TABLE stops (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  route_id UUID REFERENCES routes(id),
  location_id UUID REFERENCES locations(id),
  stop_order INTEGER NOT NULL,
  arrival_time TIME NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Feedback Table
CREATE TABLE feedback (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  issue_type TEXT NOT NULL,
  message TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Notifications Table
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL, -- 'arrival', 'delay', 'boarding'
  created_at TIMESTAMP DEFAULT NOW()
);

*/
