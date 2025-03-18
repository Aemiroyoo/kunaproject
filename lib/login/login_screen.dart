import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kunaproject/auth/auth_service.dart';
import 'package:kunaproject/auth/signup_screen.dart';
import 'package:kunaproject/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
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
                  setState(() {
                    errorMessage = "Email dan Password tidak boleh kosong.";
                  });
                  return;
                }

                String? error = await _authService.signInWithEmail(
                  email,
                  password,
                );

                print(
                  "Login Error: $error",
                ); // Tambahkan debugging untuk melihat error di console

                if (error == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                } else {
                  setState(() {
                    errorMessage = error;
                  });
                }
              },
              child: Text("Login"),
            ),

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
