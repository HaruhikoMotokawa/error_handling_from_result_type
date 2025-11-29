part of 'user_repository.dart';

/// GetUserの戻り値型
typedef GetUserResult = Result<User, GetUserException>;

/// FetchUserの戻り値型
typedef _FetchUserResult = Result<User, FetchUserException>;

/// SaveUserの戻り値型
typedef _SaveUserResult = Result<User, SaveUserException>;
