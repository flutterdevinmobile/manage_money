import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _authService;

  AuthRepositoryImpl(this._authService);

  @override
  Future<UserEntity?> getCurrentUser() {
    return _authService.getCurrentUser();
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(String email, String password) {
    return _authService.signInWithEmailAndPassword(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(String email, String password) {
    return _authService.signUpWithEmailAndPassword(email, password);
  }

  @override
  Future<UserEntity> signInWithGoogle() {
    return _authService.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return _authService.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _authService.sendPasswordResetEmail(email);
  }

  @override
  Stream<UserEntity?> get authStateChanges => _authService.authStateChanges;
}
