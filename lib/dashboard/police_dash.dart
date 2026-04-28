import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:res_q_route/services/hive_service.dart';
import 'package:res_q_route/theme/app_themes.dart';
import 'package:res_q_route/screens/ai_route_intelligence.dart';
import 'package:res_q_route/screens/alert_center.dart';
import 'package:res_q_route/screens/dispatch_communications.dart';
import 'package:res_q_route/screens/destination_selection.dart';
import 'package:res_q_route/screens/live_navigation.dart';

// Tokens
const _kBg = Color(0xFFEEF0F8);
const _kNavy = Color(0xFF1A1F6E);
const _kNavyLight = Color(0xFF2D3480);
const _kRed = Color(0xFFD32F2F);
const _kCardBg = Colors.white;
const _kMuted = Color(0xFF6B728A);

class PoliceDashboard extends StatefulWidget {
  const PoliceDashboard({super.key});
  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

class _PoliceDashboardState extends State<PoliceDashboard> {
  int _selectedIndex = 3; // STATUS tab is home

  final _pages = const [
    _DispatchTab(),
    _MapTab(),
    _CommsTab(),
    HomeScreen(),
    _DirectoryTab(),
  ];

  static const _navItems = [
    (icon: Icons.hub_rounded, label: 'DISPATCH'),
    (icon: Icons.map_rounded, label: 'MAP'),
    (icon: Icons.chat_bubble_rounded, label: 'COMMS'),
    (icon: Icons.access_time_rounded, label: 'STATUS'),
    (icon: Icons.shield_rounded, label: 'DIRECTORY'),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemes.policeTheme,
      child: Scaffold(
        backgroundColor: _kBg,
        extendBody: true,
        body: _pages[_selectedIndex],
        bottomNavigationBar: _buildNavBar(),
      ),
    );
  }

  Widget _buildNavBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF5F6FC),
            border: Border(top: BorderSide(color: Color(0xFFE2E5F0), width: 0.8)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Row(
                children: List.generate(_navItems.length, (i) {
                  final item = _navItems[i];
                  final isActive = _selectedIndex == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedIndex = i);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? _kNavy : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(item.icon, size: 19,
                              color: isActive ? Colors.white : _kMuted),
                            const SizedBox(height: 3),
                            Text(item.label,
                              style: GoogleFonts.manrope(
                                fontSize: 8.5,
                                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                                color: isActive ? Colors.white : _kMuted,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Tabs
class _DispatchTab extends StatelessWidget {
  const _DispatchTab();
  @override
  Widget build(BuildContext context) => const DestinationSelectionPage();
}

class _CommsTab extends StatelessWidget {
  const _CommsTab();
  @override
  Widget build(BuildContext context) => const DispatchCommunicationsPage();
}

class _MapTab extends StatelessWidget {
  const _MapTab();
  @override
  Widget build(BuildContext context) => const LiveNavigationPage();
}

class _DirectoryTab extends StatelessWidget {
  const _DirectoryTab();
  @override
  Widget build(BuildContext context) => const SettingsScreen();
}

// Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _status = 'AVAILABLE';
  bool _isEmergency = false;
  late AnimationController _ringController;

  final _incidents = const [
    _Incident('10–31 Dispatch – Downtown', 'Officers requested for backup at Broadway Junction.', '2m ago', _kRed, true),
    _Incident('Suspect Sighted – East Park', 'Matching description of APB case #4252.', '14m ago', _kNavy, false),
    _Incident('Vehicle Check – 5th Ave', 'Routine stop completed. No findings.', '32m ago', Color(0xFFCBD5E1), false),
  ];

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _ringController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driver = HiveService.getCurrentDriver();
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              _buildHeader(driver),
              _buildStatusCircle(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResponseTimeCard(),
                    const SizedBox(height: 16),
                    _buildActionGrid(),
                    const SizedBox(height: 24),
                    _buildLiveIncidents(),
                    const SizedBox(height: 32),
                    _buildSOSButton(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader(driver) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: _kNavy,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.local_police_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ResQRoute',
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 17, color: _kNavy),
                ),
                Text(
                  'UNIT ${driver?.vehicleNumber ?? "402"} · SECTOR B',
                  style: GoogleFonts.manrope(fontSize: 11, color: _kMuted, fontWeight: FontWeight.w600, letterSpacing: 0.3),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: _kNavy, size: 24),
            onPressed: () => HapticFeedback.lightImpact(),
          ),
        ],
      ),
    );
  }

  void _showStatusPicker() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text("SET VEHICLE AVAILABILITY", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1.5, color: _kMuted)),
            const SizedBox(height: 24),
            _statusOption("AVAILABLE", "Ready for deployment", Icons.check_circle_rounded, Colors.green),
            _statusOption("ON MISSION", "Active emergency response", Icons.emergency_rounded, _kNavy),
            _statusOption("BUSY", "Temporary unavailable", Icons.access_time_filled_rounded, Colors.orange),
            _statusOption("OFF DUTY", "Unit not in service", Icons.power_settings_new_rounded, Colors.grey),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statusOption(String label, String sub, IconData icon, Color color) {
    final isSelected = _status == label;
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _status = label);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? color.withOpacity(0.2) : Colors.transparent),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, color: isSelected ? color : _kNavy)),
                  Text(sub, style: GoogleFonts.manrope(fontSize: 11, color: _kMuted)),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  // Status
  Widget _buildStatusCircle() {
    Color statusColor;
    switch (_status) {
      case 'AVAILABLE': statusColor = Colors.green; break;
      case 'ON MISSION': statusColor = _kNavy; break;
      case 'BUSY': statusColor = Colors.orange; break;
      default: statusColor = Colors.grey;
    }

    return GestureDetector(
      onTap: _showStatusPicker,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: SizedBox(
          width: 220, height: 220,
          child: CustomPaint(
            painter: _RingPainter(_ringController, statusColor),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CURRENT STATUS',
                    style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w700, color: _kMuted, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _status,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: _kNavy,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _ringController,
                        builder: (_, __) => Container(
                          width: 7, height: 7,
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.6 + 0.4 * _ringController.value),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text('Live Syncing...', style: GoogleFonts.manrope(fontSize: 11, color: _kMuted, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Performance
  Widget _buildResponseTimeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Response Time', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15, color: _kNavy)),
                const SizedBox(height: 4),
                Text('Your shift average performance vs. regional benchmark', style: GoogleFonts.manrope(fontSize: 12, color: _kMuted, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 64, height: 64,
            child: CustomPaint(
              painter: _ArcPainter(0.72, _kNavy),
              child: Center(
                child: Text('4m 12s', style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w800, color: _kNavy)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  Widget _buildActionGrid() {
    final actions = [
      (icon: Icons.shield_outlined, title: 'Patrol Mode', sub: 'DE-ESCALATION', color: _kNavy, nav: null as VoidCallback?),
      (icon: Icons.notifications_outlined, title: 'Crime Alert', sub: 'PRIORITY RED', color: _kRed, nav: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlertCenterPage()))),
      (icon: Icons.near_me_outlined, title: 'GPS Tracking', sub: 'UNIT: EN ROUTE', color: _kNavy, nav: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIRouteIntelligencePage()))),
      (icon: Icons.map_outlined, title: 'Resource Map', sub: 'CIVILIAN GRID', color: _kNavy, nav: null),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.18,
      children: actions.map((a) => _actionCard(a.icon, a.title, a.sub, a.color, a.nav)).toList(),
    );
  }

  Widget _actionCard(IconData icon, String title, String sub, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: () { HapticFeedback.lightImpact(); onTap?.call(); },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _kCardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Spacer(),
            Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13, color: _kNavy)),
            const SizedBox(height: 2),
            Text(sub, style: GoogleFonts.manrope(fontSize: 10, color: _kMuted, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
          ],
        ),
      ),
    );
  }

  // Incidents
  Widget _buildLiveIncidents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Live Incidents', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: _kNavy)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _kRed.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
              child: Text('3 CRITICAL', style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: _kRed, letterSpacing: 0.5)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ..._incidents.map(_buildIncidentTile),
      ],
    );
  }

  Widget _buildIncidentTile(_Incident inc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _kCardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 4, height: 72,
            decoration: BoxDecoration(
              color: inc.accentColor,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(inc.title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13, color: _kNavy))),
                      Text(inc.time, style: GoogleFonts.manrope(fontSize: 10, color: _kRed, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(inc.subtitle, style: GoogleFonts.manrope(fontSize: 11, color: _kMuted, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Emergency
  Widget _buildSOSButton() {
    return Column(
      children: [
        GestureDetector(
          onLongPress: () {
            HapticFeedback.heavyImpact();
            setState(() => _isEmergency = !_isEmergency);
          },
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: _kRed,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: _kRed.withOpacity(0.35), blurRadius: 24, spreadRadius: 4)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, color: Colors.white, size: 28),
                Text('SOS', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('HOLD TO BROADCAST EMERGENCY', style: GoogleFonts.manrope(fontSize: 10, color: _kMuted, fontWeight: FontWeight.w600, letterSpacing: 0.8)),
      ],
    );
  }
}

// Model
class _Incident {
  final String title, subtitle, time;
  final Color accentColor;
  final bool isCritical;
  const _Incident(this.title, this.subtitle, this.time, this.accentColor, this.isCritical);
}

// Painters
class _RingPainter extends CustomPainter {
  final Animation<double> anim;
  final Color statusColor;
  _RingPainter(this.anim, this.statusColor) : super(repaint: anim);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    // Outer ring
    canvas.drawCircle(center, radius, Paint()
      ..color = const Color(0xFFDDE0F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6);
    // Animated arc
    final sweepAngle = 2 * pi * 0.72;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + anim.value * 2 * pi,
      sweepAngle * 0.15,
      false,
      Paint()
        ..color = statusColor.withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_) => true;
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  const _ArcPainter(this.progress, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    canvas.drawCircle(center, radius, Paint()
      ..color = const Color(0xFFDDE0F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// Map
class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  static const _indore = LatLng(22.7196, 75.8577);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: const MapOptions(initialCenter: _indore, initialZoom: 14),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.resqroute.app'),
              MarkerLayer(markers: [
                Marker(
                  point: _indore, width: 56, height: 56,
                  child: Container(
                    decoration: BoxDecoration(color: _kNavy.withOpacity(0.12), shape: BoxShape.circle, border: Border.all(color: _kNavy, width: 2)),
                    child: const Center(child: Icon(Icons.local_police_rounded, color: _kNavy, size: 28)),
                  ),
                ),
              ]),
            ],
          ),
          Positioned(
            top: 60, left: 20, right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  color: Colors.white.withOpacity(0.85),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: _kNavy),
                      const SizedBox(width: 12),
                      Text('SEARCH DISPATCH ZONE...', style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 12, color: _kMuted)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        title: Text('UNIT DIRECTORY', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 1.5, color: _kNavy)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _settingsGroup('COMMANDER PROFILE', [
            _settingsTile(Icons.person_outline_rounded, 'Credentials', 'Unit identity & auth'),
            _settingsTile(Icons.notifications_none_rounded, 'Alert Config', 'Dispatch priority signals'),
          ]),
          const SizedBox(height: 24),
          _settingsGroup('SYSTEM CONFIG', [
            _settingsTile(Icons.security_rounded, 'Protocol Encryption', 'End-to-end mission data'),
            _settingsTile(Icons.language_rounded, 'Language', 'English (Command)'),
          ]),
          const SizedBox(height: 24),
          _settingsTile(Icons.logout_rounded, 'DE-AUTHORIZE UNIT', 'Terminate current session', isDestructive: true),
        ],
      ),
    );
  }

  Widget _settingsGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: _kMuted, letterSpacing: 1.5)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, {bool isDestructive = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: (isDestructive ? _kRed : _kNavy).withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isDestructive ? _kRed : _kNavy, size: 20),
      ),
      title: Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13, color: isDestructive ? _kRed : _kNavy)),
      subtitle: Text(subtitle, style: GoogleFonts.manrope(fontSize: 11, color: _kMuted)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Color(0xFFCBD5E1)),
    );
  }
}
