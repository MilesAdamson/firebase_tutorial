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

  List<UserModel> get users =>
      userDocuments.values.map((doc) => doc.data()!).toList();

  const UsersState._internal(
    this.userDocuments,
    this.loadUsersProcess,
    this.createUserProcess,
    this.queryUsersProcess,
    this.deleteUserProcesses,
  );

  factory UsersState.initial() {
    return UsersState._internal(
      const <String, DocumentSnapshot<UserModel>>{},
      Process.initial(),
      Process.initial(),
      Process.initial(),
      const <String, Process>{},
    );
  }

  UsersState copyWith({
    Map<String, DocumentSnapshot<UserModel>>? userDocuments,
    Process? loadUsersProcess,
    Process? createUserProcess,
    Process? queryUsersProcess,
    Map<String, Process>? deleteUserProcesses,
  }) {
    return UsersState._internal(
      userDocuments ?? this.userDocuments,
      loadUsersProcess ?? this.loadUsersProcess,
      createUserProcess ?? this.createUserProcess,
      queryUsersProcess ?? this.queryUsersProcess,
      deleteUserProcesses ?? this.deleteUserProcesses,
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
            createUserProcess == other.createUserProcess);
  }
}
