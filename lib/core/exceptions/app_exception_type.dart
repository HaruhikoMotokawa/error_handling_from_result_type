/// エラー定義を一元管理するEnum
enum AppExceptionType {
  // Fetch系
  fetchUserNetwork(
    'FetchUserNetworkException',
    1001,
    'ネットワークに接続できません',
  ),
  fetchUserServer(
    'FetchUserServerException',
    1002,
    'サーバーエラーが発生しました',
  ),
  fetchUserTimeout(
    'FetchUserTimeoutException',
    1003,
    'リクエストがタイムアウトしました',
  ),
  fetchUserUnexpected(
    'FetchUserUnexpectedException',
    1099,
    '予期しないエラーが発生しました',
  ),

  // Save系
  saveUserStorage(
    'SaveUserStorageException',
    2001,
    'ストレージ容量が不足しています',
  ),
  saveUserPermission(
    'SaveUserPermissionException',
    2002,
    '書き込み権限がありません',
  ),
  saveUserUnexpected(
    'SaveUserUnexpectedException',
    2099,
    '予期しないエラーが発生しました',
  ),

  // GetUser系（上位層）
  getUserFetch(
    'GetUserFetchException',
    3001,
    'ユーザー取得に失敗しました',
  ),
  getUserSave(
    'GetUserSaveException',
    3002,
    'ユーザー保存に失敗しました',
  ),
  ;

  const AppExceptionType(this.prefix, this.code, this.message);

  final String prefix;
  final int code;
  final String message;
}
