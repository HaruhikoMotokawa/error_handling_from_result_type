# error_handling_from_result_type

<img src="thumbnail/error_handling_from_result_type_thumbnail.png" width="300">

> [!NOTE]
> このプロジェクトのFlutterSDKは **3.35.4** です。

## 概要

このプロジェクトは **Result型を使ったエラーハンドリング** のサンプルプロジェクトです。

FlutterアプリケーションでRustやKotlinのような関数型プログラミングのエラーハンドリングパターンを実装する方法を示しています。

## 特徴

### 🎯 Result型による明示的なエラーハンドリング
- 成功（`Success`）と失敗（`Failure`）を型で表現
- 例外を投げずに戻り値でエラーを伝播
- `flatMap`、`asyncFlatMap`、`mapError`、`getOrThrow` によるチェーン処理

### 🏗️ 階層化されたException設計
- `AppException` - アプリ全体の基底例外クラス（`AppExceptionType`を保持）
- `AppExceptionType` - エラー定義を一元管理するEnum
- sealed classによる網羅的なエラーハンドリング

### 🔄 エラーのラップと伝播
- 下位層のエラーを上位層でラップして伝播
- 原因となった例外（`cause`）を具象型で保持しながら抽象度を上げる

### 🎨 UI層でのネストしたswitch式
- `AsyncValue` → `Result` → `Exception` の階層をswitch式でハンドリング
- sealed classの網羅性チェックを活かした安全なパターンマッチ

## アーキテクチャ

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│                  (UI / ViewModel)                        │
│   AsyncValue<Result> または AsyncValue<User> を          │
│   ネストしたswitch式でハンドリング                        │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                    Repository Layer                      │
│              (UserRepository)                            │
│   FetchUserException / SaveUserException                 │
│         ↓ mapError で GetUserException にラップ          │
│   または getOrThrow() で例外をスロー                      │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                    Data Source Layer                     │
│         (RemoteDataSource / LocalDataSource)             │
│   NetworkException / ServerException / StorageException  │
└─────────────────────────────────────────────────────────┘
```

## コード例

### Result型の定義

```dart
@freezed
sealed class Result<T, E extends Exception> with _$Result<T, E> {
  const Result._();
  const factory Result.success(T data) = Success<T, E>;
  const factory Result.failure(E error) = Failure<T, E>;

  // 成功時の値を取得、失敗時は例外をスロー
  T getOrThrow() => switch (this) {
    Success(:final data) => data,
    Failure(:final error) => throw error,
  };
}
```

### エラー型の階層

```dart
// 基底クラス - AppExceptionTypeを受け取り、ゲッターでアクセス
abstract class AppException implements Exception {
  AppException(this.type);
  final AppExceptionType type;

  String get prefix => type.prefix;
  int get code => type.code;
  String get message => type.message;
}

// Enum による一元管理
enum AppExceptionType {
  fetchUserNetwork(prefix: 'FetchUserNetworkException', code: 1001, message: 'ネットワークに接続できません'),
  fetchUserServer(prefix: 'FetchUserServerException', code: 1002, message: 'サーバーエラーが発生しました'),
  // ...
}

// sealed class による具象クラス
sealed class FetchUserException extends AppException {
  FetchUserException(super.type);
}
class FetchUserNetworkException extends FetchUserException {
  FetchUserNetworkException(super.type);
}

// 上位層のラッパー例外（具象型でcauseを保持）
sealed class GetUserException implements Exception {
  const GetUserException();
}
class GetUserFetchException extends GetUserException {
  const GetUserFetchException(this.cause);
  final FetchUserException cause;  // 具象型で保持
}
```

### Repositoryでの実装パターン

```dart
// パターン1: switch式でシンプルに実装
Future<Result<User, GetUserException>> getUser_ver1(String id) async {
  final fetchResult = await _fetchUserFromServer(id);
  switch (fetchResult) {
    case Success(data: final user):
      final saveResult = await _saveUserToLocal(user);
      return switch (saveResult) {
        Success(data: final savedUser) => Result.success(savedUser),
        Failure(error: final saveError) => Result.failure(GetUserSaveException(saveError)),
      };
    case Failure(error: final fetchError):
      return Result.failure(GetUserFetchException(fetchError));
  }
}

// パターン2: mapError + asyncFlatMap でチェーン
Future<GetUserResult> getUser_ver3(String id) async {
  final fetchResult = await _fetchUserFromServer(id);
  return fetchResult
      .mapError<GetUserException>(GetUserFetchException.new)
      .asyncFlatMap((user) async {
    final saveResult = await _saveUserToLocal(user);
    return saveResult.mapError<GetUserException>(GetUserSaveException.new);
  });
}
```

### UI層でのネストしたswitch式

```dart
// AsyncValue<User> の場合（getOrThrow()でスロー）
return switch (asyncUser) {
  AsyncData(value: final user) => UserInfo(user),
  AsyncError(:final error) => switch (error) {
    GetUserFetchException(cause: final cause) => switch (cause) {
      FetchUserNetworkException() => Text('Network Error: ${cause.message}'),
      FetchUserServerException() => Text('Server Error: ${cause.message}'),
      // ... sealed classで網羅
    },
    GetUserSaveException(cause: final cause) => switch (cause) {
      // ... sealed classで網羅
    },
    _ => Text('Unexpected Error'),
  },
  AsyncLoading() => CircularProgressIndicator(),
};

// AsyncValue<Result> の場合（Resultをそのまま使用）
return switch (asyncUserResult) {
  AsyncData(value: Success(data: final user)) => UserInfo(user),
  AsyncData(value: Failure(error: final error)) => switch (error) {
    // ... ネストしたswitch式
  },
  AsyncError(:final error) => Text('Unexpected Error'),
  AsyncLoading() => CircularProgressIndicator(),
};
```

## ディレクトリ構造

```
lib
├── core
│   ├── exceptions
│   │   ├── app_exception.dart        # 基底例外クラス（AppExceptionType保持）
│   │   └── app_exception_type.dart   # エラー定義Enum
│   └── result
│       └── result.dart               # Result型定義（getOrThrow含む）
├── data
│   └── repositories
│       └── user
│           ├── exceptions
│           │   ├── fetch_user_exception.dart  # Fetch系エラー（sealed）
│           │   ├── save_user_exception.dart   # Save系エラー（sealed）
│           │   └── get_user_exception.dart    # 上位層エラー（具象型cause）
│           ├── providers
│           │   ├── user_provider.dart         # getOrThrow()使用例
│           │   └── user_result_provider.dart  # Result型をそのまま返す例
│           └── user_repository.dart           # 複数の実装パターン（ver1〜ver6）
├── presentations
│   └── screens
│       └── home
│           └── screen.dart            # ネストしたswitch式の実装例
└── ...
```

## セットアップ

```bash
# 依存関係のインストール
flutter pub get

# コード生成
derry build
# または
dart run build_runner build --delete-conflicting-outputs
```

## VScodeの拡張と設定

.vscode/settings.jsonには以下の拡張機能を使う前提で設定が書かれています。
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
- [Better Comments](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments)
- [Todo Tree](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree)

## 参考資料

- [Flutter App Architecture with Riverpod: An Introduction](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)
- [Result Type パターン](https://doc.rust-lang.org/std/result/)
