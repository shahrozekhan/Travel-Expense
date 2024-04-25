import 'dart:async';

abstract class AsyncStorageClient {
  /// Writes the provide [key], [value] pair to the storage.
  Future<void> write(String key, {required Object value});

  /// Looks up the value for the provided [key] asynchrounously.
  FutureOr<T?> read<T extends Object>(String key);

  /// Deletes the value for the provided [key].
  Future<void> delete(String key);

  /// Deletes all keys from the storage.
  Future<void> clear();

  /// Closes the storage.
  Future<void> close() => Future.value();
}
