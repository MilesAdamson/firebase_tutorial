import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/blocs/process.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class UsersState {
  final Map<String, DocumentSnapshot<UserModel>> userDocuments;
  final Process loadUsersProcess;
  final Process createUserProcess;
  final Process queryUsersProcess;
  final Map<String, Process> deleteUserProcesses;
  final Map<String, StreamSubscription<DocumentSnapshot<UserModel>>>
      userStreamSubscriptions;

  List<UserModel> get users =>
      userDocuments.values.map((doc) => doc.data()!).toList();

  const UsersState._internal(
    this.userDocuments,
    this.loadUsersProcess,
    this.createUserProcess,
    this.queryUsersProcess,
    this.deleteUserProcesses,
    this.userStreamSubscriptions,
  );

  factory UsersState.initial() {
    return UsersState._internal(
      const <String, DocumentSnapshot<UserModel>>{},
      Process.initial(),
      Process.initial(),
      Process.initial(),
      const <String, Process>{},
      const <String, StreamSubscription<DocumentSnapshot<UserModel>>>{},
    );
  }

  UsersState copyWith({
    Map<String, DocumentSnapshot<UserModel>>? userDocuments,
    Process? loadUsersProcess,
    Process? createUserProcess,
    Process? queryUsersProcess,
    Map<String, Process>? deleteUserProcesses,
    Map<String, StreamSubscription<DocumentSnapshot<UserModel>>>?
        userStreamSubscriptions,
  }) {
    return UsersState._internal(
      userDocuments ?? this.userDocuments,
      loadUsersProcess ?? this.loadUsersProcess,
      createUserProcess ?? this.createUserProcess,
      queryUsersProcess ?? this.queryUsersProcess,
      deleteUserProcesses ?? this.deleteUserProcesses,
      userStreamSubscriptions ?? this.userStreamSubscriptions,
    );
  }

  @override
  int get hashCode => hashValues(
        userDocuments,
        loadUsersProcess,
        createUserProcess,
        queryUsersProcess,
        deleteUserProcesses,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UsersState &&
            mapEquals(userDocuments, other.userDocuments) &&
            loadUsersProcess == other.loadUsersProcess &&
            queryUsersProcess == other.queryUsersProcess &&
            mapEquals(deleteUserProcesses, other.deleteUserProcesses) &&
            mapEquals(userStreamSubscriptions, other.userStreamSubscriptions) &&
            createUserProcess == other.createUserProcess);
  }
}
