import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/theme.dart';
import '../models/bus.dart';
import 'live_tracking_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchBuses(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final response = await _supabase
          .from('buses')
          .select()
          .ilike('name', '%$query%');

      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(response);
        _isSearching = false;
      });
    } catch (e) {
      print('Error searching buses: $e');
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Top App Bar
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              border: Border(
                bottom: BorderSide(color: Color(0xFF0F172A), width: 2),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.menu, color: Color(0xFF0F172A)),
                    SizedBox(width: 16),
                    Text(
                      'AAGMAN',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF0F172A), width: 2),
                      ),
                      child: Icon(Icons.person, color: Color(0xFF0F172A), size: 24),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Search Section
          Container(
            padding: EdgeInsets.all(16),
            color: AppTheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SEARCH BUSES',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textMuted,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 12),
                
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    border: Border.all(color: AppTheme.textPrimary, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.textPrimary,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _searchBuses,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'BUS NUMBER OR ROUTE',
                            hintStyle: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textMuted.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                            prefixIcon: Icon(Icons.search, color: AppTheme.primary, size: 24),
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _searchBuses('');
                          },
                          child: Container(
                            margin: EdgeInsets.all(8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.border,
                              border: Border.all(color: AppTheme.textPrimary, width: 2),
                            ),
                            child: Icon(Icons.close, color: AppTheme.textPrimary, size: 20),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: _isSearching
                ? Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primary, width: 3),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  )
                : _searchResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.border, width: 3),
                              ),
                              child: Icon(
                                _searchController.text.isEmpty ? Icons.search : Icons.search_off,
                                size: 40,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              _searchController.text.isEmpty
                                  ? 'SEARCH FOR BUSES'
                                  : 'NO BUSES FOUND',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textMuted,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final bus = _searchResults[index];
                          return _buildBusCard(bus);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusCard(Map<String, dynamic> busData) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.textPrimary, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textPrimary,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            final bus = Bus(
              id: busData['id'].toString(),
              name: busData['name'],
              type: busData['type'] ?? 'Government',
              departureTime: '10:00 AM',
              arrivalTime: '11:00 AM',
              fare: busData['fare'] ?? 50,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveTrackingScreen(bus: bus),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    border: Border.all(color: AppTheme.textPrimary, width: 3),
                  ),
                  child: Icon(
                    Icons.directions_bus,
                    color: AppTheme.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        busData['name'],
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        busData['route'] ?? 'ROUTE INFORMATION',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMuted,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: busData['type'] == 'Government'
                        ? AppTheme.primary.withOpacity(0.1)
                        : AppTheme.warning.withOpacity(0.1),
                    border: Border.all(
                      color: busData['type'] == 'Government'
                          ? AppTheme.primary
                          : AppTheme.warning,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    (busData['type'] ?? 'Government').toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: busData['type'] == 'Government'
                          ? AppTheme.primary
                          : AppTheme.warning,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
