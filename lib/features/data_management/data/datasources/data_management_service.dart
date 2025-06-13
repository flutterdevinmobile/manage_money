import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';


class DataManagementService {
  final FirebaseFirestore _firestore;

  DataManagementService(this._firestore);

  Future<Map<String, dynamic>> createBackup(String userId) async {
    try {
      final backup = <String, dynamic>{};

      // Backup expenses
      final expensesSnapshot = await _firestore
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get();
      backup['expenses'] = expensesSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      // Backup loans
      final loansSnapshot = await _firestore
          .collection('loans')
          .where('userId', isEqualTo: userId)
          .get();
      backup['loans'] = loansSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      // Backup budgets
      final budgetsSnapshot = await _firestore
          .collection('budgets')
          .where('userId', isEqualTo: userId)
          .get();
      backup['budgets'] = budgetsSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      // Backup goals
      final goalsSnapshot = await _firestore
          .collection('goals')
          .where('userId', isEqualTo: userId)
          .get();
      backup['goals'] = goalsSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      // Save backup to Firestore
      final backupDoc = await _firestore.collection('backups').add({
        'userId': userId,
        'data': backup,
        'createdAt': FieldValue.serverTimestamp(),
        'version': '1.0.0',
      });

      return {
        'id': backupDoc.id,
        'userId': userId,
        'data': backup,
        'createdAt': DateTime.now(),
        'version': '1.0.0',
      };
    } catch (e) {
      throw Exception('Failed to create backup: $e');
    }
  }

  Future<void> restoreBackup(Map<String, dynamic> backupData) async {
    try {
      final data = backupData['data'] as Map<String, dynamic>;

      // Restore expenses
      if (data['expenses'] != null) {
        final batch = _firestore.batch();
        for (final expense in data['expenses']) {
          final docRef = _firestore.collection('expenses').doc();
          expense.remove('id');
          batch.set(docRef, expense);
        }
        await batch.commit();
      }

      // Restore loans
      if (data['loans'] != null) {
        final batch = _firestore.batch();
        for (final loan in data['loans']) {
          final docRef = _firestore.collection('loans').doc();
          loan.remove('id');
          batch.set(docRef, loan);
        }
        await batch.commit();
      }

      // Restore budgets
      if (data['budgets'] != null) {
        final batch = _firestore.batch();
        for (final budget in data['budgets']) {
          final docRef = _firestore.collection('budgets').doc();
          budget.remove('id');
          batch.set(docRef, budget);
        }
        await batch.commit();
      }

      // Restore goals
      if (data['goals'] != null) {
        final batch = _firestore.batch();
        for (final goal in data['goals']) {
          final docRef = _firestore.collection('goals').doc();
          goal.remove('id');
          batch.set(docRef, goal);
        }
        await batch.commit();
      }
    } catch (e) {
      throw Exception('Failed to restore backup: $e');
    }
  }

  Future<String> exportToCSV(String userId, String dataType) async {
    try {
      String csvContent = '';
      
      switch (dataType) {
        case 'expenses':
          final expensesSnapshot = await _firestore
              .collection('expenses')
              .where('userId', isEqualTo: userId)
              .get();
          
          csvContent = 'Date,Description,Amount,Category,Type\n';
          for (final doc in expensesSnapshot.docs) {
            final data = doc.data();
            final date = (data['date'] as Timestamp).toDate();
            csvContent += '${date.toIso8601String()},${data['description']},${data['amount']},${data['category']},${data['type']}\n';
          }
          break;
          
        case 'loans':
          final loansSnapshot = await _firestore
              .collection('loans')
              .where('userId', isEqualTo: userId)
              .get();
          
          csvContent = 'Contact Name,Amount,Type,Status,Due Date,Created At\n';
          for (final doc in loansSnapshot.docs) {
            final data = doc.data();
            final dueDate = (data['dueDate'] as Timestamp).toDate();
            final createdAt = (data['createdAt'] as Timestamp).toDate();
            csvContent += '${data['contactName']},${data['amount']},${data['type']},${data['status']},${dueDate.toIso8601String()},${createdAt.toIso8601String()}\n';
          }
          break;
          
        case 'budgets':
          final budgetsSnapshot = await _firestore
              .collection('budgets')
              .where('userId', isEqualTo: userId)
              .get();
          
          csvContent = 'Name,Amount,Spent,Category,Period,Start Date,End Date\n';
          for (final doc in budgetsSnapshot.docs) {
            final data = doc.data();
            final startDate = (data['startDate'] as Timestamp).toDate();
            final endDate = (data['endDate'] as Timestamp).toDate();
            csvContent += '${data['name']},${data['amount']},${data['spent']},${data['category'] ?? 'All'},${data['period']},${startDate.toIso8601String()},${endDate.toIso8601String()}\n';
          }
          break;
          
        case 'goals':
          final goalsSnapshot = await _firestore
              .collection('goals')
              .where('userId', isEqualTo: userId)
              .get();
          
          csvContent = 'Name,Target Amount,Current Amount,Type,Target Date,Is Completed\n';
          for (final doc in goalsSnapshot.docs) {
            final data = doc.data();
            final targetDate = (data['targetDate'] as Timestamp).toDate();
            csvContent += '${data['name']},${data['targetAmount']},${data['currentAmount']},${data['type']},${targetDate.toIso8601String()},${data['isCompleted']}\n';
          }
          break;
      }

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${dataType}_export_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csvContent);
      
      return file.path;
    } catch (e) {
      throw Exception('Failed to export data: $e');
    }
  }

  Future<void> deleteAllData(String userId) async {
    try {
      final batch = _firestore.batch();

      // Delete expenses
      final expensesSnapshot = await _firestore
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in expensesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete loans
      final loansSnapshot = await _firestore
          .collection('loans')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in loansSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete budgets
      final budgetsSnapshot = await _firestore
          .collection('budgets')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in budgetsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete goals
      final goalsSnapshot = await _firestore
          .collection('goals')
          .where('userId', isEqualTo: userId)
          .get();
      for (final doc in goalsSnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to delete all data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getBackups(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('backups')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      throw Exception('Failed to get backups: $e');
    }
  }
}
