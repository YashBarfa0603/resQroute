import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/screens/live_navigation.dart';
import 'package:res_q_route/theme/app_themes.dart';

class DestinationSelectionPage extends StatefulWidget {
  const DestinationSelectionPage({super.key});

  @override
  State<DestinationSelectionPage> createState() => _DestinationSelectionPageState();
}

class _DestinationSelectionPageState extends State<DestinationSelectionPage>
    with TickerProviderStateMixin {
  final TextEditingController _destinationController = TextEditingController();
  String? _selectedDestination;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _quickDestinations = [
    {'name': 'AIIMS Hospital', 'distance': '1.2km', 'selected': false},
    {'name': 'RML Hospital', 'distance': '3.5km', 'selected': false},
    {'name': 'Safdarjung Hospital', 'distance': '4.1km', 'selected': false},
    {'name': 'GTB Hospital', 'distance': '8.2km', 'selected': false},
  ];

  final List<Map<String, dynamic>> _routeOptions = [
    {
      'label': 'AI OPTIMAL',
      'route': 'Ring Road → NH-8 Bypass',
      'distance': '8.2km',
      'eta': '4m 32s',
      'confidence': 94,
      'status': 'RECOMMENDED BY AI',
      'statusColor': AppThemes.primaryBlue,
      'isOptimal': true,
    },
    {
      'label': 'DIRECT',
      'route': 'NH-8 Direct',
      'distance': '6.1km',
      'eta': '12m 10s',
      'confidence': 0,
      'status': 'TRAFFIC BLOCKED',
      'statusColor': Color(0xFFBA1A1A),
      'isOptimal': false,
    },
    {
      'label': 'ALTERNATE',
      'route': 'MG Road → AIIMS Marg',
      'distance': '9.8km',
      'eta': '6m 45s',
      'confidence': 0,
      'status': 'CONSTRUCTION ZONE',
      'statusColor': Color(0xFFB46000),
      'isOptimal': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemes.policeTheme,
      child: Scaffold(
        backgroundColor: AppThemes.bgLight,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(color: AppThemes.bgLight.withOpacity(0.85)),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppThemes.textDark),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                "New Emergency Dispatch",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppThemes.textDark,
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFBA1A1A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFBA1A1A), shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text("EMERGENCY", style: GoogleFonts.manrope(color: const Color(0xFFBA1A1A), fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Location card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppThemes.radiusXl),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        children: [
                          _buildLocationRow(
                            label: "FROM",
                            color: AppThemes.primaryBlue,
                            icon: Icons.my_location_rounded,
                            text: "Current Location — Sector 12, New Delhi",
                            isAuto: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                const SizedBox(width: 44),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        AppThemes.primaryBlue.withOpacity(0.0),
                                        AppThemes.primaryBlue.withOpacity(0.15),
                                        AppThemes.primaryBlue.withOpacity(0.0),
                                      ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildDestinationField(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      "QUICK DESTINATIONS",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, fontWeight: FontWeight.w800,
                        color: AppThemes.textMuted, letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _quickDestinations.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, i) => _buildDestinationChip(_quickDestinations[i]),
                      ),
                    ),
                    if (_selectedDestination != null) ...[
                      const SizedBox(height: 32),
                      _buildRouteAnalysis(),
                    ],
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomSheet: _buildBottomCTA(),
      ),
    );
  }

  Widget _buildLocationRow({
    required String label, required Color color, required IconData icon,
    required String text, bool isAuto = false,
  }) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: color, letterSpacing: 1.5)),
              const SizedBox(height: 2),
              Text(text, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppThemes.textDark)),
            ],
          ),
        ),
        if (isAuto)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text("AUTO", style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.green.shade700, letterSpacing: 1)),
          ),
      ],
    );
  }

  Widget _buildDestinationField() {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: const Color(0xFFBA1A1A).withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.place_rounded, color: Color(0xFFBA1A1A), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("TO", style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: const Color(0xFFBA1A1A), letterSpacing: 1.5)),
              const SizedBox(height: 4),
              TextField(
                controller: _destinationController,
                style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppThemes.textDark),
                decoration: InputDecoration(
                  hintText: "Search destination...",
                  hintStyle: TextStyle(color: AppThemes.textMuted.withOpacity(0.4), fontSize: 14),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationChip(Map<String, dynamic> dest) {
    final bool isSelected = _selectedDestination == dest['name'];
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedDestination = dest['name'];
          _destinationController.text = dest['name'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppThemes.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(AppThemes.radiusLg),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Icon(Icons.local_hospital_rounded, size: 16, color: isSelected ? Colors.white : AppThemes.primaryBlue),
            const SizedBox(width: 8),
            Text(dest['name'], style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppThemes.textDark)),
            const SizedBox(width: 6),
            Text(dest['distance'], style: GoogleFonts.manrope(fontSize: 11, color: isSelected ? Colors.white.withOpacity(0.7) : AppThemes.textMuted)),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "ROUTE ANALYSIS",
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: AppThemes.textMuted, letterSpacing: 2),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppThemes.primaryBlue.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Icon(Icons.psychology_rounded, size: 12, color: AppThemes.primaryBlue),
                  const SizedBox(width: 4),
                  Text("AI ANALYZING", style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: AppThemes.primaryBlue)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppThemes.radiusXl),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Route Analysis — ${_selectedDestination ?? 'AIIMS Hospital'}",
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: AppThemes.textDark),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._routeOptions.map((r) => _buildRouteOption(r)).toList(),
              const SizedBox(height: 20),
              _buildMLConfidenceBar(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRouteOption(Map<String, dynamic> route) {
    final isOptimal = route['isOptimal'] as bool;
    final statusColor = route['statusColor'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isOptimal ? AppThemes.primaryBlue.withOpacity(0.04) : AppThemes.bgLight,
        borderRadius: BorderRadius.circular(AppThemes.radiusLg),
        border: isOptimal ? Border.all(color: AppThemes.primaryBlue.withOpacity(0.15), width: 1.5) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isOptimal) ...[
                Icon(Icons.auto_awesome_rounded, color: AppThemes.primaryBlue, size: 14),
                const SizedBox(width: 6),
              ],
              Text(route['route'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: AppThemes.textDark)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(route['status'], style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w800, color: statusColor, letterSpacing: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _routeStat(Icons.straighten_rounded, route['distance']),
              const SizedBox(width: 16),
              _routeStat(Icons.schedule_rounded, route['eta']),
              if (isOptimal) ...[
                const SizedBox(width: 16),
                _routeStat(Icons.verified_rounded, "${route['confidence']}% confidence", color: Colors.green.shade600),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _routeStat(IconData icon, String text, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color ?? AppThemes.textMuted),
        const SizedBox(width: 4),
        Text(text, style: GoogleFonts.manrope(fontSize: 12, color: color ?? AppThemes.textMuted, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildMLConfidenceBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppThemes.bgLight, borderRadius: BorderRadius.circular(AppThemes.radiusLg)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lan_rounded, size: 14, color: AppThemes.primaryBlue),
              const SizedBox(width: 8),
              Text("Random Forest ML Model", style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppThemes.textDark)),
              const Spacer(),
              Text("94% accuracy", style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.green.shade600)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.94,
              backgroundColor: AppThemes.primaryBlue.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppThemes.primaryBlue),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Input factors: Distance • Traffic Density • Weather • Road Blockage",
            style: GoogleFonts.manrope(fontSize: 11, color: AppThemes.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _selectedDestination == null ? null : () {
            HapticFeedback.mediumImpact();
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveNavigationPage()));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemes.radiusXl)),
            backgroundColor: _selectedDestination == null ? AppThemes.bgLight : null,
            foregroundColor: Colors.white,
            elevation: 0,
          ).copyWith(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) return AppThemes.bgLight;
              return null;
            }),
          ),
          child: Ink(
            decoration: _selectedDestination == null ? null : BoxDecoration(
              gradient: LinearGradient(colors: [AppThemes.primaryBlue, const Color(0xFF1E3A8A)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(AppThemes.radiusXl),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                _selectedDestination == null ? "SELECT DESTINATION FIRST" : "BEGIN NAVIGATION",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1,
                  color: _selectedDestination == null ? AppThemes.textMuted : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
