import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/process.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> queryUsers(
  UsersQueryEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  Repository<UserModel> repository,
) async {
  try {
    emit(state.copyWith(
      loadUsersProcess: Process.loading(),
      userDocuments: {},
    ));

    final queryResult = await repository.query(event.usersQuery);
    final userDocuments = <String, DocumentSnapshot<UserModel>>{};

    for (final doc in queryResult) {
      userDocuments[doc.id] = doc;
    }

    emit(state.copyWith(
      userDocuments: userDocuments,
      loadUsersProcess: Process.success(),
    ));
  } catch (e, s) {
    final error = "$e\n$s";
    debugPrint(error);
    emit(state.copyWith(loadUsersProcess: Process.failed(error)));
  }
}
