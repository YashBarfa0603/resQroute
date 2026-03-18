import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/auth/ambulance.dart';
import 'package:res_q_route/dashboard/amb_dash.dart';

class AmbulanceSignInPage extends StatefulWidget {
  const AmbulanceSignInPage({super.key});

  @override
  State<AmbulanceSignInPage> createState() => _AmbulanceSignInPageState();
}

class _AmbulanceSignInPageState extends State<AmbulanceSignInPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  bool hidePassword = true;

  // 🔥 TEMP LOGIN FUNCTION
  void loginUser() {
    final email = username.text.trim();
    final pass = password.text.trim();

    // ✅ Validation
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    // ✅ TEMP SUCCESS (No Firebase)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login Successful (Demo Mode)")),
    );

    // 🚀 Navigate to Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AmbulanceDashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI(
      context,
      title: "Ambulance Login",
      color: Colors.redAccent,
      icon: Icons.local_hospital,
    );
  }

  Widget _buildUI(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
  }) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🔴 ICON
            Icon(icon, size: 60, color: color),

            const SizedBox(height: 15),

            // 🔴 TITLE
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // 👤 EMAIL FIELD
            TextField(
              controller: username,
              decoration: InputDecoration(
                labelText: "Enter Email",
                prefixIcon: Icon(Icons.person, color: color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔒 PASSWORD FIELD
            TextField(
              controller: password,
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock, color: color),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 FORGOT PASSWORD
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?"),
              ),
            ),

            const SizedBox(height: 20),

            // 🔴 LOGIN BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: loginUser,
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 SIGN UP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New User? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AmbulanceSignUpPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
