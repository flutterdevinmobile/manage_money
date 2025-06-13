import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/data/base_firestore_service.dart';
import '../models/expense_model.dart';

class ExpenseFirestoreService extends BaseFirestoreService<ExpenseModel> {
  ExpenseFirestoreService(FirebaseFirestore firestore) 
      : super(firestore, 'expenses');

  @override
  ExpenseModel fromFirestore(DocumentSnapshot doc) {
    return ExpenseModel.fromFirestore(doc);
  }

  @override
  Map<String, dynamic> toFirestore(ExpenseModel entity) {
    return entity.toFirestore();
  }

  // Expense specific methods can be added here
  Future<List<ExpenseModel>> getExpensesByCategory(String userId, String category) async {
    try {
      final querySnapshot = await firestore
          .collection(collectionName)
          .where('userId', isEqualTo: userId)
          .where('category', isEqualTo: category)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get expenses by category: $e');
    }
  }

  Future<List<ExpenseModel>> getExpensesByDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  ) async {
    try {
      final querySnapshot = await firestore
          .collection(collectionName)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to get expenses by date range: $e');
    }
  }

  // Legacy methods for backward compatibility
  Future<List<ExpenseModel>> getExpenses(String userId) => getByUserId(userId);
  Future<ExpenseModel> addExpense(ExpenseModel expense) => add(expense);
  Future<ExpenseModel> updateExpense(ExpenseModel expense) => update(expense.id, expense);
  Future<void> deleteExpense(String expenseId) => delete(expenseId);
  Stream<List<ExpenseModel>> getExpensesStream(String userId) => getStreamByUserId(userId);
}
