import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/enums/loan_status.dart';
import '../models/loan_model.dart';

class LoanFirestoreService {
  final FirebaseFirestore _firestore;
  static const String _collection = 'loans';

  LoanFirestoreService(this._firestore);

  Future<List<LoanModel>> getLoans(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => LoanModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get loans: $e');
    }
  }

  Future<LoanModel> addLoan(LoanModel loan) async {
    try {
      final docRef = await _firestore
          .collection(_collection)
          .add(loan.toFirestore());

      final doc = await docRef.get();
      return LoanModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to add loan: $e');
    }
  }

  Future<LoanModel> updateLoan(LoanModel loan) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(loan.id)
          .update(loan.toFirestore());

      final doc = await _firestore
          .collection(_collection)
          .doc(loan.id)
          .get();

      return LoanModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to update loan: $e');
    }
  }

  Future<void> deleteLoan(String loanId) async {
    try {
      await _firestore.collection(_collection).doc(loanId).delete();
    } catch (e) {
      throw Exception('Failed to delete loan: $e');
    }
  }

  Future<LoanModel> markAsPaid(String loanId) async {
    try {
      await _firestore.collection(_collection).doc(loanId).update({
        'status': LoanStatus.paid.name,
        'paidAt': Timestamp.now(),
      });

      final doc = await _firestore
          .collection(_collection)
          .doc(loanId)
          .get();

      return LoanModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to mark loan as paid: $e');
    }
  }

  Stream<List<LoanModel>> getLoansStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LoanModel.fromFirestore(doc))
            .toList());
  }
}
