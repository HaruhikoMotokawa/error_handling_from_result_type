/// アプリケーション全体で使用する基底例外クラス
abstract class AppException implements Exception {
  AppException({
    required this.code,
    required this.message,
    this.prefix = 'AppException',
  });

  /// エラーコード
  final String code;

  /// エラーメッセージ
  final String message;

  /// プレフィックス（エラーの種類を識別）
  final String prefix;

  @override
  String toString() => '[$prefix] $code: $message';
}

/// ネットワーク関連の例外
class NetworkException extends AppException {
  NetworkException({
    required super.code,
    required super.message,
  }) : super(prefix: 'NetworkException');
}

/// サーバーエラー関連の例外
class ServerException extends AppException {
  ServerException({
    required super.code,
    required super.message,
  }) : super(prefix: 'ServerException');
}

/// タイムアウト例外
class TimeoutException extends AppException {
  TimeoutException({
    required super.code,
    required super.message,
  }) : super(prefix: 'TimeoutException');
}

/// ストレージ関連の例外
class StorageException extends AppException {
  StorageException({
    required super.code,
    required super.message,
  }) : super(prefix: 'StorageException');
}

/// 権限関連の例外
class PermissionException extends AppException {
  PermissionException({
    required super.code,
    required super.message,
  }) : super(prefix: 'PermissionException');
}

/// データが見つからない例外
class NotFoundException extends AppException {
  NotFoundException({
    required super.code,
    required super.message,
  }) : super(prefix: 'NotFoundException');
}
