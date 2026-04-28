import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/auth/ambulance.dart';
import 'package:res_q_route/auth/fire_brigade.dart';
import 'package:res_q_route/auth/police.dart';

import 'package:res_q_route/auth/login/amb_signin.dart';
import 'package:res_q_route/auth/login/fire_signin.dart';
import 'package:res_q_route/auth/login/police_signin.dart';

// ─── COLORS ───────────────────────────────────────
const _bg = Color(0xFFF7F6F3);
const _ink = Color(0xFF1A1A1A);
const _muted = Color(0xFF999792);
const _border = Color(0xFFE0DDD5);
const _white = Colors.white;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _services = [
    _Service(
      title: 'Ambulance',
      subtitle: 'Medical emergency',
      icon: Icons.local_hospital,
      accent: Color(0xFFD63031),
      tint: Color(0xFFFBEAEA),
      page: AmbulanceSignInPage(),
    ),
    _Service(
      title: 'Fire Brigade',
      subtitle: 'Fire & rescue',
      icon: Icons.local_fire_department,
      accent: Color(0xFFF57C00),
      tint: Color(0xFFFFF3E0),
      page: FireSignInPage(),
 
    ),
    _Service(
      title: 'Police',
      subtitle: 'Law enforcement',
      icon: Icons.local_police,
      accent: Color(0xFF1565C0),
      tint: Color(0xFFE3F2FD),
      page: PoliceSignInPage(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _go(BuildContext context, Widget page) {
    HapticFeedback.lightImpact();
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔥 GRADIENT BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F6F3), Color(0xFFEDEBE6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // 🔴 TOP BAR
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RESQROUTE',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _muted,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            'Command Center',
                            style: GoogleFonts.inter(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: _ink,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔥 Animated Status Dot
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, __) {
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withOpacity(
                              0.6 + (_controller.value * 0.4),
                            ),
                          ),
                          child: const Icon(
                            Icons.power,
                            color: Colors.white,
                            size: 18,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔥 LIVE STATUS
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.green, size: 10),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'All emergency units active · Real-time monitoring enabled',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "SELECT SERVICE",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    letterSpacing: 1.5,
                    color: _muted,
                  ),
                ),

                const SizedBox(height: 15),

                // 🔥 SERVICES
                ..._services.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ServiceCard(
                      service: s,
                      onTap: () => _go(context, s.page),
                    ),
                  ),
                ),

                const Spacer(),

                Center(
                  child: Text(
                    "AI Powered Emergency Routing System",
                    style: GoogleFonts.inter(fontSize: 11, color: _border),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── SERVICE CARD ────────────────────────────────
class _ServiceCard extends StatefulWidget {
  final _Service service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(18),

          // 🔥 SHADOW + GLOW
          boxShadow: [
            BoxShadow(
              color: s.accent.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],

          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: s.tint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(s.icon, color: s.accent, size: 26),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(s.subtitle, style: GoogleFonts.inter(color: _muted)),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

// ─── MODEL ───────────────────────────────────────
class _Service {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Color tint;
  final Widget page;

  const _Service({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.tint,
    required this.page,
  });
}
