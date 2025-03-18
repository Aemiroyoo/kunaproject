import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kunaproject/login/login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Ambil user yang sedang login
    User? user = FirebaseAuth.instance.currentUser;

    // Fungsi Logout
    Future<void> _logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Panggil fungsi logout saat tombol ditekan
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user != null
                ? Text(
                  "Selamat datang di halaman Home, ${user.uid}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
                : Text(
                  "Terjadi kesalahan. Tidak dapat mengambil data user.",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _logout, child: Text("Logout")),
          ],
        ),
      ),
    );
  }
}
