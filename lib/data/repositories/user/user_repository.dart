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

  /// 指定されたIDのユーザー情報を取得する
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

  /// 指定されたIDのユーザー情報を取得する
  ///
  /// もう少しメソッドチェーンで繋げるバージョン
  // ignore: non_constant_identifier_names
  Future<GetUserResult> getUser_Ver2(String id) async {
    // 1. サーバーから取得
    final fetchResult = await _fetchUserFromServer(id);

    // 2. FetchUserExceptionをGetUserFetchExceptionにラップし、
    //    さらにflatMapでローカル保存をチェーンし、SaveUserExceptionもラップ
    return fetchResult
        .mapError<GetUserException>(GetUserFetchException.new)
        .asyncFlatMap((user) async {
      final saveResult = await _saveUserToLocal(user);
      return saveResult.mapError<GetUserException>(GetUserSaveException.new);
    });
  }

  /// 指定されたIDのユーザー情報を取得する
  ///
  /// 拡張も使って読みやすくしたバージョン
  // ignore: non_constant_identifier_names
  Future<GetUserResult> getUser_Ver3(String id) async {
    // 1. サーバーから取得
    final fetchResult = await _fetchUserFromServer(id);

    // 2. FetchUserExceptionをGetUserFetchExceptionにラップし、
    //    さらにflatMapでローカル保存をチェーンし、SaveUserExceptionもラップ
    return fetchResult.toGetUserResult().asyncFlatMap((user) async {
      final saveResult = await _saveUserToLocal(user);
      return saveResult.toGetUserResult();
    });
  }

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

  /// ユーザー情報をローカルに保存する（プライベートメソッド・仮実装）
  Future<_SaveUserResult> _saveUserToLocal(User user) async {
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
}
