import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/process.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/users_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> loadAllUsers(
  UsersLoadAllEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  UsersRepository repository,
) async {
  try {
    emit(state.copyWith(loadUsersProcess: Process.loading()));

    final incomingDocuments = await repository.getAll();
    final userDocuments =
        Map<String, DocumentSnapshot<UserModel>>.from(state.userDocuments);

    for (final doc in incomingDocuments) {
      userDocuments[doc.id] = doc;
    }

    emit(state.copyWith(
      userDocuments: userDocuments,
      loadUsersProcess: Process.success(),
    ));
  } catch (e, s) {
    final error = "$e\n$s";
    debugPrint(error);
    emit(state.copyWith(createUserProcess: Process.failed(error)));
  }
}
