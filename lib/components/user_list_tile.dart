import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;

  const UserListTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  String get formattedBirthDay => DateFormat.yMMMd().format(user.birthDate);

  String get subtitle {
    return "${user.email ?? "No email"}\n"
        "$formattedBirthDay\n"
        "Email verified: ${user.isEmailVerified}\n"
        "${user.languages.join(", ")}";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
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
        // TODO go to a full page view of a user profile
      },
    );
  }
}
