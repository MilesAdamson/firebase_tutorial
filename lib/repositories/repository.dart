import 'package:cloud_firestore/cloud_firestore.dart';

typedef FirebaseFirestoreProvider = FirebaseFirestore Function();

abstract class Repository<T> {
  String get collectionName;
  Future<DocumentSnapshot<T>> get(String id);
  Future<DocumentSnapshot<T>> upsert(T userModel);
  Future<List<DocumentSnapshot<T>>> getAll();
  Future<List<DocumentSnapshot<T>>> query(dynamic queryData);
  Future<void> delete(String id);
}
