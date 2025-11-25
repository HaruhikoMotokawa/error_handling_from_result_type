part of 'user_repository.dart';

/// GetUserException - getUserメソッド専用のエラー型
sealed class GetUserException implements Exception {
  const GetUserException();
}

/// FetchUserExceptionをラップしたGetUser用のエラー
class GetUserFetchException extends GetUserException {
  const GetUserFetchException(this.cause);
  final FetchUserException cause;

  @override
  String toString() => 'GetUserFetchException(cause: $cause)';
}

/// SaveUserExceptionをラップしたGetUser用のエラー
class GetUserSaveException extends GetUserException {
  const GetUserSaveException(this.cause);
  final SaveUserException cause;

  @override
  String toString() => 'GetUserSaveException(cause: $cause)';
}

/// GetUserの戻り値型
typedef GetUserResult = Result<User, GetUserException>;

/// FetchUserの戻り値型
typedef _FetchUserResult = Result<User, FetchUserException>;

/// SaveUserの戻り値型
typedef _SaveUserResult = Result<User, SaveUserException>;
