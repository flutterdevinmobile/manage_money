import '../entities/backup_entity.dart';

abstract class DataManagementRepository {
  Future<BackupEntity> createBackup(String userId);
  Future<void> restoreBackup(BackupEntity backup);
  Future<List<BackupEntity>> getBackups(String userId);
  Future<String> exportToCSV(String userId, String dataType);
  Future<void> deleteAllData(String userId);
}
