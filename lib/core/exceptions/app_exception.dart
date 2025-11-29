/// アプリケーション全体で使用する基底例外クラス
abstract class AppException implements Exception {
  const AppException({
    required this.prefix,
    required this.code,
    required this.message,
  });

  /// プレフィックス（エラーの種類を識別）
  final String prefix;

  /// エラーコード
  final int code;

  /// エラーメッセージ
  final String message;

  @override
  String toString() => '[$prefix] $code: $message';
}
