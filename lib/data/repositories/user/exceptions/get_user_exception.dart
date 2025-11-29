import 'package:error_handling_from_result_type/core/exceptions/app_exception.dart';
import 'package:error_handling_from_result_type/data/repositories/user/exceptions/fetch_user_exception.dart';
import 'package:error_handling_from_result_type/data/repositories/user/exceptions/save_user_exception.dart';

sealed class GetUserException implements Exception {
  const GetUserException({required this.cause});

  /// 原因となった例外
  final AppException cause;
}

/// リモート取得中に発生したエラー（中身に FetchUserException を丸ごと持つ）
class GetUserFetchException extends GetUserException {
  const GetUserFetchException(FetchUserException cause) : super(cause: cause);
}

/// ローカル保存中に発生したエラー（中身に SaveUserException を丸ごと持つ）
class GetUserSaveException extends GetUserException {
  const GetUserSaveException(SaveUserException cause) : super(cause: cause);
}
