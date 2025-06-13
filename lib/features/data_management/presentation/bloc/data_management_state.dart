import '../../domain/entities/backup_entity.dart';

abstract class DataManagementState {}

class DataManagementInitial extends DataManagementState {}

class DataManagementLoading extends DataManagementState {}

class DataManagementSuccess extends DataManagementState {
  final String message;
  final String? filePath;

  DataManagementSuccess({required this.message, this.filePath});
}

class DataManagementError extends DataManagementState {
  final String message;

  DataManagementError({required this.message});
}

class BackupsLoaded extends DataManagementState {
  final List<BackupEntity> backups;

  BackupsLoaded({required this.backups});
}
