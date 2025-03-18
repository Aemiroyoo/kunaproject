import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kunaproject/auth/signup_screen.dart';
// import 'signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SignUpScreen());
  }
}
