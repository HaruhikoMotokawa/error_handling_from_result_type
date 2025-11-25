// 公開API用のエラー型
sealed class GetUserException implements Exception {
  const GetUserException(this.cause);
  final Exception cause;
}

class NetworkGetUserException extends GetUserException {
  const NetworkGetUserException(super.cause);
}

class ServerGetUserException extends GetUserException {
  const ServerGetUserException(super.cause);
}

class TimeoutGetUserException extends GetUserException {
  const TimeoutGetUserException(super.cause);
}

class StorageGetUserException extends GetUserException {
  const StorageGetUserException(super.cause);
}

class PermissionGetUserException extends GetUserException {
  const PermissionGetUserException(super.cause);
}

class UnexpectedGetUserException extends GetUserException {
  const UnexpectedGetUserException(super.cause);
}
