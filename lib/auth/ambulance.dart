import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/theme/app_themes.dart';

class AmbulanceSignUpPage extends StatefulWidget {
  const AmbulanceSignUpPage({super.key});

  @override
  State<AmbulanceSignUpPage> createState() => _AmbulanceSignUpPageState();
}

class _AmbulanceSignUpPageState extends State<AmbulanceSignUpPage> {
  final hospital = TextEditingController();
  final incharge = TextEditingController();
  final area = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final contact = TextEditingController();
  final city = TextEditingController();
  final pin = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void createUser() {
    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match"), backgroundColor: Colors.redAccent),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registration Successful"), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppThemes.ambulanceTheme,
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppThemes.primaryRed.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medical_services_rounded, size: 32, color: AppThemes.primaryRed),
                ),
                const SizedBox(height: 24),
                Text(
                  "Medical Registration",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppThemes.textDark,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Register your medical unit for optimized emergency response and clinical synchronization.",
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    color: AppThemes.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                _sectionTitle("HOSPITAL PROFILE"),
                _buildField(hint: "Hospital Name", controller: hospital, icon: Icons.local_hospital_rounded),
                _buildField(hint: "Medical Incharge", controller: incharge, icon: Icons.person_outline),
                _buildField(hint: "Service Area", controller: area, icon: Icons.explore_outlined),
                
                const SizedBox(height: 24),
                _sectionTitle("AUTHENTICATION"),
                _buildField(hint: "Medic ID / Username", controller: username, icon: Icons.badge_outlined),
                _buildField(
                  hint: "Access Password",
                  controller: password,
                  icon: Icons.lock_outline,
                  isPassword: true,
                  hideText: hidePassword,
                  toggle: () => setState(() => hidePassword = !hidePassword),
                ),
                _buildField(
                  hint: "Confirm Password",
                  controller: confirmPassword,
                  icon: Icons.lock_reset_rounded,
                  isPassword: true,
                  hideText: hideConfirmPassword,
                  toggle: () => setState(() => hideConfirmPassword = !hideConfirmPassword),
                ),
                
                const SizedBox(height: 24),
                _sectionTitle("LOCATION & CONTACT"),
                _buildField(hint: "Emergency Contact", controller: contact, icon: Icons.contact_emergency_outlined),
                Row(
                  children: [
                    Expanded(child: _buildField(hint: "City", controller: city, icon: Icons.business_rounded)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildField(hint: "PIN", controller: pin, icon: Icons.pin_drop_rounded, isPin: true)),
                  ],
                ),

                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: createUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.primaryRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemes.radiusLg)),
                    ),
                    child: Text(
                      "REGISTER MEDICAL UNIT",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppThemes.textMuted,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildField({
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool isPin = false,
    bool hideText = false,
    VoidCallback? toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? hideText : false,
        style: GoogleFonts.manrope(fontWeight: FontWeight.w600, color: AppThemes.textDark, fontSize: 15),
        keyboardType: isPin ? TextInputType.number : TextInputType.text,
        inputFormatters: isPin ? [FilteringTextInputFormatter.digitsOnly] : [],
        maxLength: isPin ? 6 : null,
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
          hintStyle: TextStyle(color: AppThemes.textMuted.withOpacity(0.3), fontSize: 14),
          prefixIcon: Icon(icon, color: AppThemes.primaryRed.withOpacity(0.3), size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    hideText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: AppThemes.textMuted.withOpacity(0.5),
                    size: 20,
                  ),
                  onPressed: toggle,
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppThemes.radiusLg),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }
}
