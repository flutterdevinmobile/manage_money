import '../entities/statistics_entity.dart';

abstract class StatisticsRepository {
  Future<StatisticsEntity> getStatistics(String userId);
  Future<StatisticsEntity> getStatisticsByDateRange(
    String userId, 
    DateTime startDate, 
    DateTime endDate
  );
}
