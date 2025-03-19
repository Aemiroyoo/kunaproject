import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kunaproject/auth/auth_service.dart';
import 'package:kunaproject/auth/signup_screen.dart';
import 'package:kunaproject/home/home_screen.dart';
import 'package:kunaproject/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final _auth = AuthService();

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 10),
            if (errorMessage != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  showToast("Email dan Password tidak boleh kosong.");
                  return;
                }

                String? error = await _auth.signInWithEmail(email, password);

                if (error == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  showToast(error); // Tampilkan error dengan FlutterToast
                }
              },
              child: Text("Login"),
            ),
            SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: () async {
            //     await _authService.loginWithGoogle();
            //   },
            //   child: Text('Sign In with Google'),
            // ),
            ElevatedButton(
              onPressed: () async {
                User? user = await _authService.signInWithGoogle();

                if (user != null) {
                  print("Google Sign-In Success: ${user.uid}");
                  showToast("Login berhasil!", backgroundColor: Colors.green);

                  // Arahkan user ke HomeScreen setelah login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  showToast("Login dengan Google dibatalkan atau gagal.");
                }
              },
              child: Text("Login dengan Google"),
            ),

            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Pindah ke halaman sign up
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text("Don't have an account? Sign up here."),
            ),
          ],
        ),
      ),
    );
  }
}
