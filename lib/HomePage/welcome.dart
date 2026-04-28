import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/auth/login/police_signin.dart';
import 'package:res_q_route/auth/login/amb_signin.dart';
import 'package:res_q_route/auth/login/fire_signin.dart';
import 'package:res_q_route/theme/app_themes.dart';
import 'package:res_q_route/widgets/mission_pulse.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.bgLight,
      body: Stack(
        children: [
          const Positioned(
            top: -100,
            right: -100,
            child: MissionPulse(child: SizedBox(width: 300, height: 300)),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppThemes.primaryBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.emergency_share_rounded, 
                        color: AppThemes.primaryBlue, size: 32),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    "ResQRoute",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -2,
                      color: AppThemes.textDark,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    "Mission Protocol: Select your unit to begin rapid response coordination.",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      height: 1.6,
                      color: AppThemes.textMuted,
                    ),
                  ),
                  
                  const SizedBox(height: 48),

                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _serviceCard(
                          context,
                          title: "Police Control",
                          subtitle: "Law enforcement & security",
                          icon: Icons.local_police_rounded,
                          color: AppThemes.primaryBlue,
                          onTap: () => Navigator.push(context, 
                              MaterialPageRoute(builder: (_) => const PoliceSignInPage())),
                        ),
                        const SizedBox(height: 20),
                        _serviceCard(
                          context,
                          title: "Ambulance AI",
                          subtitle: "Medical & trauma response",
                          icon: Icons.medical_services_rounded,
                          color: AppThemes.primaryRed,
                          onTap: () => Navigator.push(context, 
                              MaterialPageRoute(builder: (_) => const AmbulanceSignInPage())),
                        ),
                        const SizedBox(height: 20),
                        _serviceCard(
                          context,
                          title: "Fire Brigade",
                          subtitle: "Fire & rescue operations",
                          icon: Icons.fire_truck_rounded,
                          color: AppThemes.primaryOrange,
                          onTap: () => Navigator.push(context, 
                              MaterialPageRoute(builder: (_) => const FireSignInPage())),
                        ),
                      ],
                    ),
                  ),
                  
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "SYSTEM STATUS: OPERATIONAL",
                          style: AppThemes.baseTheme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 2,
                            color: AppThemes.primaryBlue.withOpacity(0.4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "v3.0 CLINICAL SENTINEL PROTOCOL",
                          style: GoogleFonts.manrope(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppThemes.textMuted.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppThemes.radiusXl),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: color.withOpacity(0.04), // Level 1 Surface
            borderRadius: BorderRadius.circular(AppThemes.radiusXl),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white, // Level 2 Surface
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    )
                  ],
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppThemes.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppThemes.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, 
                  color: color.withOpacity(0.3), size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
