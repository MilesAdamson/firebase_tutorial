import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/util/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfileScreen extends StatefulWidget {
  final String id;

  const UserProfileScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  late final usersBloc = context.read<UsersBloc>();
  @override
  initState() {
    debugPrint(widget.id);
    usersBloc.add(UsersSubscribeEvent(widget.id));
    super.initState();
  }

  @override
  dispose() {
    usersBloc.add(UsersUnsubscribeEvent(widget.id));
    super.dispose();
  }

  String userLanguagesLabel(UserModel user) {
    if (user.languages.isEmpty) return "User knows no languages";

    return user.languages.map((e) => e.displayString).join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        // TODO because we navigate here from a UserListTile we know this exists.
        // However, this might not work very well for deep linking where you could
        // enter a screen from a different app state.
        final user = state.userDocuments[widget.id]!.data()!;

        return Scaffold(
          appBar: AppBar(
            title: Text(user.name),
          ),
          body: ListView(
            children: [
              // TODO put a real image here with Firebase Cloud Storage
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  maxRadius: 75,
                  child: Text("(profile image)"),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(user.email ?? "No email address"),
                subtitle: Text(
                  user.isEmailVerified ? "Email verified" : "Unverified user",
                ),
              ),
              ListTile(
                title: Text(user.birthDayDisplayString),
                subtitle: const Text("Birthday"),
              ),
              ListTile(
                title: Text(userLanguagesLabel(user)),
                subtitle: const Text("Languages"),
              ),
              ListTile(
                title: Text(user.phoneNumber),
                subtitle: const Text("Phone number"),
              ),
            ],
          ),
        );
      },
    );
  }
}
