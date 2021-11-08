import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/process.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

FutureOr<void> createUser(
  UsersCreateEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  Repository<UserModel> repository,
) async {
  try {
    emit(state.copyWith(createUserProcess: Process.loading()));

    final user = UserModel(
      const Uuid().v4(),
      event.name,
      event.phoneNumber,
      event.email,
      false,
      event.birthDate,
    );

    final userDocument = await repository.upsert(user);
    final userDocuments =
        Map<String, DocumentSnapshot<UserModel>>.from(state.userDocuments);

    userDocuments[user.id] = userDocument;

    emit(state.copyWith(
      userDocuments: userDocuments,
      createUserProcess: Process.success(),
    ));
  } catch (e, s) {
    final error = "$e\n$s";
    debugPrint(error);
    emit(state.copyWith(createUserProcess: Process.failed(error)));
  }
}
