import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/repositories/users_repository.dart';
import 'package:firebase_tutorial/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Use a function to pass firebase services into repositories, so
  // that you can create all of them in main before firebase is initialized
  final usersRepository = MyUsersRepository(() => FirebaseFirestore.instance);

  runApp(MyApp(
    usersRepository: usersRepository,
  ));
}

class MyApp extends StatelessWidget {
  final UsersRepository usersRepository;

  const MyApp({
    Key? key,
    required this.usersRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // We will add more blocs here for sure
        BlocProvider(create: (context) => UsersBloc(usersRepository)),
      ],
      child: MaterialApp(
        title: 'Flutter Firebase',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
