import 'package:error_handling_from_result_type/core/exceptions/app_exception.dart';
import 'package:error_handling_from_result_type/core/exceptions/app_exception_type.dart';

// fetch のエラー型
sealed class FetchUserException extends AppException {
  FetchUserException(AppExceptionType type)
      : super(
          prefix: type.prefix,
          code: type.code,
          message: type.message,
        );
}

class FetchUserNetworkException extends FetchUserException {
  FetchUserNetworkException(super.type);
}

class FetchUserServerException extends FetchUserException {
  FetchUserServerException(super.type);
}

class FetchUserTimeoutException extends FetchUserException {
  FetchUserTimeoutException(super.type);
}

class FetchUserUnexpectedException extends FetchUserException {
  FetchUserUnexpectedException(super.type);
}
