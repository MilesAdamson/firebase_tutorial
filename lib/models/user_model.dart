import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/models/timestamp_converter.dart';
import 'package:flutter/foundation.dart';
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

  @JsonKey(name: keyId)
  final String id;

  @JsonKey(name: keyName)
  final String name;

  @JsonKey(name: keyPhoneNumber)
  final String phoneNumber;

  @JsonKey(name: keyEmail)
  final String email;

  @JsonKey(name: keyIsEmailVerified)
  final bool isEmailVerified;

  @JsonKey(name: keyBirthDate)
  final DateTime birthDate;

  const UserModel(
    this.id,
    this.name,
    this.phoneNumber,
    this.email,
    this.isEmailVerified,
    this.birthDate,
  );

  factory UserModel.fromJson(json) =>
      _$UserModelFromJson(Map<String, dynamic>.from(json));

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
