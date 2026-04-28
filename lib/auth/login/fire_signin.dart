import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/auth/fire_brigade.dart'; // 🔥 your signup page
import 'package:res_q_route/dashboard/fire_dash.dart';   // 🔥 your dashboard

class FireSignInPage extends StatefulWidget {
  const FireSignInPage({super.key});

  @override
  State<FireSignInPage> createState() => _FireSignInPageState();
}

class _FireSignInPageState extends State<FireSignInPage> {
  final username = TextEditingController();
  final password = TextEditingController();

  bool hidePassword = true;

  // 🔥 LOGIN FUNCTION
  void loginUser() {
    if (username.text.trim().isEmpty || password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login Successful")),
    );

    // 🔥 Navigate to Fire Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const FireDashboard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI(
      context,
      title: "Fire Brigade Login",
      color: Colors.orange,
      icon: Icons.local_fire_department,
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
            // 🔥 ICON
            Icon(icon, size: 60, color: color),

            const SizedBox(height: 15),

            // 🔥 TITLE
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // 👤 USERNAME
            TextField(
              controller: username,
              decoration: InputDecoration(
                labelText: "Username",
                prefixIcon: Icon(Icons.person, color: color),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔒 PASSWORD
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
                onPressed: () {
                  // TODO: forgot password logic
                },
                child: const Text("Forgot Password?"),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 LOGIN BUTTON
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

            // 🔹 SIGN UP NAVIGATION
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New User? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FireSignUpPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
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