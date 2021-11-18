import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/queries/users_query.dart';
import 'package:firebase_tutorial/util/languages.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class UsersEvent {}

@immutable
class UsersLoadAllEvent extends UsersEvent {}

@immutable
class UsersDeleteEvent extends UsersEvent {
  final String id;

  UsersDeleteEvent(this.id);
}

@immutable
class UsersCreateEvent extends UsersEvent {
  final String name;
  final String phoneNumber;
  final String? email;
  final DateTime birthDate;
  final Set<LanguageIdentifier> languages;
  final bool isEmailVerified;

  UsersCreateEvent({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.birthDate,
    required this.languages,
    required this.isEmailVerified,
  });
}

@immutable
class UsersQueryEvent extends UsersEvent {
  final UsersQuery usersQuery;

  UsersQueryEvent(this.usersQuery);
}

@immutable
class UsersUpdatedEvent extends UsersEvent {
  final DocumentSnapshot<UserModel> document;

  UsersUpdatedEvent(this.document);
}

@immutable
class UsersSubscribeEvent extends UsersEvent {
  final String id;

  UsersSubscribeEvent(this.id);
}

@immutable
class UsersUnsubscribeEvent extends UsersEvent {
  final String id;

  UsersUnsubscribeEvent(this.id);
}

@immutable
class UsersChangeProfileImageEvent extends UsersEvent {
  final String id;
  final File file;

  UsersChangeProfileImageEvent(this.id, this.file);

  String get folderId => "profile_images/$id";
}

@immutable
class UsersLoadProfileImageEvent extends UsersEvent {
  final String id;

  UsersLoadProfileImageEvent(this.id);

  String get folderId => "profile_images/$id";
}
