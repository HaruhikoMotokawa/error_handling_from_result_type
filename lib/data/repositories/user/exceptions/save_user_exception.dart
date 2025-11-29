import 'package:error_handling_from_result_type/core/exceptions/app_exception.dart';
import 'package:error_handling_from_result_type/core/exceptions/app_exception_type.dart';

// save のエラー型（パブリック）
sealed class SaveUserException extends AppException {
  SaveUserException(AppExceptionType type)
      : super(
          prefix: type.prefix,
          code: type.code,
          message: type.message,
        );
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
