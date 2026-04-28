
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFFF6F5F2);
const _orange = Color(0xFFF57C00);
const _ink = Color(0xFF121212);
const _muted = Color(0xFF8A887F);
const _border = Color(0xFFE4E1D9);
const _white = Colors.white;

class FireSignUpPage extends StatefulWidget {
  const FireSignUpPage({super.key});

  @override
  State<FireSignUpPage> createState() => _FireSignUpPageState();
}

class _FireSignUpPageState extends State<FireSignUpPage> {
  final station = TextEditingController();
  final officer = TextEditingController();
  final area = TextEditingController();

  final username = TextEditingController(); // ✅ new
  final password = TextEditingController(); // ✅ new
  final confirmPassword = TextEditingController(); // ✅ new
  final contact = TextEditingController(); // ✅ new

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

              // 🔥 FIRE FIELDS
              _Field("Station Name", station, 0, Icons.local_fire_department),
              _Field("Officer Name", officer, 1, Icons.person_outline),
              _Field("Area Covered", area, 2, Icons.map_outlined),

              // 🔐 AUTH FIELDS
              _Field("Username", username, 3, Icons.account_circle_outlined),

              _Field(
                "Password",
                password,
                4,
                Icons.lock_outline,
                isPassword: true,
                hideText: hidePassword,
                toggle: () {
                  setState(() => hidePassword = !hidePassword);
                },
              ),

              _Field(
                "Confirm Password",
                confirmPassword,
                5,
                Icons.lock_outline,
                isPassword: true,
                hideText: hideConfirmPassword,
                toggle: () {
                  setState(() => hideConfirmPassword = !hideConfirmPassword);
                },
              ),

              _Field(
                "Email / Mobile",
                contact,
                6,
                Icons.phone_android_outlined,
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

              // 🔥 CTA CONNECTED
              GestureDetector(
                onTap: createUser,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: _orange,
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
          setState(() {
            _focusedIndex = value ? index : -1;
          });
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
            prefixIcon: Icon(icon, color: isFocused ? _orange : _muted),

            // 🔥 PASSWORD TOGGLE
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

// 🔥 HEADER
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
            color: _orange,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.local_fire_department, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "FIRE BRIGADE",
              style: GoogleFonts.inter(color: _orange, fontSize: 11),
            ),
            Text(
              "Station Registration",
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

// 🔹 SUBTITLE
class _Subtitle extends StatelessWidget {
  const _Subtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Create station account to activate emergency response.",
      style: GoogleFonts.inter(color: _muted),
    );
  }
}

// (CTA widget removed from here as it's built inline above)

// 🔹 FOOTER
class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Secure network · Fire node",
        style: GoogleFonts.inter(color: _border, fontSize: 11),
      ),
    );
  }
}
