import '../repositories/data_management_repository.dart';

class ExportDataUseCase {
  final DataManagementRepository repository;

  ExportDataUseCase(this.repository);

  Future<String> call(String userId, String dataType) {
    return repository.exportToCSV(userId, dataType);
  }
}
