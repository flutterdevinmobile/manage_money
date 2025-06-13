import '../../domain/entities/backup_entity.dart';
import '../../domain/repositories/data_management_repository.dart';
import '../datasources/data_management_service.dart';

class DataManagementRepositoryImpl implements DataManagementRepository {
  final DataManagementService _service;

  DataManagementRepositoryImpl(this._service);

  @override
  Future<BackupEntity> createBackup(String userId) async {
    final backupData = await _service.createBackup(userId);
    return BackupEntity(
      id: backupData['id'],
      userId: backupData['userId'],
      createdAt: backupData['createdAt'],
      data: backupData['data'],
      version: backupData['version'],
    );
  }

  @override
  Future<void> restoreBackup(BackupEntity backup) {
    return _service.restoreBackup({
      'id': backup.id,
      'userId': backup.userId,
      'data': backup.data,
      'createdAt': backup.createdAt,
      'version': backup.version,
    });
  }

  @override
  Future<List<BackupEntity>> getBackups(String userId) async {
    final backupsData = await _service.getBackups(userId);
    return backupsData.map((data) => BackupEntity(
      id: data['id'],
      userId: data['userId'],
      createdAt: data['createdAt'].toDate(),
      data: data['data'],
      version: data['version'],
    )).toList();
  }

  @override
  Future<String> exportToCSV(String userId, String dataType) {
    return _service.exportToCSV(userId, dataType);
  }

  @override
  Future<void> deleteAllData(String userId) {
    return _service.deleteAllData(userId);
  }
}
