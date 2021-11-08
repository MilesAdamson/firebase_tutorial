import 'package:firebase_tutorial/screens/users_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Users"),
            subtitle: const Text(
                "An example of Firestore, a json document storage system"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UsersScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
