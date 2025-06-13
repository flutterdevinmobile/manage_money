import 'package:cloud_firestore/cloud_firestore.dart';

/// Base Firestore service following SOLID principles
abstract class BaseFirestoreService<T> {
  final FirebaseFirestore firestore;
  final String collectionName;

  BaseFirestoreService(this.firestore, this.collectionName);

  /// Convert Firestore document to entity
  T fromFirestore(DocumentSnapshot doc);

  /// Convert entity to Firestore data
  Map<String, dynamic> toFirestore(T entity);

  Future<List<T>> getByUserId(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection(collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get $collectionName: $e');
    }
  }

  Future<T> add(T entity) async {
    try {
      final docRef = await firestore
          .collection(collectionName)
          .add(toFirestore(entity));

      final doc = await docRef.get();
      return fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to add $collectionName: $e');
    }
  }

  Future<T> update(String id, T entity) async {
    try {
      await firestore
          .collection(collectionName)
          .doc(id)
          .update(toFirestore(entity));

      final doc = await firestore.collection(collectionName).doc(id).get();
      return fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to update $collectionName: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete $collectionName: $e');
    }
  }

  Stream<List<T>> getStreamByUserId(String userId) {
    return firestore
        .collection(collectionName)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => fromFirestore(doc)).toList());
  }
}
