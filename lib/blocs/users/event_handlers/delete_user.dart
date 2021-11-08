import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/process.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> deleteUser(
  UsersDeleteEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  Repository<UserModel> repository,
) async {
  try {
    var deletionsMap = Map<String, Process>.from(state.deleteUserProcesses);
    deletionsMap[event.id] = Process.loading();
    emit(state.copyWith(deleteUserProcesses: deletionsMap));

    final userDocuments =
        Map<String, DocumentSnapshot<UserModel>>.from(state.userDocuments);
    await repository.delete(event.id);

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
