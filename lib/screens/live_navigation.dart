import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:res_q_route/theme/app_themes.dart';

class LiveNavigationPage extends StatefulWidget {
  const LiveNavigationPage({super.key});

  @override
  State<LiveNavigationPage> createState() => _LiveNavigationPageState();
}

class _LiveNavigationPageState extends State<LiveNavigationPage> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  final MapController _mapController = MapController();

  static const _indore = LatLng(22.7196, 75.8577);
  
  final List<LatLng> _routePoints = [
    LatLng(22.7196, 75.8577),
    LatLng(22.7220, 75.8620),
    LatLng(22.7250, 75.8680),
    LatLng(22.7300, 75.8750),
    LatLng(22.7350, 75.8800),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Map Layer ──────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _indore,
              initialZoom: 15,
              interactionOptions: InteractionOptions(flags: InteractiveFlag.all),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.resqroute.app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    strokeWidth: 5,
                    color: AppThemes.primaryBlue,
                    borderStrokeWidth: 2,
                    borderColor: Colors.white,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _indore,
                    width: 40, height: 40,
                    child: _buildPulsingDot(),
                  ),
                  Marker(
                    point: _routePoints.last,
                    width: 44, height: 44,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 12)],
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.emergency_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Glassy HUD ─────────────────────────────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.05))),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("LIVE TACTICAL ROUTE", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: AppThemes.textDark, letterSpacing: 0.5)),
                            Text("Indore Sector 4 • ETA 4m 32s", style: GoogleFonts.manrope(fontSize: 10, color: AppThemes.textMuted, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: Text("ACTIVE SYNC", style: GoogleFonts.manrope(color: Colors.green.shade700, fontWeight: FontWeight.w800, fontSize: 9)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom Navigation Card ─────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppThemes.radiusXl),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 40, offset: const Offset(0, 10))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(color: AppThemes.primaryBlue, borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.turn_right_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Turn Right in 250m", style: GoogleFonts.manrope(fontSize: 12, color: AppThemes.textMuted, fontWeight: FontWeight.w600)),
                            Text("AB Road Junction", style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w800, color: AppThemes.textDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _stat("850m", "DIST"),
                      _stat("42 km/h", "SPEED"),
                      _stat("04:12", "ETA"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text("CANCEL MISSION", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13, letterSpacing: 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String val, String label) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w900, color: AppThemes.textDark)),
        Text(label, style: GoogleFonts.manrope(fontSize: 9, color: AppThemes.textMuted, fontWeight: FontWeight.w800, letterSpacing: 1)),
      ],
    );
  }

  Widget _buildPulsingDot() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40 * _pulseController.value,
              height: 40 * _pulseController.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppThemes.primaryBlue.withOpacity(0.3 * (1 - _pulseController.value)),
              ),
            ),
            Container(
              width: 14, height: 14,
              decoration: BoxDecoration(color: AppThemes.primaryBlue, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5)),
            ),
          ],
        );
      },
    );
  }
}
