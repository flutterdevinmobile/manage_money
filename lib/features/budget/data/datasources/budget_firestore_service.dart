import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/budget_model.dart';

class BudgetFirestoreService {
  final FirebaseFirestore _firestore;
  static const String _collection = 'budgets';

  BudgetFirestoreService(this._firestore);

  Future<List<BudgetModel>> getBudgets(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => BudgetModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get budgets: $e');
    }
  }

  Future<BudgetModel> addBudget(BudgetModel budget) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(budget.toFirestore());

      final doc = await docRef.get();
      return BudgetModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to add budget: $e');
    }
  }

  Future<BudgetModel> updateBudget(BudgetModel budget) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(budget.id)
          .update(budget.toFirestore());

      final doc = await _firestore
          .collection(_collection)
          .doc(budget.id)
          .get();

      return BudgetModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to update budget: $e');
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    try {
      await _firestore.collection(_collection).doc(budgetId).delete();
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }

  Stream<List<BudgetModel>> getBudgetsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BudgetModel.fromFirestore(doc))
            .toList());
  }
}
