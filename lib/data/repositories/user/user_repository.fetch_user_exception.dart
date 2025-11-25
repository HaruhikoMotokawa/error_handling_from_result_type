part of 'user_repository.dart';

// fetch のエラー型（パブリック）
sealed class FetchUserException implements Exception {
  const FetchUserException(this.cause);
  final Exception cause;
}

class FetchUserNetworkException extends FetchUserException {
  const FetchUserNetworkException(NetworkException super.cause);
}

class FetchUserServerException extends FetchUserException {
  const FetchUserServerException(ServerException super.cause);
}

class FetchUserTimeoutException extends FetchUserException {
  const FetchUserTimeoutException(TimeoutException super.cause);
}

class FetchUserUnexpectedException extends FetchUserException {
  const FetchUserUnexpectedException(super.cause);
}
