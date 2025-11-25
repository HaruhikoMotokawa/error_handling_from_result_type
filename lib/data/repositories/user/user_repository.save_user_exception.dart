part of 'user_repository.dart';

// save のエラー型（パブリック）
sealed class SaveUserException implements Exception {
  const SaveUserException(this.cause);
  final Exception cause;
}

class SaveUserStorageException extends SaveUserException {
  const SaveUserStorageException(StorageException super.cause);
}

class SaveUserPermissionException extends SaveUserException {
  const SaveUserPermissionException(PermissionException super.cause);
}

class SaveUserUnexpectedException extends SaveUserException {
  const SaveUserUnexpectedException(super.cause);
}
