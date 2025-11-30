import 'package:error_handling_from_result_type/core/exceptions/app_exception.dart';

sealed class SaveUserException extends AppException {
  SaveUserException(super.type);
}

class SaveUserStorageException extends SaveUserException {
  SaveUserStorageException(super.type);
}

class SaveUserPermissionException extends SaveUserException {
  SaveUserPermissionException(super.type);
}

class SaveUserUnexpectedException extends SaveUserException {
  SaveUserUnexpectedException(super.type);
}
