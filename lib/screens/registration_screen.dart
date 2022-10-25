
import 'package:flashchat/helper/helper_function.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flashchat/screens/home_screen.dart';
import 'package:flashchat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../widgets/rounded_button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  late String email;
  late String password;
  late String fullName;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: showSpinner?
      Center(child: ModalProgressHUD(inAsyncCall: showSpinner,
        child: const Text('Nothing'),),)
          :Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    fullName = value;
                    //print(email);
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Full Name',
                      prefixIcon: const Icon(
                        Icons.person,
                      )),
                  // check tha validation
                  validator: (val) {
                    if (val!.isNotEmpty) {
                      return null;
                    } else {
                      return "Name cannot be empty";
                    }
                  },
                ),
                const SizedBox(height: 10,),
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
                  title: 'Registrar',
                  color: Colors.blueAccent,
                  onPressed: () async {
                    register();
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
  register() async {
    if(formKey.currentState!.validate()){
      setState(() {
        showSpinner = true;
      });
      await _auth.registerUserWithEmailandPassword(fullName, email, password).
      then((value) async{
        if (value == true) {
          //saving the shared perference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
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


// Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
// Navigator.pushNamed(context, RegistrationScreen.id);

//udemys code
// setState(() {
//   showSpinner = true;
// });
// // print(email);
// // print(password);
// try {
//   final newUser =
//   await _auth.createUserWithEmailAndPassword(
//       email: email, password: password);
//   if(newUser !=  null){
//     Navigator.pushNamed(context, ChatScreen.id);
//   }
//   setState(() {
//     showSpinner = false;
//   });
// } on FirebaseAuthException catch (e){
//   return e.message;
//   //print(e);
// }