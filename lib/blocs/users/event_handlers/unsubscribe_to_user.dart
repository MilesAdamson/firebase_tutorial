import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/users/users_events.dart';
import 'package:firebase_tutorial/blocs/users/users_state.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/repositories/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

FutureOr<void> unsubscribeToUser(
  UsersUnsubscribeEvent event,
  UsersState state,
  Emitter<UsersState> emit,
  Repository<UserModel> repository,
) async {
  if (!state.userStreamSubscriptions.containsKey(event.id)) {
    debugPrint("Stream for ${event.id} does not exist");
    return;
  }

  final subscriptions =
      Map<String, StreamSubscription<DocumentSnapshot<UserModel>>>.from(
          state.userStreamSubscriptions);

  final subscription = subscriptions.remove(event.id)!;
  subscription.cancel();
  emit(state.copyWith(userStreamSubscriptions: subscriptions));
}
