import 'package:firebase_tutorial/util/languages.dart';

class UsersQuery {
  final bool? isEmailVerified;
  final DateTime bornAfter;
  final LanguageIdentifier language;

  UsersQuery({
    required this.isEmailVerified,
    required this.bornAfter,
    required this.language,
  });
}
