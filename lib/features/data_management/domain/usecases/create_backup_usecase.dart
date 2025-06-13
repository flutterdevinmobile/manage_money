import '../entities/backup_entity.dart';
import '../repositories/data_management_repository.dart';

class CreateBackupUseCase {
  final DataManagementRepository repository;

  CreateBackupUseCase(this.repository);

  Future<BackupEntity> call(String userId) {
    return repository.createBackup(userId);
  }
}
