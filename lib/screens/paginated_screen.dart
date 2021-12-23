import 'dart:async';

import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/components/user_list_tile.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PaginatedScreen extends StatefulWidget {
  const PaginatedScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PaginatedScreenState();
}

class PaginatedScreenState extends State<PaginatedScreen> {
  late final UsersBloc usersBloc = context.read<UsersBloc>();

  final _pagingController =
      PagingController<String, UserModel>(firstPageKey: "");

  @override
  void initState() {
    // Sort modifies the list and returns void, so we use .from()
    // and ".." to create a new sorted list. NOTE this assumes users
    // are only loaded alphabetically, if we had a user who's name started with
    // "Y" randomly mixed in, we would start loading users which start with "Y".
    // This could cause gaps in our list if we had only loaded A-D before that.
    final knownUsers = List<UserModel>.from(usersBloc.state.users)
      ..sort((a, b) => a.name.compareTo(b.name));

    // Set the initial state of the controller
    if (knownUsers.isNotEmpty) {
      _pagingController.value = PagingState(
        nextPageKey: knownUsers.last.name,
        itemList: knownUsers,
      );
    }
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(String startAt) async {
    late final StreamSubscription s;
    final completer = Completer<List<UserModel>>();

    // It's a bit annoying to pull the page out of the Bloc,
    // but by doing this we still have the logic in the bloc and
    // the UI does not directly use the repository. This keeps our state
    // paradigm where there is only 1 source of truth for a UserModel
    s = usersBloc.stream
        .map((state) => state.loadUsersPageProcess)
        .distinct()
        .listen((process) async {
      if (process.result != null) {
        await s.cancel();
        completer.complete(process.result);
      }
    });

    // Set up the listener first and THEN dispatch. Firebase loads so fast
    // that it appears to be possible that it returns before the listener
    // is set up if it's in the other order.
    usersBloc.add(UsersLoadPageEvent(startAt));
    final users = await completer.future;

    final isLastPage = users.length < UsersRepository.paginationSize;
    isLastPage
        ? _pagingController.appendLastPage(users)
        : _pagingController.appendPage(users, users.last.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paginated Screen"),
      ),
      body: PagedListView<String, UserModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<UserModel>(
          itemBuilder: (context, user, index) => UserListTile(
            user: user,
          ),
        ),
      ),
    );
  }
}
