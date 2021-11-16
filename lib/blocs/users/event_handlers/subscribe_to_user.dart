import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/users/users_bloc.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> subscribeToUser(
  UsersSubscribeEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  UsersBloc usersBloc,
) async {
  assert(state.userDocuments.containsKey(event.id),
      "Do not subscribe to users which are not loaded yet");

  if (state.userStreamSubscriptions.containsKey(event.id)) {
    debugPrint("Stream for ${event.id} already exists");
    return;
  }

  final stream = state.userDocuments[event.id]!.reference.snapshots();

  // On each change to the document, update the map of known users.
  // The map is the source of truth for a users state
  final subscription = stream.listen((document) {
    // We cannot emit from a callback like this. Instead, dispatch a different event
    usersBloc.add(UsersUpdatedEvent(document));
  });

  // Save the subscription reference so it can be cancelled if we want
  final subscriptions =
      Map<String, StreamSubscription<DocumentSnapshot<UserModel>>>.from(
          state.userStreamSubscriptions);
  subscriptions[event.id] = subscription;
  emit(state.copyWith(userStreamSubscriptions: subscriptions));
}
