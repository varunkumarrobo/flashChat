import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flashchat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/rounded_button.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin{

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this,
      //upperBound: 100.0,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.teal).animate(controller);
    //animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    controller.forward();
    // animation.addStatusListener((status) {
    //   if(status == AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   }else if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    //   print(status);
    // });
    controller.addListener(() {
      setState(() { });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(
                  height: 60,
                  //animation.value * 100.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Flash Chat',
                    textStyle: const TextStyle(
                      color: Colors.black45,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                    speed: const Duration(seconds: 1),
                  ),
                ],
                totalRepeatCount: 4,
                // pause: const Duration(seconds: 1),
                // displayFullTextOnTap: true,
                // stopPauseOnTap: true,
              )
            ],
          ),
          const SizedBox(
            height: 48.0,
          ),
          RoundedButton(
            title: 'Log In',
            color: Colors.lightBlueAccent,
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
          RoundedButton(
            title: 'Registrar',
            color: Colors.blueAccent,
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
              Navigator.pushNamed(context, RegistrationScreen.id);
            },
          ),
        ],
      ),
      ),
    );
  }
}


