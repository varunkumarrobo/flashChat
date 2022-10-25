import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/services/database_services.dart';

import '../helper/helper_function.dart';

class AuthService{
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginwithUserNameandPassword(
      String email, String password) async {
    try {
      User user = (
          await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password)).user!;
      if (user != null) {
        // Navigator.pushNamed(context, ChatScreen.id);
        // await DatabaseService(uid: user.uid).updateUserData(fullName, email);
        return true;
      }
      // setState(() {
      //   showSpinner = false;
      // });
    } on FirebaseAuthException catch (e) {
      return e.message;
      //print(e);
    }
  }

  //register
  Future registerUserWithEmailandPassword(
      String fullName,String email, String password) async {
    try {
      User user = (
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password)).user!;
      if (user != null) {
        // Navigator.pushNamed(context, ChatScreen.id);
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
      // setState(() {
      //   showSpinner = false;
      // });
    } on FirebaseAuthException catch (e) {
      return e.message;
      //print(e);
    }
  }
  //signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}