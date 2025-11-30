import 'package:error_handling_from_result_type/core/exceptions/app_exception.dart';

sealed class FetchUserException extends AppException {
  FetchUserException(super.type);
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
