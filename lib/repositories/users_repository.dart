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

  // Firestore queries are fast but have limitations.
  // https://firebase.google.com/docs/firestore/query-data/queries
  @override
  Future<List<DocumentSnapshot<UserModel>>> query(queryData) async {
    if (queryData is UsersQuery) {
      final query = _collection
          .where(
            UserModel.keyIsEmailVerified,
            isEqualTo: queryData.isEmailVerified,
          )
          .where(
            UserModel.keyBirthDate,
            isGreaterThan: Timestamp.fromDate(queryData.bornAfter),
          );

      return (await query.get()).docs;
    }

    throw UnimplementedError(
        "Query of type ${queryData.runtimeType} is not implemented");
  }

  @override
  Future<void> delete(String id) => _collection.doc(id).delete();
}
