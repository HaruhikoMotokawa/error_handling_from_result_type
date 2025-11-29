import 'package:error_handling_from_result_type/core/exceptions/app_exception.dart';

// save のエラー型（パブリック）
sealed class SaveUserException extends AppException {
  const SaveUserException({
    required super.prefix,
    required super.code,
    required super.message,
  });
}

class SaveUserStorageException extends SaveUserException {
  const SaveUserStorageException()
      : super(
          prefix: 'SaveUserStorageException',
          code: 2001,
          message: 'ストレージ容量が不足しています',
        );
}

class SaveUserPermissionException extends SaveUserException {
  const SaveUserPermissionException()
      : super(
          prefix: 'SaveUserPermissionException',
          code: 2002,
          message: '書き込み権限がありません',
        );
}

class SaveUserUnexpectedException extends SaveUserException {
  const SaveUserUnexpectedException(String detail)
      : super(
          prefix: 'SaveUserUnexpectedException',
          code: 2099,
          message: '予期しないエラー: $detail',
        );
}
