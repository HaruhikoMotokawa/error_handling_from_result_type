import 'package:error_handling_from_result_type/data/repositories/user/user_repository.dart';

sealed class GetUserException implements Exception {
  const GetUserException();
}

/// リモート取得中に発生したエラー（中身に FetchUserException を丸ごと持つ）
class GetUserFetchException extends GetUserException {
  const GetUserFetchException(this.cause);
  final FetchUserException cause;
}

/// ローカル保存中に発生したエラー（中身に SaveUserException を丸ごと持つ）
class GetUserSaveException extends GetUserException {
  const GetUserSaveException(this.cause);
  final SaveUserException cause;
}
