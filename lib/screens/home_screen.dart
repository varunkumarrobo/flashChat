import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: (){
          _auth.signOut();
          // Navigator
        }, child: const Text('LOGOUT')),
      ),
    );
  }
}
