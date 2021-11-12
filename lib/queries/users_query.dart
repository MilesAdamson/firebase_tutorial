import 'package:firebase_tutorial/util/languages.dart';

enum SortDirection { ascending, descending }

class UsersQuery {
  final bool? isEmailVerified;
  final DateTime bornAfter;
  final LanguageIdentifier language;
  final SortDirection? birthDateSortDirection;

  UsersQuery({
    required this.isEmailVerified,
    required this.bornAfter,
    required this.language,
    required this.birthDateSortDirection,
  });
}
