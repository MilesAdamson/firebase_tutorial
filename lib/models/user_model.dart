import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/models/timestamp_converter.dart';
import 'package:firebase_tutorial/util/languages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

// flutter packages pub run build_runner build --delete-conflicting-outputs

@immutable
@JsonSerializable()
@TimestampConverter()
class UserModel {
  static const keyId = "id";
  static const keyName = "name";
  static const keyPhoneNumber = "phoneNumber";
  static const keyEmail = "email";
  static const keyIsEmailVerified = "isEmailVerified";
  static const keyBirthDate = "birthDate";
  static const keyLanguages = "languages";

  String get birthDayDisplayString => DateFormat.yMMMd().format(birthDate);

  @JsonKey(name: keyId)
  final String id;

  @JsonKey(name: keyName)
  final String name;

  @JsonKey(name: keyPhoneNumber)
  final String phoneNumber;

  @JsonKey(name: keyEmail)
  final String? email;

  @JsonKey(name: keyIsEmailVerified)
  final bool isEmailVerified;

  @JsonKey(name: keyBirthDate)
  final DateTime birthDate;

  @JsonKey(name: keyLanguages)
  final Set<LanguageIdentifier> languages;

  Timestamp get birthDateTimestamp => Timestamp.fromDate(birthDate);

  const UserModel(
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.isEmailVerified,
    this.birthDate,
    this.languages,
  );

  factory UserModel.fromJson(json) =>
      _$UserModelFromJson(Map<String, dynamic>.from(json));

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  int get hashCode => hashValues(
        id,
        name,
        phoneNumber,
        email,
        isEmailVerified,
        birthDate,
        languages,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UserModel &&
            name == other.name &&
            phoneNumber == other.phoneNumber &&
            email == other.email &&
            isEmailVerified == other.isEmailVerified &&
            setEquals(languages, other.languages) &&
            birthDate == other.birthDate);
  }
}
