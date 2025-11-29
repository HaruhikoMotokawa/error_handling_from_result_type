import 'package:error_handling_from_result_type/core/exceptions/app_exception_type.dart';

/// アプリケーション全体で使用する基底例外クラス
abstract class AppException implements Exception {
  AppException(this.type);

  final AppExceptionType type;

  String get prefix => type.prefix;
  int get code => type.code;
  String get message => type.message;

  @override
  String toString() => '[$prefix] $code: $message';
}
