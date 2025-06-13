import '../entities/statistics_entity.dart';
import '../repositories/statistics_repository.dart';

class GetStatisticsUseCase {
  final StatisticsRepository repository;

  GetStatisticsUseCase(this.repository);

  Future<StatisticsEntity> call(String userId) {
    return repository.getStatistics(userId);
  }
}
