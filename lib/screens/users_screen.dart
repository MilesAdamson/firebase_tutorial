import 'dart:async';
import 'dart:math';

import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/components/user_list_tile.dart';
import 'package:firebase_tutorial/queries/users_query.dart';
import 'package:firebase_tutorial/util/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final StreamSubscription errorListener;
  static final random = Random();

  @override
  void initState() {
    _setupQueryErrorListener();
    super.initState();
  }

  @override
  void dispose() {
    errorListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: AppBar(
          title: const Text("Users"),
          automaticallyImplyLeading: true,
        ),
        floatingActionButton: buildFloatingActionButtons(context, state),
        body: Builder(
          builder: (context) {
            if (state.userDocuments.isEmpty &&
                state.loadUsersProcess.isLoading) {
              return const Center(
                child: Text("Loading..."),
              );
            }

            if (state.userDocuments.isEmpty) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No users loaded"),
                    TextButton(
                      child: const Text("LOAD"),
                      onPressed: () {
                        context.read<UsersBloc>().add(UsersLoadAllEvent());
                      },
                    )
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 100.0),
              itemCount: state.users.length,
              itemBuilder: (context, i) => UserListTile(user: state.users[i]),
            );
          },
        ),
      );
    });
  }

  Padding buildFloatingActionButtons(BuildContext context, UsersState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () => queryUsers(context),
            label: const Text("Query Users"),
            icon: Icon(
              state.loadUsersProcess.isLoading
                  ? Icons.more_horiz
                  : Icons.search,
            ),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () => createRandomUser(context),
            label: const Text("Add User"),
            icon: Icon(
              state.createUserProcess.isLoading ? Icons.more_horiz : Icons.add,
            ),
          ),
        ],
      ),
    );
  }

  void createRandomUser(BuildContext context) {
    final yearsOld = random.nextInt(10);

    final languages = Languages.all.where((_) => flipCoin()).toSet();

    // This truncates the time of day off so that we can observe
    // sorting by a second field if the date is the same
    final now = DateTime.now();
    final birthDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: 365 * yearsOld));

    context.read<UsersBloc>().add(
          UsersCreateEvent(
            name: "Example User $yearsOld",
            phoneNumber: yearsOld.toString(),
            email: flipCoin() ? null : "example$yearsOld@gmail.com",
            birthDate: birthDate,
            languages: languages,
            isEmailVerified: flipCoin(),
          ),
        );
  }

  void queryUsers(BuildContext context) {
    context.read<UsersBloc>().add(
          UsersQueryEvent(
            UsersQuery(
              bornAfter: DateTime(1900),
              language: Languages.english,
              birthDateSortDirection: SortDirection.descending,
            ),
          ),
        );
  }

  void _setupQueryErrorListener() {
    final stream = context
        .read<UsersBloc>()
        .stream
        .map((usersState) => usersState.queryUsersProcess)
        .distinct();

    // TODO this will print raw exceptions straight to the screen.
    // Don't actually do this, instead format the error for the user.
    errorListener = stream.listen((process) {
      if (process.errorMessage != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content:
                  SingleChildScrollView(child: Text(process.errorMessage!)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    });
  }

  bool flipCoin() => (random.nextInt(2) + 1).isEven;
}
