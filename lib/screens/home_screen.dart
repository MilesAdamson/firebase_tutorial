import 'package:firebase_tutorial/repositories/users_repository.dart';
import 'package:firebase_tutorial/screens/paginated_screen.dart';
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
          ListTile(
            title: const Text("Paginated Users List"),
            subtitle: const Text(
                "Expanding on the users list, this page loads ${UsersRepository.paginationSize} users per page"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaginatedScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
