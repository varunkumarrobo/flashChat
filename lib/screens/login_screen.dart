
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flashchat/services/database_services.dart';
import 'package:flashchat/widgets/rounded_button.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';
import '../helper/helper_function.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _auth  = AuthService();
  late String email;
  late String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: showSpinner? ModalProgressHUD(inAsyncCall: showSpinner, child: const Center(child: Text('loading'))):Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 50.0,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                  //print(email);
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                prefixIcon: const Icon(
                  Icons.email,
                )),
                // check tha validation
                validator: (val) {
                  return RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val!)
                      ? null
                      : "Please enter a valid email";
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                validator: (val){
                  if(val!.length < 6){
                    return "password must be at least 6 characters";
                  }else {
                    return null;
                  }
                },
                onChanged: (value) {
                  password = value;
                 // print(password);
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                // suffixIcon: to be edit
                  ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log In ',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  login();
                },
              ),
              const SizedBox(height: 10,),
              Center(
                child: Text.rich(TextSpan(
                  text: "Don't have an account? ",
                  style: const TextStyle(
                      color: Colors.black, fontSize: 14),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Register here",
                        style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, RegistrationScreen.id);
                            // nextScreen(context, const RegisterPage());
                          }),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
  login() async {
    if(formKey.currentState!.validate()){
      setState(() {
        showSpinner = true;
      });
      await _auth.loginwithUserNameandPassword(email, password).
      then((value) async{
        if (value == true) {
          QuerySnapshot snapshot =
          await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          //saving the values to our shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          Navigator.pushNamed(context, HomeScreen.id);
        } else {
          showSnackbar(context, Colors.blue, value);
          setState(() {
            showSpinner = false;
          });
        }
      });
    }
  }
}
//
// if (formKey.currentState!.validate()){}
// setState(() {
// showSpinner = true;
// });
// try{
// final user =
// await _auth.signInWithEmailAndPassword(email: email, password: password);
// if(user != null){
// Navigator.pushNamed(context, ChatScreen.id);
// }
// setState(() {
// showSpinner = false;
// });
// }catch (e){
// print(e);
// }
// Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
// Navigator.pushNamed(context, RegistrationScreen.id);