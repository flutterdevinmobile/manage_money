import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> call() async {
    try {
      final user = await repository.getCurrentUser();

      // 🔒 Noto'g'ri formatdagi obyekt kelmasligini tekshiramiz
      if (user == null) return null;
      if (user is! UserEntity) {
        print(
            '⚠️ Unexpected user type in GetCurrentUserUseCase: ${user.runtimeType}');
        return null;
      }

      return user;
    } catch (e) {
      print('🔥 Exception in GetCurrentUserUseCase: $e');
      return null;
    }
  }
}
