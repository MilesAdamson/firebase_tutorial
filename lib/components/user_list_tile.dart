import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;

  const UserListTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  String get subtitle => user.email ?? "No email";

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(subtitle),
      trailing: IconButton(
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          context.read<UsersBloc>().add(UsersDeleteEvent(user.id));
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(id: user.id),
          ),
        );
      },
    );
  }
}
