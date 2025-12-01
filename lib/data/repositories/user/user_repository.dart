import 'package:error_handling_from_result_type/core/demo/demo_exceptions.dart';
import 'package:error_handling_from_result_type/core/exceptions/app_exception_type.dart';
import 'package:error_handling_from_result_type/core/result/result.dart';
import 'package:error_handling_from_result_type/data/repositories/user/exceptions/fetch_user_exception.dart';
import 'package:error_handling_from_result_type/data/repositories/user/exceptions/get_user_exception.dart';
import 'package:error_handling_from_result_type/data/repositories/user/exceptions/save_user_exception.dart';
import 'package:error_handling_from_result_type/data/sources/remote/user_remote_data_source.dart';
import 'package:error_handling_from_result_type/domains/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.typedef.dart';

class UserRepository {
  const UserRepository(this.ref);

  final Ref ref;

  UserRemoteDataSource get _remoteDataSource =>
      ref.read(userRemoteDataSourceProvider);

  /// ユーザー情報をローカルに保存する
  Future<SaveUserResult> saveUser(User user) async {
    try {
      // 実際にはSharedPreferencesやIsarなどで保存する想定
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 正常に保存完了
      return Result.success(user);
    } on StorageException {
      return Result.failure(
        SaveUserStorageException(AppExceptionType.saveUserStorage),
      );
    } on PermissionException {
      return Result.failure(
        SaveUserPermissionException(AppExceptionType.saveUserPermission),
      );
    } on Exception {
      return Result.failure(
        SaveUserUnexpectedException(AppExceptionType.saveUserUnexpected),
      );
    }
  }

  /// 指定されたIDのユーザー情報を取得する
  ///
  /// Result型を使ってシンプルに実装したバージョン
  // ignore: non_constant_identifier_names
  Future<GetUserResult> getUser_ver1(String id) async {
    // 1. サーバーから取得
    final fetchResult = await _fetchUserFromServer(id);

    switch (fetchResult) {
      // 2. 取得成功時はローカル保存へ
      case Success(data: final user):
        final saveResult = await saveUser(user);
        return switch (saveResult) {
          // 3. 保存成功時はユーザー情報を返す
          Success(data: final savedUser) => Result.success(savedUser),
          // 4. 保存失敗時はSaveUserExceptionをGetUserSaveExceptionにラップして返す
          Failure(error: final saveError) =>
            Result.failure(GetUserSaveException(saveError)),
        };
      // 5. 取得失敗時はFetchUserExceptionをGetUserFetchExceptionにラップして返す
      case Failure(error: final fetchError):
        return Result.failure(GetUserFetchException(fetchError));
    }
  }

  /// 指定されたIDのユーザー情報を取得する
  ///
  /// Result型を使って、かつif-case文でネストを抑えたバージョン
  // ignore: non_constant_identifier_names
  Future<Result<User, GetUserException>> getUser_ver2(String id) async {
    // 1. サーバーから取得
    final fetchResult = await _fetchUserFromServer(id);

    // 2. 取得失敗時はFetchUserExceptionをGetUserFetchExceptionにラップして返す
    if (fetchResult case Failure(error: final fetchError)) {
      return Result.failure(GetUserFetchException(fetchError));
    }

    // 3. ここに到達した時点でfetchResultはSuccessのはずだが、
    //    コンパイラはそれを認識できないのでキャストが必要
    final user = (fetchResult as Success<User, FetchUserException>).data;
    final saveResult = await saveUser(user);

    // 4. 最後なので通常のswitchで判定
    return switch (saveResult) {
      // 5. 保存成功時はユーザー情報を返す
      Success(data: final savedUser) => Result.success(savedUser),
      // 6. 保存失敗時はSaveUserExceptionをGetUserSaveExceptionにラップして返す
      Failure(error: final saveError) =>
        Result.failure(GetUserSaveException(saveError)),
    };
  }

  /// 指定されたIDのユーザー情報を取得する
  ///
  /// Result型のメソッドを使ってswitchのネストを避けるバージョン
  // ignore: non_constant_identifier_names
  Future<GetUserResult> getUser_ver3(String id) async {
    // 1. サーバーから取得
    final fetchResult = await _fetchUserFromServer(id);

    // 2. FetchUserExceptionをGetUserFetchExceptionにラップ
    final convertedFetch =
        fetchResult.mapError<GetUserException>(GetUserFetchException.new);

    // 3. flatMapでローカル保存する
    return convertedFetch.asyncFlatMap((user) async {
      final saveResult = await saveUser(user);
      return saveResult.mapError<GetUserException>(GetUserSaveException.new);
    });
  }

  /// 指定されたIDのユーザー情報を取得する
  ///
  /// もう少しメソッドチェーンで繋げるバージョン
  // ignore: non_constant_identifier_names
  Future<GetUserResult> getUser_ver4(String id) async {
    // 1. サーバーから取得
    final fetchResult = await _fetchUserFromServer(id);

    // 2. FetchUserExceptionをGetUserFetchExceptionにラップし、
    //    さらにflatMapでローカル保存をチェーンし、SaveUserExceptionもラップ
    return fetchResult
        .mapError<GetUserException>(GetUserFetchException.new)
        .asyncFlatMap((user) async {
      final saveResult = await saveUser(user);
      return saveResult.mapError<GetUserException>(GetUserSaveException.new);
    });
  }

  /// 指定されたIDのユーザー情報を取得する
  ///
  /// 拡張も使って読みやすくしたバージョン
  // ignore: non_constant_identifier_names
  Future<GetUserResult> getUser_ver5(String id) async {
    // 1. サーバーから取得
    final fetchResult = await _fetchUserFromServer(id);

    // 2. FetchUserExceptionをGetUserFetchExceptionにラップし、
    //    さらにflatMapでローカル保存をチェーンし、SaveUserExceptionもラップ
    return fetchResult.toGetUserResult().asyncFlatMap((user) async {
      final saveResult = await saveUser(user);
      return saveResult.toGetUserResult();
    });
  }

  /// 指定されたIDのユーザー情報を取得する
  ///
  /// 究極的に短く書くパターン
  // ignore: non_constant_identifier_names
  Future<GetUserResult> getUser_ver6(String id) async =>
      (await _fetchUserFromServer(id)).toGetUserResult().asyncFlatMap(
            (user) async => (await saveUser(user)).toGetUserResult(),
          );

  /// サーバーからユーザー情報を取得する(プライベートメソッド)
  Future<_FetchUserResult> _fetchUserFromServer(
    String id,
  ) async {
    try {
      final user = await _remoteDataSource.getUser(id);
      return Result.success(user);
    } on NetworkException {
      return Result.failure(
        FetchUserNetworkException(AppExceptionType.fetchUserNetwork),
      );
    } on ServerException {
      return Result.failure(
        FetchUserServerException(AppExceptionType.fetchUserServer),
      );
    } on TimeoutException {
      return Result.failure(
        FetchUserTimeoutException(AppExceptionType.fetchUserTimeout),
      );
    } on Exception {
      return Result.failure(
        FetchUserUnexpectedException(AppExceptionType.fetchUserUnexpected),
      );
    }
  }
}
