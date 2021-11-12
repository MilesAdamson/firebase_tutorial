import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/models/user_model.dart';
import 'package:firebase_tutorial/queries/users_query.dart';
import 'package:firebase_tutorial/repositories/repository.dart';

class UsersRepository implements Repository<UserModel> {
  final FirebaseFirestoreProvider _firestoreProvider;

  UsersRepository(this._firestoreProvider);

  FirebaseFirestore get _firestore => _firestoreProvider();

  @override
  String get collectionName => "users";

  late final CollectionReference<UserModel> _collection =
      _firestore.collection(collectionName).withConverter<UserModel>(
            fromFirestore: (snapshot, options) => UserModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (user, options) => user.toJson(),
          );

  @override
  Future<DocumentSnapshot<UserModel>> get(String id) =>
      _collection.doc(id).get();

  // Warning! you get charged per read to firestore. Returning ALL
  // documents in a collection might become expensive as your product grows.
  @override
  Future<List<DocumentSnapshot<UserModel>>> getAll() async {
    final querySnapshot = await _collection.get();
    return querySnapshot.docs;
  }

  // This creates a new document, or overwrites one if it exists
  @override
  Future<DocumentSnapshot<UserModel>> upsert(UserModel userModel) async {
    await _collection.doc(userModel.id).set(userModel);
    return get(userModel.id);
  }

  // Firestore queries are fast but have limitations. If these limitations
  // are completely breaking for your use-case you might need to use SQL instead.
  // https://firebase.google.com/docs/firestore/query-data/queries
  //
  // 1. You cannot query with "OR" logic, you must split
  // it into 2 queries and merge the results. "array-contains-any"
  // is somewhat like "OR" logic but might not work for everything.
  //
  // 2. You can only do !=, >, >=, <, <= logic on one field.
  // A query of "rating > 3.0 && ratingCount > 5" is not possible.
  // You would need to make 2 queries and sort out the results in the client.
  //
  // 3. You can use at most one array-contains clause per query.
  // You can't combine array-contains with array-contains-any.
  //
  // 4. You can use at most one in, not-in, or array-contains-any clause per query.
  // You can't combine in , not-in, and array-contains-any in the same query.
  //
  // 5. You cannot do "string contains" queries. A query of users where their
  // name contains "Jef" is not possible. This makes a fuzzy search of users
  // by name impossible to implement, unless you return all users and do it
  // client-side (but this means a lot of document reads and data usage)
  @override
  Future<List<DocumentSnapshot<UserModel>>> query(queryData) async {
    queryData = queryData as UsersQuery;

    var query = _collection
        .where(
          UserModel.keyLanguages,
          arrayContains: queryData.language,
        )
        .where(
          UserModel.keyBirthDate,
          isGreaterThan: Timestamp.fromDate(queryData.bornAfter),
        );

    // If you use limit to limit the number of documents returned, sorting
    // matters a lot because it will change which documents are returned
    if (queryData.birthDateSortDirection != null) {
      query = query.orderBy(
        UserModel.keyBirthDate,
        descending:
            queryData.birthDateSortDirection == SortDirection.descending,
      );
    }

    // You can stack orderBy such that it sorts by 1 field
    // and breaks ties with another. The way this is written,
    // sorting ties with users of the same birthday would be broken by
    // checking isEmailVerified.
    query = query.orderBy(
      UserModel.keyIsEmailVerified,
      // Sorting bools is somewhat arbitrary.
      // descending true sorts "true" above "false"
      // descending false sorts "false" above "true"
      descending: true,
    );

    return (await query.get()).docs;
  }

  @override
  Future<void> delete(String id) => _collection.doc(id).delete();
}
