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
- `flatMap`、`asyncFlatMap`、`mapError` によるチェーン処理

### 🏗️ 階層化されたException設計
- `AppException` - アプリ全体の基底例外クラス
- `AppExceptionType` - エラー定義を一元管理するEnum
- sealed classによる網羅的なエラーハンドリング

### 🔄 エラーのラップと伝播
- 下位層のエラーを上位層でラップして伝播
- 原因となった例外を保持しながら抽象度を上げる

## アーキテクチャ

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│                  (UI / ViewModel)                        │
│         GetUserException をハンドリング                   │
└───────────────────────┬─────────────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────────────┐
│                    Repository Layer                      │
│              (UserRepository)                            │
│   FetchUserException / SaveUserException                 │
│         ↓ mapError で GetUserException にラップ          │
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
  const factory Result.success(T data) = Success<T, E>;
  const factory Result.failure(E error) = Failure<T, E>;
}
```

### エラー型の階層

```dart
// 基底クラス
abstract class AppException implements Exception {
  const AppException({
    required this.prefix,
    required this.code,
    required this.message,
  });
}

// Enum による一元管理
enum AppExceptionType {
  fetchUserNetwork(prefix: '...', code: 1001, message: '...'),
  fetchUserServer(prefix: '...', code: 1002, message: '...'),
  // ...
}

// sealed class による具象クラス
sealed class FetchUserException extends AppException { ... }
class FetchUserNetworkException extends FetchUserException { ... }
class FetchUserServerException extends FetchUserException { ... }
```

### Repositoryでのエラーハンドリング

```dart
Future<GetUserResult> getUser(String id) async {
  // 1. サーバーから取得
  final fetchResult = await _fetchUserFromServer(id);

  // 2. FetchUserExceptionをGetUserFetchExceptionにラップ
  final convertedFetch =
      fetchResult.mapError<GetUserException>(GetUserFetchException.new);

  // 3. flatMapでローカル保存する
  return convertedFetch.asyncFlatMap((user) async {
    final saveResult = await _saveUserToLocal(user);
    return saveResult.mapError<GetUserException>(GetUserSaveException.new);
  });
}
```

## ディレクトリ構造

```
lib
├── core
│   ├── exceptions
│   │   ├── app_exception.dart        # 基底例外クラス
│   │   └── app_exception_type.dart   # エラー定義Enum
│   └── result
│       └── result.dart               # Result型定義
├── data
│   └── repositories
│       └── user
│           ├── exceptions
│           │   ├── fetch_user_exception.dart  # Fetch系エラー
│           │   ├── save_user_exception.dart   # Save系エラー
│           │   └── get_user_exception.dart    # 上位層エラー（ラッパー）
│           └── user_repository.dart           # Result型を使った実装例
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
