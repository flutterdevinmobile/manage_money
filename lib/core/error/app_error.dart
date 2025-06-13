/// Application error classes following SOLID principles
abstract class AppError implements Exception {
  final String message;
  final String? code;

  const AppError(this.message, [this.code]);

  @override
  String toString() => message;
}

class NetworkError extends AppError {
  const NetworkError(super.message, [super.code]);
}

class AuthError extends AppError {
  const AuthError(super.message, [super.code]);
}

class ValidationError extends AppError {
  const ValidationError(super.message, [super.code]);
}

class FirestoreError extends AppError {
  const FirestoreError(super.message, [super.code]);
}

class UnknownError extends AppError {
  const UnknownError(super.message, [super.code]);
}
