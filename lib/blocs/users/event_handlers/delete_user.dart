import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/process.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/users_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> deleteUser(
  UsersDeleteEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  UsersRepository repository,
) async {
  try {
    var deletionsMap = Map<String, Process>.from(state.deleteUserProcesses);
    deletionsMap[event.id] = Process.loading();
    emit(state.copyWith(deleteUserProcesses: deletionsMap));

    await repository.delete(event.id);

    final userDocuments =
        Map<String, DocumentSnapshot<UserModel>>.from(state.userDocuments);

    userDocuments.remove(event.id);

    deletionsMap = Map<String, Process>.from(state.deleteUserProcesses);
    deletionsMap[event.id] = Process.success();
    emit(state.copyWith(
      userDocuments: userDocuments,
      deleteUserProcesses: deletionsMap,
    ));
  } catch (e, s) {
    final error = "$e\n$s";
    debugPrint(error);
    final deletionsMap = Map<String, Process>.from(state.deleteUserProcesses);
    deletionsMap[event.id] = Process.failed(error);
    emit(state.copyWith(deleteUserProcesses: deletionsMap));
  }
}
