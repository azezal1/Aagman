-- Aagman Bus Tracker - Complete Database Setup
-- Run this in Supabase SQL Editor

-- 1. Create Locations Table
CREATE TABLE IF NOT EXISTS locations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 2. Create Buses Table
CREATE TABLE IF NOT EXISTS buses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('Government', 'Private')),
  fare INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 3. Create Routes Table
CREATE TABLE IF NOT EXISTS routes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bus_id UUID REFERENCES buses(id) ON DELETE CASCADE,
  from_location_id UUID REFERENCES locations(id),
  to_location_id UUID REFERENCES locations(id),
  departure_time TIME NOT NULL,
  arrival_time TIME NOT NULL,
  route_type TEXT DEFAULT 'Direct' CHECK (route_type IN ('Direct', 'Via')),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4. Create Stops Table
CREATE TABLE IF NOT EXISTS stops (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  route_id UUID REFERENCES routes(id) ON DELETE CASCADE,
  location_id UUID REFERENCES locations(id),
  stop_order INTEGER NOT NULL,
  arrival_time TIME NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 5. Create Feedback Table
CREATE TABLE IF NOT EXISTS feedback (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  issue_type TEXT NOT NULL,
  message TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 6. Create Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('arrival', 'delay', 'boarding')),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 7. Insert Sample Locations (Indian cities/towns)
INSERT INTO locations (name, latitude, longitude) VALUES
('Bus Stand', 23.0225, 72.5714),
('Railway Station', 23.0300, 72.5800),
('City Center', 23.0250, 72.5750),
('Hospital', 23.0280, 72.5780),
('College', 23.0320, 72.5820),
('Market', 23.0260, 72.5760),
('Airport', 23.0640, 72.6347),
('Shopping Mall', 23.0350, 72.5650),
('University', 23.0400, 72.5900),
('Tech Park', 23.0500, 72.6000);

-- 8. Insert Sample Buses
INSERT INTO buses (name, type, fare) VALUES
('Bus 42A', 'Government', 25),
('Express 18', 'Private', 45),
('Bus 7B', 'Government', 20),
('Deluxe 101', 'Private', 60),
('Bus 15', 'Government', 30),
('Super Express 25', 'Private', 55);

-- 9. Insert Sample Routes
INSERT INTO routes (bus_id, from_location_id, to_location_id, departure_time, arrival_time, route_type)
SELECT 
  b.id,
  (SELECT id FROM locations WHERE name = 'Bus Stand'),
  (SELECT id FROM locations WHERE name = 'Railway Station'),
  '08:30:00',
  '09:45:00',
  'Direct'
FROM buses b WHERE b.name = 'Bus 42A';

INSERT INTO routes (bus_id, from_location_id, to_location_id, departure_time, arrival_time, route_type)
SELECT 
  b.id,
  (SELECT id FROM locations WHERE name = 'Bus Stand'),
  (SELECT id FROM locations WHERE name = 'Railway Station'),
  '09:00:00',
  '10:00:00',
  'Direct'
FROM buses b WHERE b.name = 'Express 18';

INSERT INTO routes (bus_id, from_location_id, to_location_id, departure_time, arrival_time, route_type)
SELECT 
  b.id,
  (SELECT id FROM locations WHERE name = 'City Center'),
  (SELECT id FROM locations WHERE name = 'Airport'),
  '09:30:00',
  '11:00:00',
  'Via'
FROM buses b WHERE b.name = 'Bus 7B';

-- 10. Insert Sample Notifications
INSERT INTO notifications (title, message, type) VALUES
('Bus 42A arriving soon', 'Your bus will arrive in 5 minutes', 'arrival'),
('Bus 18 delayed', 'Expected delay of 10 minutes', 'delay'),
('Boarding reminder', 'Bus 7B is at your stop', 'boarding');

-- 11. Enable Row Level Security (RLS)
ALTER TABLE buses ENABLE ROW LEVEL SECURITY;
ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE stops ENABLE ROW LEVEL SECURITY;
ALTER TABLE feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- 12. Create Policies for Public Read Access
CREATE POLICY "Public read access" ON buses FOR SELECT USING (true);
CREATE POLICY "Public read access" ON routes FOR SELECT USING (true);
CREATE POLICY "Public read access" ON locations FOR SELECT USING (true);
CREATE POLICY "Public read access" ON stops FOR SELECT USING (true);
CREATE POLICY "Public read access" ON notifications FOR SELECT USING (true);

-- 13. Allow Anyone to Submit Feedback
CREATE POLICY "Anyone can submit feedback" ON feedback FOR INSERT WITH CHECK (true);

-- Success! Database is ready.
