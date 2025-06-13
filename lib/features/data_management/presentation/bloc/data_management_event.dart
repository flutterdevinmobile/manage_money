abstract class DataManagementEvent {}

class BackupCreateRequested extends DataManagementEvent {
  final String userId;

  BackupCreateRequested({required this.userId});
}

class BackupRestoreRequested extends DataManagementEvent {
  final String backupId;

  BackupRestoreRequested({required this.backupId});
}

class DataExportRequested extends DataManagementEvent {
  final String userId;
  final String dataType;

  DataExportRequested({required this.userId, required this.dataType});
}

class DataDeleteRequested extends DataManagementEvent {
  final String userId;

  DataDeleteRequested({required this.userId});
}

class BackupsLoadRequested extends DataManagementEvent {
  final String userId;

  BackupsLoadRequested({required this.userId});
}
