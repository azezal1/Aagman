import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/bus.dart';
import 'live_tracking_screen.dart';
import 'route_details_screen.dart';

class BusSearchResultsScreen extends StatefulWidget {
  final String from;
  final String to;

  const BusSearchResultsScreen({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  State<BusSearchResultsScreen> createState() => _BusSearchResultsScreenState();
}

class _BusSearchResultsScreenState extends State<BusSearchResultsScreen> {
  String _filterType = 'All';
  String _sortBy = 'None';

  List<Bus> _getFilteredBuses() {
    // Sample data - replace with Supabase query
    List<Bus> buses = [
      Bus(
        id: '1',
        name: 'Bus 42A',
        type: 'Government',
        departureTime: '08:30 AM',
        arrivalTime: '09:45 AM',
        fare: 25,
      ),
      Bus(
        id: '2',
        name: 'Express 18',
        type: 'Private',
        departureTime: '09:00 AM',
        arrivalTime: '10:00 AM',
        fare: 45,
      ),
      Bus(
        id: '3',
        name: 'Bus 7B',
        type: 'Government',
        departureTime: '09:30 AM',
        arrivalTime: '11:00 AM',
        fare: 20,
      ),
    ];

    // Apply filter
    if (_filterType != 'All') {
      buses = buses.where((bus) => bus.type == _filterType).toList();
    }

    // Apply sort
    if (_sortBy == 'Low to High') {
      buses.sort((a, b) => a.fare.compareTo(b.fare));
    } else if (_sortBy == 'High to Low') {
      buses.sort((a, b) => b.fare.compareTo(a.fare));
    }

    return buses;
  }

  @override
  Widget build(BuildContext context) {
    final buses = _getFilteredBuses();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.from} → ${widget.to}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${buses.length} buses available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filter and Sort Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              border: Border(
                bottom: BorderSide(color: AppTheme.border, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(child: _buildFilterChip('All')),
                const SizedBox(width: 8),
                Expanded(child: _buildFilterChip('Government')),
                const SizedBox(width: 8),
                Expanded(child: _buildFilterChip('Private')),
                const SizedBox(width: 16),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort, color: AppTheme.textPrimary),
                  onSelected: (value) {
                    setState(() {
                      _sortBy = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'None', child: Text('No Sort')),
                    const PopupMenuItem(value: 'Low to High', child: Text('Price: Low to High')),
                    const PopupMenuItem(value: 'High to Low', child: Text('Price: High to Low')),
                  ],
                ),
              ],
            ),
          ),

          // Bus List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: buses.length,
              itemBuilder: (context, index) {
                return _buildBusCard(buses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _filterType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accent.withOpacity(0.1) : AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.accent : AppTheme.border,
            width: isSelected ? 1.5 : 0.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppTheme.accent : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildBusCard(Bus bus) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: AppTheme.accent,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bus.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: bus.type == 'Government'
                            ? AppTheme.info.withOpacity(0.1)
                            : AppTheme.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        bus.type,
                        style: TextStyle(
                          fontSize: 11,
                          color: bus.type == 'Government'
                              ? AppTheme.info
                              : AppTheme.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₹${bus.fare}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Departure',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bus.departureTime,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, color: AppTheme.textSecondary, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Arrival',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bus.arrivalTime,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RouteDetailsScreen(bus: bus),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('View Route'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveTrackingScreen(bus: bus),
                      ),
                    );
                  },
                  child: const Text('Track Live'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
