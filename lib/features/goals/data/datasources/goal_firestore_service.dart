import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/goal_model.dart';

class GoalFirestoreService {
  final FirebaseFirestore _firestore;
  static const String _collection = 'goals';

  GoalFirestoreService(this._firestore);

  Future<List<GoalModel>> getGoals(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => GoalModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get goals: $e');
    }
  }

  Future<GoalModel> addGoal(GoalModel goal) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(goal.toFirestore());

      final doc = await docRef.get();
      return GoalModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to add goal: $e');
    }
  }

  Future<GoalModel> updateGoal(GoalModel goal) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(goal.id)
          .update(goal.toFirestore());

      final doc = await _firestore
          .collection(_collection)
          .doc(goal.id)
          .get();

      return GoalModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to update goal: $e');
    }
  }

  Future<void> deleteGoal(String goalId) async {
    try {
      await _firestore.collection(_collection).doc(goalId).delete();
    } catch (e) {
      throw Exception('Failed to delete goal: $e');
    }
  }

  Future<GoalModel> addToGoal(String goalId, double amount) async {
    try {
      final docRef = _firestore.collection(_collection).doc(goalId);
      
      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        final goal = GoalModel.fromFirestore(doc);
        
        final newAmount = goal.currentAmount + amount;
        final isCompleted = newAmount >= goal.targetAmount;
        
        transaction.update(docRef, {
          'currentAmount': newAmount,
          'isCompleted': isCompleted,
        });
      });

      final doc = await docRef.get();
      return GoalModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to add to goal: $e');
    }
  }

  Stream<List<GoalModel>> getGoalsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => GoalModel.fromFirestore(doc))
            .toList());
  }
}
