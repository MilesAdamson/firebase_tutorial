import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> onUserUpdated(
  UsersUpdatedEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  Repository<UserModel> repository,
) async {
  final users =
      Map<String, DocumentSnapshot<UserModel>>.from(state.userDocuments);
  users[event.document.id] = event.document;
  emit(state.copyWith(userDocuments: users));
}
