// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['id'] as String,
      json['name'] as String,
      json['phoneNumber'] as String,
      json['email'] as String,
      json['isEmailVerified'] as bool,
      const TimestampConverter().fromJson(json['birthDate'] as Timestamp),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'isEmailVerified': instance.isEmailVerified,
      'birthDate': const TimestampConverter().toJson(instance.birthDate),
    };
