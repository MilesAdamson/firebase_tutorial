class UsersQuery {
  final bool isEmailVerified;
  final DateTime bornAfter;

  UsersQuery(
    this.isEmailVerified,
    this.bornAfter,
  );
}
