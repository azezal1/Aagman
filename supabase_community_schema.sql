-- Community Features Schema

-- Delay Reports Table
CREATE TABLE IF NOT EXISTS delay_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bus_id TEXT NOT NULL,
  bus_name TEXT NOT NULL,
  reported_by TEXT, -- user_id or anonymous
  delay_minutes INTEGER NOT NULL,
  reason TEXT,
  location TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  verified BOOLEAN DEFAULT FALSE
);

-- Bus Ratings Table
CREATE TABLE IF NOT EXISTS bus_ratings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bus_id TEXT NOT NULL,
  bus_name TEXT NOT NULL,
  user_id TEXT,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  review TEXT,
  cleanliness_rating INTEGER CHECK (cleanliness_rating >= 1 AND cleanliness_rating <= 5),
  comfort_rating INTEGER CHECK (comfort_rating >= 1 AND comfort_rating <= 5),
  punctuality_rating INTEGER CHECK (punctuality_rating >= 1 AND punctuality_rating <= 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Driver Ratings Table
CREATE TABLE IF NOT EXISTS driver_ratings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  driver_id TEXT NOT NULL,
  bus_id TEXT NOT NULL,
  user_id TEXT,
  rating INTEGER CHECK (rating >= 1 AND rating <= 5),
  feedback TEXT,
  driving_quality INTEGER CHECK (driving_quality >= 1 AND driving_quality <= 5),
  behavior_rating INTEGER CHECK (behavior_rating >= 1 AND behavior_rating <= 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User Travel History Table
CREATE TABLE IF NOT EXISTS travel_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id TEXT NOT NULL,
  bus_id TEXT NOT NULL,
  bus_name TEXT NOT NULL,
  from_location TEXT NOT NULL,
  to_location TEXT NOT NULL,
  travel_date DATE NOT NULL,
  travel_time TIME,
  duration_minutes INTEGER,
  fare DECIMAL(10, 2),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE delay_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE bus_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE driver_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE travel_history ENABLE ROW LEVEL SECURITY;

-- Public read policies
CREATE POLICY "Allow public read on delay_reports" ON delay_reports FOR SELECT USING (true);
CREATE POLICY "Allow public read on bus_ratings" ON bus_ratings FOR SELECT USING (true);
CREATE POLICY "Allow public read on driver_ratings" ON driver_ratings FOR SELECT USING (true);

-- Public insert policies (for anonymous reporting)
CREATE POLICY "Allow public insert on delay_reports" ON delay_reports FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public insert on bus_ratings" ON bus_ratings FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public insert on driver_ratings" ON driver_ratings FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public insert on travel_history" ON travel_history FOR INSERT WITH CHECK (true);

-- User can read their own travel history
CREATE POLICY "Users can read own travel_history" ON travel_history FOR SELECT USING (true);

-- Create indexes for better performance
CREATE INDEX idx_delay_reports_bus_id ON delay_reports(bus_id);
CREATE INDEX idx_delay_reports_created_at ON delay_reports(created_at DESC);
CREATE INDEX idx_bus_ratings_bus_id ON bus_ratings(bus_id);
CREATE INDEX idx_driver_ratings_driver_id ON driver_ratings(driver_id);
CREATE INDEX idx_travel_history_user_id ON travel_history(user_id);
CREATE INDEX idx_travel_history_date ON travel_history(travel_date DESC);

-- Sample data
INSERT INTO delay_reports (bus_id, bus_name, delay_minutes, reason, location) VALUES
('1', 'Bus 42A', 15, 'Heavy traffic', 'City Center'),
('2', 'Express 18', 5, 'Road construction', 'Highway Junction');

INSERT INTO bus_ratings (bus_id, bus_name, rating, review, cleanliness_rating, comfort_rating, punctuality_rating) VALUES
('1', 'Bus 42A', 4, 'Good service, clean bus', 4, 4, 3),
('2', 'Express 18', 5, 'Excellent! Very comfortable', 5, 5, 5),
('3', 'Bus 7B', 3, 'Average service', 3, 3, 4);
