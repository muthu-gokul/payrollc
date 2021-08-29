import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth auth2 = FirebaseAuth.instance;
  get user => _auth.currentUser;
  late String prefEmail;
  late String prefPassword;

  String get pref_Email {
    return prefEmail;
  }

  // Using the setter method
  // to set the input
  set pref_Email (String email) {
    this.prefEmail = email;
  }


  //SIGN UP METHOD
  Future signUp({required String email,required String password}) async {
    try {
      await auth2.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email1,required String password1}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email1, password: password1);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();
  }
}