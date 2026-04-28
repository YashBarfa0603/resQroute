
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// COLORS
const _bg = Color(0xFFF6F5F2);
const _red = Color(0xFFD32F2F);
const _ink = Color(0xFF121212);
const _muted = Color(0xFF8A887F);
const _border = Color(0xFFE4E1D9);
const _white = Colors.white;

class AmbulanceSignUpPage extends StatefulWidget {
  const AmbulanceSignUpPage({super.key});

  @override
  State<AmbulanceSignUpPage> createState() => _AmbulanceSignUpPageState();
}

class _AmbulanceSignUpPageState extends State<AmbulanceSignUpPage> {
  final driver = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final contact = TextEditingController();
  final hospital = TextEditingController();
  final vehicle = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final pin = TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  int _focusedIndex = -1;

  // 🔥 CREATE USER FUNCTION
  void createUser() {
    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    if (!contact.text.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter a valid email address")));
      return;
    }

    // Dummy Success behavior
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Sign Up Done Successfully")),
    );

    Navigator.pop(context); // back to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const _Header(),
              const SizedBox(height: 28),
              const _Subtitle(),
              const SizedBox(height: 30),

              _Field("Driver Name", driver, 0, Icons.person_outline),
              _Field("Username", username, 1, Icons.account_circle_outlined),

              _Field(
                "Password",
                password,
                2,
                Icons.lock_outline,
                isPassword: true,
                hideText: hidePassword,
                toggle: () => setState(() => hidePassword = !hidePassword),
              ),

              _Field(
                "Confirm Password",
                confirmPassword,
                3,
                Icons.lock_outline,
                isPassword: true,
                hideText: hideConfirmPassword,
                toggle: () =>
                    setState(() => hideConfirmPassword = !hideConfirmPassword),
              ),

              _Field("Email", contact, 4, Icons.email_outlined),
              _Field(
                "Hospital Name",
                hospital,
                5,
                Icons.local_hospital_outlined,
              ),
              _Field(
                "Vehicle Number",
                vehicle,
                6,
                Icons.directions_car_outlined,
              ),
              _Field("City", city, 7, Icons.location_city_outlined),
              _Field("State", state, 8, Icons.public_outlined),

              _Field(
                "Area PIN Code",
                pin,
                9,
                Icons.location_on_outlined,
                isPin: true,
              ),

              const SizedBox(height: 20),

              // 🔥 BUTTON CONNECTED
              GestureDetector(
                onTap: createUser,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: _red,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      "Create User",
                      style: GoogleFonts.inter(color: _white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const _Footer(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _Field(
    String hint,
    TextEditingController controller,
    int index,
    IconData icon, {
    bool isPin = false,
    bool isPassword = false,
    bool hideText = false,
    VoidCallback? toggle,
  }) {
    final isFocused = _focusedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Focus(
        onFocusChange: (value) {
          setState(() => _focusedIndex = value ? index : -1);
        },
        child: TextField(
          controller: controller,
          obscureText: isPassword ? hideText : false,
          keyboardType: isPin ? TextInputType.number : TextInputType.text,
          inputFormatters: isPin
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          maxLength: isPin ? 6 : null,
          decoration: InputDecoration(
            counterText: "",
            hintText: hint,
            prefixIcon: Icon(icon, color: isFocused ? _red : _muted),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      hideText ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                    ),
                    onPressed: toggle,
                  )
                : null,
            filled: true,
            fillColor: _white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: _border),
            ),
          ),
        ),
      ),
    );
  }
}

// HEADER
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: _red,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.local_hospital, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "AMBULANCE SERVICE",
              style: GoogleFonts.inter(color: _red, fontSize: 11),
            ),
            Text(
              "Driver Registration",
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Create your account to join emergency dispatch network.",
      style: GoogleFonts.inter(color: _muted),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Secure network · Ambulance node",
        style: GoogleFonts.inter(color: _border, fontSize: 11),
      ),
    );
  }
}
