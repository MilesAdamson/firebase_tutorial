import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/process.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> queryUsers(
  UsersQueryEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  UsersRepository repository,
) async {
  try {
    emit(state.copyWith(queryUsersProcess: Process.loading()));

    final queryResult = await repository.query(event.usersQuery);
    final userDocuments = <String, DocumentSnapshot<UserModel>>{};

    // Unlike other handlers, this one simply overwrites the entire
    // map of users with the returned values
    for (final doc in queryResult) {
      userDocuments[doc.id] = doc;
    }

    emit(state.copyWith(
      userDocuments: userDocuments,
      queryUsersProcess: Process.success(),
    ));
  } catch (e, s) {
    final error = "$e\n$s";
    debugPrint(error);
    emit(state.copyWith(queryUsersProcess: Process.failed(error)));
  }
}
