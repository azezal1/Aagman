import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';

class TravelAnalyticsScreen extends StatefulWidget {
  final String userId;

  const TravelAnalyticsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<TravelAnalyticsScreen> createState() => _TravelAnalyticsScreenState();
}

class _TravelAnalyticsScreenState extends State<TravelAnalyticsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  
  // Analytics data
  int _totalTrips = 0;
  double _totalDistance = 0;
  double _totalSpent = 0;
  double _carbonSaved = 0;
  List<Map<String, dynamic>> _recentTrips = [];
  Map<String, int> _routeFrequency = {};

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    try {
      // Get current month's data
      final now = DateTime.now();
      final firstDayOfMonth = DateTime(now.year, now.month, 1);
      
      final response = await _supabase
          .from('travel_history')
          .select()
          .eq('user_id', widget.userId)
          .gte('travel_date', firstDayOfMonth.toIso8601String())
          .order('travel_date', ascending: false);

      if (response != null) {
        final trips = List<Map<String, dynamic>>.from(response);
        
        setState(() {
          _totalTrips = trips.length;
          _totalDistance = trips.fold(0.0, (sum, trip) => 
            sum + ((trip['duration_minutes'] ?? 0) * 0.5)); // Estimate: 30 km/h avg
          _totalSpent = trips.fold(0.0, (sum, trip) => 
            sum + (trip['fare'] ?? 0.0));
          _carbonSaved = _totalDistance * 0.12; // 120g CO2 per km saved vs car
          _recentTrips = trips.take(10).toList();
          
          // Calculate route frequency
          _routeFrequency = {};
          for (var trip in trips) {
            final route = '${trip['from_location']} → ${trip['to_location']}';
            _routeFrequency[route] = (_routeFrequency[route] ?? 0) + 1;
          }
        });
      }
    } catch (e) {
      print('Error loading analytics: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Travel Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAnalytics,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAnalytics,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primary, AppTheme.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month, color: Colors.white, size: 32),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMMM yyyy').format(DateTime.now()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Text(
                                'Monthly Travel Summary',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Stats Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.3,
                      children: [
                        _buildStatCard(
                          'Total Trips',
                          _totalTrips.toString(),
                          Icons.directions_bus,
                          AppTheme.primary,
                        ),
                        _buildStatCard(
                          'Distance',
                          '${_totalDistance.toStringAsFixed(1)} km',
                          Icons.route,
                          AppTheme.secondary,
                        ),
                        _buildStatCard(
                          'Money Spent',
                          '₹${_totalSpent.toStringAsFixed(0)}',
                          Icons.currency_rupee,
                          AppTheme.warning,
                        ),
                        _buildStatCard(
                          'CO₂ Saved',
                          '${_carbonSaved.toStringAsFixed(1)} kg',
                          Icons.eco,
                          AppTheme.success,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Most Used Routes
                    if (_routeFrequency.isNotEmpty) ...[
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: AppTheme.primary),
                          const SizedBox(width: 12),
                          Text(
                            'Most Used Routes',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...(_routeFrequency.entries.toList()
                          ..sort((a, b) => b.value.compareTo(a.value)))
                          .take(5)
                          .map((entry) => _buildRouteFrequencyCard(
                                entry.key,
                                entry.value,
                                _totalTrips,
                              ))
                          .toList(),
                      const SizedBox(height: 32),
                    ],
                    
                    // Environmental Impact
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.success,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.eco, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Environmental Impact',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'By choosing public transport',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildImpactItem(
                                  Icons.cloud_off,
                                  '${_carbonSaved.toStringAsFixed(1)} kg',
                                  'CO₂ Saved',
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: AppTheme.success.withOpacity(0.3),
                              ),
                              Expanded(
                                child: _buildImpactItem(
                                  Icons.forest,
                                  '${(_carbonSaved / 21).toStringAsFixed(1)}',
                                  'Trees Equivalent',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Recent Trips
                    Row(
                      children: [
                        const Icon(Icons.history, color: AppTheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Recent Trips',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (_recentTrips.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.directions_bus_outlined,
                                size: 64,
                                color: AppTheme.textSecondary.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No trips this month',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start traveling to see your analytics',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._recentTrips.map((trip) => _buildTripCard(trip)).toList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteFrequencyCard(String route, int count, int total) {
    final percentage = (count / total * 100).toInt();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  route,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$count trips',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count / total,
              minHeight: 8,
              backgroundColor: AppTheme.getSurfaceVariant(context),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage% of total trips',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.success, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.success,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    final date = DateTime.parse(trip['travel_date']);
    final dateStr = DateFormat('MMM dd, yyyy').format(date);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.directions_bus, color: AppTheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip['bus_name'] ?? 'Bus',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${trip['from_location']} → ${trip['to_location']}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${trip['fare']?.toStringAsFixed(0) ?? '0'}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              if (trip['duration_minutes'] != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${trip['duration_minutes']} min',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
