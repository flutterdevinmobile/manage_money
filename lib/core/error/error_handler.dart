import 'package:firebase_auth/firebase_auth.dart';

import 'app_error.dart';

/// Error handler following SOLID principles
class ErrorHandler {
  static AppError handleError(dynamic error) {
    if (error is FirebaseAuthException) {
      return AuthError(_getAuthErrorMessage(error.code), error.code);
    } else if (error is FirebaseException) {
      return FirestoreError(_getFirestoreErrorMessage(error.code), error.code);
    } else if (error is AppError) {
      return error;
    } else {
      return UnknownError(error.toString());
    }
  }

  static String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Foydalanuvchi topilmadi';
      case 'wrong-password':
        return 'Noto\'g\'ri parol';
      case 'email-already-in-use':
        return 'Email allaqachon ishlatilmoqda';
      case 'weak-password':
        return 'Zaif parol';
      case 'invalid-email':
        return 'Noto\'g\'ri email';
      case 'user-disabled':
        return 'Foydalanuvchi hisobi bloklangan';
      case 'too-many-requests':
        return 'Juda kop urinish. Keyinroq qayta urinib ko\'ring';
      default:
        return 'Autentifikatsiya xatoligi';
    }
  }

  static String _getFirestoreErrorMessage(String code) {
    switch (code) {
      case 'permission-denied':
        return 'Ruxsat rad etildi';
      case 'unavailable':
        return 'Xizmat vaqtincha mavjud emas';
      case 'deadline-exceeded':
        return 'Sorov vaqti tugadi';
      case 'resource-exhausted':
        return 'Resurs tugadi';
      default:
        return ' baza xatoligi';
    }
  }
}
