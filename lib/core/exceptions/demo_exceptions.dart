/// デモ用の例外クラス群
/// パッケージ群が出力する例外を想定しています
library;

/// ネットワーク関連の例外
class NetworkException implements Exception {
  const NetworkException();
}

/// サーバーエラー関連の例外
class ServerException implements Exception {
  const ServerException();
}

/// タイムアウト例外
class TimeoutException implements Exception {
  const TimeoutException();
}

/// ストレージ関連の例外
class StorageException implements Exception {
  const StorageException();
}

/// 権限関連の例外
class PermissionException implements Exception {
  const PermissionException();
}

/// データが見つからない例外
class NotFoundException implements Exception {
  const NotFoundException();
}
