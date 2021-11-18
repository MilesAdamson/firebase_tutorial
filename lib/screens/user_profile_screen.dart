import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/components/get_photo_dialog.dart';
import 'package:firebase_tutorial/components/user_profile_image.dart';
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
  /// We need to save a reference to the bloc to add events in [dispose]
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
        // TODO because we navigate here from a UserListTile we know this user exists.
        // However, this might not work very well for deep linking where you could
        // enter a screen from a different app state where they don't.
        final user = state.userDocuments[widget.id]!.data()!;

        return Scaffold(
          appBar: AppBar(
            title: Text(user.name),
            actions: [
              IconButton(
                onPressed: () async {
                  final file = await showGetPhotoDialog(
                    context,
                    alertDialogContent: const Text(
                        "Take a new profile picture, or choose from files"),
                  );

                  if (file != null) {
                    context
                        .read<UsersBloc>()
                        .add(UsersChangeProfileImageEvent(user.id, file));
                  }
                },
                icon: const Icon(Icons.camera_alt),
              )
            ],
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CircularNetworkImage(
                  url: state.userProfileImageDownloadURLs[user.id],
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
