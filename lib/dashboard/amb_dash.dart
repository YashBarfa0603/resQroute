import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AmbulanceDashboard extends StatefulWidget {
  const AmbulanceDashboard({super.key});

  @override
  State<AmbulanceDashboard> createState() => _AmbulanceDashboardState();
}

class _AmbulanceDashboardState extends State<AmbulanceDashboard> {
  int _selectedIndex = 0;

  final pages = const [
    HomeScreen(),
    NavigationScreen(),
    SettingsScreen(),
    GamificationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey.shade400,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
          onTap: (i) => setState(() => _selectedIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: "Navigation"),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: "Settings"),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events_rounded), label: "Score"),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// 🔴 HOME SCREEN (PREMIUM UI)
////////////////////////////////////////////////////////

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String status = "Available";
  bool backup = false;
  bool gpsActive = true;
  bool priorityAI = true;
  bool accidentAI = false;

  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color get _statusColor {
    switch (status) {
      case "Available":
        return Colors.green;
      case "Emergency":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F9),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _statusColor,
                    boxShadow: [
                      BoxShadow(
                        color: _statusColor.withOpacity(0.4 + _pulseController.value * 0.4),
                        blurRadius: 6 + _pulseController.value * 6,
                        spreadRadius: _pulseController.value * 3,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Text("Ambulance AI Control",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white)),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFFF5252)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🚑 STATUS CARD
            _glassCard(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.red.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle("Live Status"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _statusColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 8, color: _statusColor),
                            const SizedBox(width: 6),
                            Text(status,
                                style: GoogleFonts.poppins(
                                    fontSize: 12, fontWeight: FontWeight.w600, color: _statusColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _statusChip("Available", Colors.green),
                      const SizedBox(width: 8),
                      _statusChip("Emergency", Colors.red),
                      const SizedBox(width: 8),
                      _statusChip("Offline", Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            /// ⚡ QUICK ACTIONS
            _sectionTitle("Quick Actions"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _quickActionButton(
                    icon: Icons.sos_rounded,
                    label: "SOS Alert",
                    color: Colors.red,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("🚨 SOS Alert Sent!"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _quickActionButton(
                    icon: Icons.route_rounded,
                    label: "Optimize Route",
                    color: Colors.deepOrange,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("🛣 Route Optimization Started"),
                          backgroundColor: Colors.deepOrange,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// 🛡 FEATURE GRID
            _sectionTitle("System Controls"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _featureToggle(
                    title: "GPS Active",
                    icon: Icons.gps_fixed_rounded,
                    color: Colors.blue,
                    value: gpsActive,
                    onTap: () => setState(() => gpsActive = !gpsActive),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _featureToggle(
                    title: "Priority AI",
                    icon: Icons.priority_high_rounded,
                    color: Colors.orange,
                    value: priorityAI,
                    onTap: () => setState(() => priorityAI = !priorityAI),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _featureToggle(
                    title: "Accident AI",
                    icon: Icons.warning_rounded,
                    color: Colors.amber.shade700,
                    value: accidentAI,
                    onTap: () => setState(() => accidentAI = !accidentAI),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: _backupCard()),
              ],
            ),
            const SizedBox(height: 16),

            /// 📊 LIVE DATA PANEL
            _glassCard(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.red.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Live Dispatch"),
                  const SizedBox(height: 12),
                  _infoRow(Icons.location_on_rounded, "Location", "Indore - Vijay Nagar", Colors.red),
                  const Divider(height: 8),
                  _infoRow(Icons.timer_rounded, "ETA", "5 mins", Colors.blue),
                  const Divider(height: 8),
                  _infoRow(Icons.traffic_rounded, "Traffic", "Moderate", Colors.orange),
                  const Divider(height: 8),
                  _infoRow(Icons.local_hospital_rounded, "Hospital", "MY Hospital", Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String text, Color color) {
    final isSelected = status == text;
    return GestureDetector(
      onTap: () => setState(() => status = text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: isSelected ? color : color.withOpacity(0.3), width: 1.5),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 5)),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 6),
              Text(label, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureToggle({
    required String title,
    required IconData icon,
    required Color color,
    required bool value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: value ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: value ? color : Colors.grey.shade200, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: value ? color.withOpacity(0.15) : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(value ? 0.2 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(
              value ? "ON" : "OFF",
              style: GoogleFonts.poppins(
                color: value ? color : Colors.grey,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backupCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backup ? Colors.redAccent.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: backup ? Colors.redAccent : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: backup ? Colors.redAccent.withOpacity(0.15) : Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(backup ? 0.2 : 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.backup_rounded, color: Colors.redAccent, size: 22),
          ),
          const SizedBox(height: 6),
          Text("Backup", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
          Switch(
            value: backup,
            onChanged: (v) => setState(() => backup = v),
            activeColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600)),
          ),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey.shade800));
  }

  Widget _glassCard({required Widget child, Gradient? gradient}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? Colors.white : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

////////////////////////////////////////////////////////
/// 🏆 GAMIFICATION (UPGRADED)
////////////////////////////////////////////////////////

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F9),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Driver Performance",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFFF5252)],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔵 CIRCULAR SCORE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE53935), Color(0xFFFF8A80)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text("Driving Score",
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 140,
                          width: 140,
                          child: CircularProgressIndicator(
                            value: 0.85,
                            strokeWidth: 12,
                            color: Colors.white,
                            backgroundColor: Colors.white24,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("85",
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700)),
                            Text("/ 100",
                                style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _scoreStat("Speed", "92%", Icons.speed_rounded),
                      _scoreStat("Safety", "88%", Icons.shield_rounded),
                      _scoreStat("Response", "78%", Icons.timer_rounded),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// 🏆 LEADERBOARD
            Row(
              children: [
                Text("Leaderboard",
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                const Spacer(),
                Text("This Week", style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _leaderCard("1", "Driver A", "95", const Color(0xFFFFD700)),
                  _leaderCard("2", "Driver B", "90", const Color(0xFFC0C0C0)),
                  _leaderCard("3", "You", "85", const Color(0xFFCD7F32)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
        Text(label, style: GoogleFonts.poppins(color: Colors.white60, fontSize: 11)),
      ],
    );
  }

  Widget _leaderCard(String rank, String name, String score, Color medalColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: medalColor.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: medalColor, width: 2),
            ),
            child: Center(
              child: Text(rank,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: medalColor, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(score,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.redAccent, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// 🧭 NAVIGATION WITH GOOGLE MAPS
////////////////////////////////////////////////////////

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late GoogleMapController _mapController;

  static const LatLng _indore = LatLng(22.7196, 75.8577);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Live Navigation",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFFF5252)],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          /// 🗺 GOOGLE MAP
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _indore,
                  zoom: 14,
                ),
                onMapCreated: (controller) => _mapController = controller,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: {
                  const Marker(
                    markerId: MarkerId('ambulance'),
                    position: _indore,
                    infoWindow: InfoWindow(title: 'Ambulance Location'),
                  ),
                },
              ),
            ),
          ),

          /// 📋 INFO CARDS
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _navInfoCard(Icons.location_on_rounded, "Destination", "Vijay Nagar, Indore", Colors.red),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _navStatCard(Icons.traffic_rounded, "Traffic", "Moderate", Colors.orange),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _navStatCard(Icons.timer_rounded, "Signal", "18 sec", Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("🚀 Navigation Started!"), backgroundColor: Colors.redAccent),
          );
        },
        backgroundColor: Colors.redAccent,
        icon: const Icon(Icons.navigation_rounded),
        label: Text("Start", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _navInfoCard(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
              Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navStatCard(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// ⚙ SETTINGS (ENHANCED)
////////////////////////////////////////////////////////

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F9),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE53935), Color(0xFFFF5252)],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          /// Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE53935), Color(0xFFFF8A80)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person_rounded, size: 32, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ambulance Driver",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                    Text("Unit #AMB-042",
                        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _settingsTile(Icons.person_outline_rounded, "Profile", "Edit your profile details"),
          _settingsTile(Icons.notifications_outlined, "Notifications", "Manage alert preferences"),
          _settingsTile(Icons.security_rounded, "Security", "Password & authentication"),
          _settingsTile(Icons.language_rounded, "Language", "English"),
          _settingsTile(Icons.help_outline_rounded, "Help & Support", "FAQs, contact us"),
          const SizedBox(height: 10),
          _settingsTile(Icons.logout_rounded, "Logout", "Sign out of your account", isDestructive: true),
        ],
      ),
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : Colors.redAccent.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: isDestructive ? Colors.red : Colors.redAccent, size: 22),
        ),
        title: Text(title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: isDestructive ? Colors.red : Colors.black87)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
        trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
      ),
    );
  }
}