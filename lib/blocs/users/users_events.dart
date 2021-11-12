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
  final List<LanguageIdentifier> languages;
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
