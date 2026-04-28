import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/theme/app_themes.dart';
import 'package:res_q_route/auth/login/amb_signin.dart';
import 'package:res_q_route/auth/login/fire_signin.dart';
import 'package:res_q_route/auth/login/police_signin.dart';

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
      subtitle: 'Critical Medical Response',
      icon: Icons.local_hospital_rounded,
      accent: AppThemes.primaryRed,
      page: AmbulanceSignInPage(),
    ),
    _Service(
      title: 'Fire Brigade',
      subtitle: 'Emergency Fire & Rescue',
      icon: Icons.local_fire_department_rounded,
      accent: AppThemes.primaryOrange,
      page: FireSignInPage(),
    ),
    _Service(
      title: 'Police',
      subtitle: 'Public Safety & Law',
      icon: Icons.local_police_rounded,
      accent: AppThemes.primaryBlue,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(BuildContext context, Widget page) {
    HapticFeedback.lightImpact();
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: AppThemes.bgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RESQROUTE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppThemes.primaryBlue,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Command Center',
                        style: theme.textTheme.headlineMedium,
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black.withOpacity(0.05)),
                    ),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (_, __) {
                        return Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withOpacity(
                              0.5 + (_controller.value * 0.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 8 * _controller.value,
                                spreadRadius: 2 * _controller.value,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppThemes.primaryBlue,
                  borderRadius: BorderRadius.circular(AppThemes.radiusLg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.security_rounded, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'SYSTEM STATUS: OPTIMAL',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'All emergency response units are synchronized and operational across the sector.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Text(
                "DISPATCH PORTALS",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppThemes.textMuted,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _services.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final s = _services[index];
                    return _ServiceCard(
                      service: s,
                      onTap: () => _go(context, s.page),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              
              Center(
                child: Column(
                  children: [
                    Text(
                      "RESQROUTE CORE PROTOCOL",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppThemes.textMuted.withOpacity(0.4),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "v3.0 Secure Deployment",
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppThemes.textMuted.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final _Service service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppThemes.radiusXl),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppThemes.radiusXl),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: service.accent.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppThemes.radiusLg),
              ),
              child: Icon(service.icon, color: service.accent, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppThemes.textDark,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppThemes.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppThemes.textMuted.withOpacity(0.3),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

class _Service {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Widget page;

  const _Service({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.page,
  });
}
