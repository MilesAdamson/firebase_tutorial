import 'dart:math';

import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/queries/users_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

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
              itemBuilder: (context, i) {
                final user = state.users[i];
                return ListTile(
                  isThreeLine: true,
                  title: Text(user.name),
                  subtitle: Text("${user.email}\n${user.birthDate}"),
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
                    // TODO full page view of a user
                  },
                );
              },
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
    final i = Random().nextInt(50);

    context.read<UsersBloc>().add(
          UsersCreateEvent(
            name: "Example User $i",
            phoneNumber: i.toString(),
            email: "example$i@gmail.com",
            birthDate: DateTime.now().subtract(Duration(days: 365 * i)),
          ),
        );
  }

  void queryUsers(BuildContext context) {
    context.read<UsersBloc>().add(
          UsersQueryEvent(
            UsersQuery(
              false,
              DateTime(2000),
            ),
          ),
        );
  }
}
