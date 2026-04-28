import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/auth/police.dart';
import 'package:res_q_route/dashboard/police_dash.dart';
import 'package:res_q_route/models/driver_info.dart';
import 'package:res_q_route/services/hive_service.dart';
import 'package:res_q_route/theme/app_themes.dart';
import 'package:uuid/uuid.dart';

class PoliceSignInPage extends StatefulWidget {
  const PoliceSignInPage({super.key});

  @override
  State<PoliceSignInPage> createState() => _PoliceSignInPageState();
}

class _PoliceSignInPageState extends State<PoliceSignInPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool hidePassword = true;

  Future<void> loginUser() async {
    if (username.text.trim().isEmpty || password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final driver = DriverInfo(
      id: const Uuid().v4(),
      name: username.text.trim(),
      vehicleType: "Police",
      vehicleNumber: "POL-${DateTime.now().millisecond}",
      contact: "Emergency Contact",
    );
    await HiveService.saveDriverInfo(driver);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PoliceDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemes.policeTheme,
      child: Scaffold(
        backgroundColor: AppThemes.bgLight,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppThemes.textDark),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppThemes.primaryBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.local_police_rounded, size: 32, color: AppThemes.primaryBlue),
                ),
                const SizedBox(height: 32),
                Text(
                  "Police Portal",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.5,
                    color: AppThemes.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Mission Authorization Required. Authenticate to access secure dispatch systems.",
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    height: 1.6,
                    color: AppThemes.textMuted,
                  ),
                ),
                const SizedBox(height: 48),
                
                _buildField(
                  controller: username,
                  label: "OFFICER IDENTIFICATION",
                  hint: "Badge number or ID",
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 24),
                _buildField(
                  controller: password,
                  label: "ACCESS KEY",
                  hint: "••••••••",
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
                
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemes.radiusLg)),
                    ),
                    child: Text("AUTHENTICATE MISSION", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ),
                ),

                const SizedBox(height: 20),
                Center(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Scanning Biometrics... Authorization Granted."),
                          backgroundColor: AppThemes.primaryBlue,
                        ),
                      );
                      Future.delayed(const Duration(seconds: 1), loginUser);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: AppThemes.primaryBlue.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fingerprint_rounded, color: AppThemes.primaryBlue, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            "USE BIOMETRIC ID",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppThemes.primaryBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 48),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PoliceSignUpPage())),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.manrope(fontSize: 14, color: AppThemes.textMuted),
                        children: const [
                          TextSpan(text: "New officer in service? "),
                          TextSpan(
                            text: "Register Unit",
                            style: TextStyle(color: AppThemes.primaryBlue, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppThemes.textMuted,
              letterSpacing: 1.5,
            ),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword && hidePassword,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppThemes.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppThemes.textMuted.withOpacity(0.3), fontSize: 15),
            prefixIcon: Icon(icon, color: AppThemes.primaryBlue.withOpacity(0.3), size: 20),
            suffixIcon: isPassword ? IconButton(
              icon: Icon(hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppThemes.textMuted, size: 20),
              onPressed: () => setState(() => hidePassword = !hidePassword),
            ) : null,
            filled: true,
            fillColor: Colors.white, 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppThemes.radiusLg),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          ),
        ),
      ],
    );
  }
}
