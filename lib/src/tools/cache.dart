class Cache<T> {
  /// 缓存数据
  final T data;

  /// 脏位标记
  bool isDirty = false;
  Cache({required this.data});
}
