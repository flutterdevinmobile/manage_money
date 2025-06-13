class BackupEntity {
  final String id;
  final String userId;
  final DateTime createdAt;
  final Map<String, dynamic> data;
  final String version;

  const BackupEntity({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.data,
    required this.version,
  });
}
