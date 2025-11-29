import 'package:error_handling_from_result_type/core/exceptions/app_exception.dart';

// fetch のエラー型
sealed class FetchUserException extends AppException {
  const FetchUserException({
    required super.prefix,
    required super.code,
    required super.message,
  });
}

class FetchUserNetworkException extends FetchUserException {
  const FetchUserNetworkException()
      : super(
          prefix: 'FetchUser',
          code: 1001,
          message: 'ネットワークに接続できません',
        );
}

class FetchUserServerException extends FetchUserException {
  const FetchUserServerException()
      : super(
          prefix: 'FetchUser',
          code: 1002,
          message: 'サーバーエラーが発生しました',
        );
}

class FetchUserTimeoutException extends FetchUserException {
  const FetchUserTimeoutException()
      : super(
          prefix: 'FetchUser',
          code: 1003,
          message: 'リクエストがタイムアウトしました',
        );
}

class FetchUserUnexpectedException extends FetchUserException {
  const FetchUserUnexpectedException(String detail)
      : super(
          prefix: 'FetchUser',
          code: 1099,
          message: '予期しないエラー: $detail',
        );
}
