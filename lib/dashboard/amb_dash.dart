import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        decoration: const BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.grey,
          onTap: (i) => setState(() => _selectedIndex = i),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Navigation"),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Score"),
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

class _HomeScreenState extends State<HomeScreen> {
  String status = "Available";
  bool backup = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),

      appBar: AppBar(
        elevation: 0,
        title: Text("Ambulance AI Control",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.red],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🚑 STATUS GLASS CARD
            _glassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Live Status"),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _chip("Available", Colors.green),
                      _chip("Emergency", Colors.red),
                      _chip("Offline", Colors.grey),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.circle, size: 10, color: Colors.green),
                      const SizedBox(width: 6),
                      Text("Currently: $status",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600))
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// ⚡ FEATURE GRID
            Row(
              children: [
                Expanded(child: _feature(Icons.gps_fixed, "GPS Active")),
                const SizedBox(width: 10),
                Expanded(child: _feature(Icons.priority_high, "Priority AI")),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: _feature(Icons.warning, "Accident AI")),
                const SizedBox(width: 10),
                Expanded(child: _backupCard()),
              ],
            ),

            const SizedBox(height: 15),

            /// 📊 LIVE DATA PANEL
            _glassCard(
              child: Column(
                children: [
                  _title("Live Dispatch"),

                  const SizedBox(height: 10),

                  _info("📍 Location", "Indore - Vijay Nagar"),
                  _info("⏱ ETA", "5 mins"),
                  _info("🚦 Traffic", "Moderate"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return GestureDetector(
      onTap: () => setState(() => status = text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(text,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _feature(IconData icon, String text) {
    return _glassCard(
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.redAccent),
          const SizedBox(height: 6),
          Text(text, style: GoogleFonts.poppins(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _backupCard() {
    return _glassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Backup Mode", style: GoogleFonts.poppins(fontSize: 13)),
          Switch(value: backup, onChanged: (v) => setState(() => backup = v)),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _title(String text) {
    return Text(text,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold));
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
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
      backgroundColor: const Color(0xFFF2F5FA),

      appBar: AppBar(
        title: const Text("Driver Performance"),
        backgroundColor: Colors.redAccent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔵 CIRCULAR SCORE
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.redAccent, Colors.red],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text("Driving Score",
                      style: TextStyle(color: Colors.white)),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 0.85,
                          strokeWidth: 10,
                          color: Colors.white,
                          backgroundColor: Colors.white24,
                        ),
                        const Text("85",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🏆 LEADERBOARD
            Expanded(
              child: ListView(
                children: [
                  _leader("1", "Driver A", "95"),
                  _leader("2", "Driver B", "90"),
                  _leader("3", "You", "85"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leader(String rank, String name, String score) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(child: Text(rank)),
        title: Text(name),
        trailing: Text(score),
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// 🧭 NAVIGATION (same structure upgraded)
////////////////////////////////////////////////////////

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Live Navigation"), backgroundColor: Colors.redAccent),

      body: Column(
        children: [
          Container(
            height: 280,
            color: Colors.grey[300],
            child: const Center(child: Text("🚀 Google Maps Here")),
          ),
          const ListTile(title: Text("Traffic: Moderate")),
          const ListTile(title: Text("Signal: 18 sec")),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// ⚙ SETTINGS
////////////////////////////////////////////////////////

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Settings"), backgroundColor: Colors.redAccent),
      body: const ListTile(title: Text("Logout")),
    );
  }
}