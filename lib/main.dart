import 'package:firebase_core/firebase_core.dart';
import 'package:flashchat/helper/helper_function.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flashchat/screens/home_screen.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flashchat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn  = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value)
    {
      if(value != null){
        setState((){
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash Chat',
      //theme: ThemeData.dark().copyWith(
        // textTheme: TextTheme(
        //   bodyText1 : TextStyle(
        //     color: Colors.black54,
        //   ),
        // ),
      //),
      initialRoute: _isSignedIn ? HomeScreen.id : WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) =>  WelcomeScreen(),
        LoginScreen.id: (context) =>   LoginScreen(),
        RegistrationScreen.id: (context) =>   RegistrationScreen(),
        ChatScreen.id: (context) =>   const ChatScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
      },
    );
  }
}




