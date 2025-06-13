/// Base repository following SOLID principles
abstract class BaseRepository<T, ID> {
  Future<List<T>> getAll(String userId);
  Future<T> getById(ID id);
  Future<T> create(T entity);
  Future<T> update(T entity);
  Future<void> delete(ID id);
  Stream<List<T>> getAllStream(String userId);
}
