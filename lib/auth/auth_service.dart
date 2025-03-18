import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register User
  Future<String?> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Null berarti sukses
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Email ini sudah terdaftar. Silakan gunakan email lain atau login.";
      }
      return e.message; // Mengembalikan pesan error dari Firebase
    } catch (e) {
      return "Terjadi kesalahan. Silakan coba lagi.";
    }
  }

  // Login User dengan validasi error spesifik
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Jika login sukses, tidak ada error
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException Code: ${e.code}"); // Debugging error

      if (e.code == 'user-not-found') {
        return "Email tidak terdaftar. Silakan daftar terlebih dahulu.";
      } else if (e.code == 'wrong-password') {
        return "Password yang Anda masukkan salah.";
      } else if (e.code == 'invalid-credential') {
        return "Email atau password yang Anda masukkan salah.";
      }
      return "Terjadi kesalahan saat login: ${e.message}"; // Pesan default
    } catch (e) {
      print("Exception: $e"); // Debugging tambahan
      return "Terjadi kesalahan. Silakan coba lagi.";
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
