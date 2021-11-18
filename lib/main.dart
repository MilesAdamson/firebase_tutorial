import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/repositories/fire_repository.dart';
import 'package:firebase_tutorial/repositories/users_repository.dart';
import 'package:firebase_tutorial/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Use a function to pass firebase services into repositories, so
  // that you can create all of them in main before firebase is initialized
  final usersRepository = UsersRepository(() => FirebaseFirestore.instance);
  final fileRepository = FileRepository(
    ImagePicker(),
    () => FirebaseStorage.instance,
  );

  runApp(MyApp(
    usersRepository: usersRepository,
    fileRepository: fileRepository,
  ));
}

class MyApp extends StatelessWidget {
  final UsersRepository usersRepository;
  final FileRepository fileRepository;

  const MyApp({
    Key? key,
    required this.usersRepository,
    required this.fileRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => fileRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          // We will add more blocs here for sure
          BlocProvider(
            create: (context) => UsersBloc(
              usersRepository,
              fileRepository,
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Firebase',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
