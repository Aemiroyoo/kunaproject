import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // Future<UserCredential?> loginWithGoogle() async {
  //   try {
  //     final googleUser = await GoogleSignIn().signIn();

  //     final googleAuth = await googleUser?.authentication;

  //     final cred = GoogleAuthProvider.credential(
  //       idToken: googleAuth?.idToken,
  //       accessToken: googleAuth?.accessToken,
  //     );
  //     return await _auth.signInWithCredential(cred);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google Sign-In Dibatalkan");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        print("Google Sign-In Berhasil: UID -> ${user.uid}");
      } else {
        print("Google Sign-In Gagal: Tidak mendapatkan user");
      }
      return user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

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
      if (e.code == 'user-not-found') {
        return "Email tidak terdaftar. Silakan daftar terlebih dahulu.";
      } else if (e.code == 'wrong-password') {
        return "Password yang Anda masukkan salah.";
      } else if (e.code == 'invalid-credential') {
        return "Email atau password yang Anda masukkan salah.";
      }
      return "Terjadi kesalahan saat login: ${e.message}"; // Pesan default
    } catch (e) {
      return "Terjadi kesalahan. Silakan coba lagi.";
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
