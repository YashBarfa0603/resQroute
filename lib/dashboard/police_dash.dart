import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoliceDashboard extends StatefulWidget {
  const PoliceDashboard({super.key});

  @override
  State<PoliceDashboard> createState() => _PoliceDashboardState();
}

class _PoliceDashboardState extends State<PoliceDashboard> {
  int _selectedIndex = 0;

  final pages = const [
    HomeScreen(),
    NavigationScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Navigation"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////
/// 🚓 HOME SCREEN
////////////////////////////////////////////////////////

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String status = "Available";

  bool patrol = false;
  bool crimeAlert = false;
  bool gps = true;

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),

      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Police Control",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🚓 STATUS CARD
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Unit Status"),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statusBtn("Available", Colors.green),
                      _statusBtn("Emergency", Colors.red),
                      _statusBtn("Offline", Colors.grey),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Current: $status",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// 🚓 FEATURES
            Row(
              children: [
                Expanded(
                  child: _featureToggle(
                    title: "Patrol Mode",
                    icon: Icons.local_police,
                    color: Colors.blue,
                    value: patrol,
                    onTap: () {
                      setState(() => patrol = !patrol);
                      _showSnack(patrol
                          ? "🚓 Patrol Mode Activated"
                          : "Patrol Mode Disabled");
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _featureToggle(
                    title: "Crime Alert",
                    icon: Icons.warning,
                    color: Colors.red,
                    value: crimeAlert,
                    onTap: () {
                      setState(() => crimeAlert = !crimeAlert);
                      _showSnack(crimeAlert
                          ? "🚨 Crime Alert ON"
                          : "Crime Alert OFF");
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _featureToggle(
                    title: "GPS Active",
                    icon: Icons.gps_fixed,
                    color: Colors.blueAccent,
                    value: gps,
                    onTap: () {
                      setState(() => gps = !gps);
                      _showSnack(gps
                          ? "📡 GPS Activated"
                          : "GPS Turned OFF");
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _card(
                    child: Column(
                      children: const [
                        Icon(Icons.security, color: Colors.blue),
                        SizedBox(height: 6),
                        Text("Surveillance"),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// 🚓 INFO PANEL
            _card(
              child: Column(
                children: [
                  _sectionTitle("Live Dispatch Info"),
                  const SizedBox(height: 10),

                  _infoRow("Location", "Zone 5"),
                  _infoRow("Response Time", "4 mins"),
                  _infoRow("Threat Level", "Medium"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////
  Widget _statusBtn(String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: () {
        setState(() => status = text);
      },
      child: Text(text),
    );
  }

  ////////////////////////////////////////////////////////
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: value ? color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: value ? color : Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(title),
            Text(
              value ? "ON" : "OFF",
              style: TextStyle(
                color: value ? color : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////
  Widget _infoRow(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: child,
    );
  }
}

////////////////////////////////////////////////////////
/// 🧭 NAVIGATION SCREEN
////////////////////////////////////////////////////////

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Police Navigation"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            color: Colors.grey[300],
            child: const Center(child: Text("🚓 Map Integration")),
          ),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.location_on),
            title: Text("Destination"),
            subtitle: Text("Incident Area"),
          ),
          const ListTile(
            leading: Icon(Icons.traffic),
            title: Text("Traffic"),
            subtitle: Text("Moderate"),
          ),
          const ListTile(
            leading: Icon(Icons.timer),
            title: Text("Signal Timing"),
            subtitle: Text("Next: 10 sec"),
          ),
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
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.person), title: Text("Profile")),
          ListTile(leading: Icon(Icons.notifications), title: Text("Alerts")),
          ListTile(leading: Icon(Icons.security), title: Text("Security")),
          ListTile(leading: Icon(Icons.logout), title: Text("Logout")),
        ],
      ),
    );
  }
}