import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tutorial/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _initApp().then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("TODO Splash Screen"),
      ),
    );
  }

  Future<void> _initApp() async {
    final firebaseApp = await Firebase.initializeApp();
  }
}
