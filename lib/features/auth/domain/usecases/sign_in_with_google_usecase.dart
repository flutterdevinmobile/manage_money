import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository
        .signInWithGoogle(); // Bu yerda UserEntity qaytarilishi kerak
  }
}
