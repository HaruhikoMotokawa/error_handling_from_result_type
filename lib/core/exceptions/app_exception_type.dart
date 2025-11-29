/// エラー定義を一元管理するEnum
enum AppExceptionType {
  // Fetch系
  fetchUserNetwork(
    prefix: 'FetchUserNetworkException',
    code: 1001,
    message: 'ネットワークに接続できません',
  ),
  fetchUserServer(
    prefix: 'FetchUserServerException',
    code: 1002,
    message: 'サーバーエラーが発生しました',
  ),
  fetchUserTimeout(
    prefix: 'FetchUserTimeoutException',
    code: 1003,
    message: 'リクエストがタイムアウトしました',
  ),
  fetchUserUnexpected(
    prefix: 'FetchUserUnexpectedException',
    code: 1099,
    message: '予期しないエラーが発生しました',
  ),

  // Save系
  saveUserStorage(
    prefix: 'SaveUserStorageException',
    code: 2001,
    message: 'ストレージ容量が不足しています',
  ),
  saveUserPermission(
    prefix: 'SaveUserPermissionException',
    code: 2002,
    message: '書き込み権限がありません',
  ),
  saveUserUnexpected(
    prefix: 'SaveUserUnexpectedException',
    code: 2099,
    message: '予期しないエラーが発生しました',
  ),

  // GetUser系（上位層）
  getUserFetch(
    prefix: 'GetUserFetchException',
    code: 3001,
    message: 'ユーザー取得に失敗しました',
  ),
  getUserSave(
    prefix: 'GetUserSaveException',
    code: 3002,
    message: 'ユーザー保存に失敗しました',
  ),
  ;

  const AppExceptionType({
    required this.prefix,
    required this.code,
    required this.message,
  });

  final String prefix;
  final int code;
  final String message;
}
