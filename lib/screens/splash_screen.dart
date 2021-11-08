import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/repositories/users_repository.dart';
import 'package:firebase_tutorial/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late final UsersRepository usersRepository;

  @override
  void initState() {
    _initApp().then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              // We will add more blocs here for sure
              BlocProvider(create: (context) => UsersBloc(usersRepository)),
            ],
            child: const HomeScreen(),
          ),
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
