import 'package:error_handling_from_result_type/core/exceptions/app_exception.dart';
import 'package:error_handling_from_result_type/core/result/result.dart';
import 'package:error_handling_from_result_type/data/sources/remote/user_remote_data_source.dart';
import 'package:error_handling_from_result_type/domains/entities/user.dart';

part 'user_repository.fetch_user_exception.dart';
part 'user_repository.save_user_exception.dart';
part 'user_repository.typedef.dart';

class UserRepository {
  UserRepository({
    required UserRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;
  final UserRemoteDataSource _remoteDataSource;

  /// 指定されたIDのユーザー情報を取得する
  Future<GetUserResult> getUser(String id) async {
    // 1. サーバーから取得
    final fetchResult = await _fetchUserFromServer(id);

    // 2. FetchUserExceptionをGetUserFetchExceptionにラップ
    final convertedFetch =
        fetchResult.mapError<GetUserException>(GetUserFetchException.new);

    // 3. flatMapでローカル保存をチェーンし、SaveUserExceptionもラップ
    return convertedFetch.asyncFlatMap((user) async {
      final saveResult = await _saveUserToLocal(user);
      return saveResult.mapError<GetUserException>(GetUserSaveException.new);
    });
  }

  /// サーバーからユーザー情報を取得する(プライベートメソッド)
  Future<_FetchUserResult> _fetchUserFromServer(
    String id,
  ) async {
    try {
      final user = await _remoteDataSource.getUser(id);
      return Result.success(user);
    } on NetworkException catch (e) {
      return Result.failure(FetchUserNetworkException(e));
    } on ServerException catch (e) {
      return Result.failure(FetchUserServerException(e));
    } on TimeoutException catch (e) {
      return Result.failure(FetchUserTimeoutException(e));
    } on Exception catch (e) {
      return Result.failure(FetchUserUnexpectedException(e));
    }
  }

  /// ユーザー情報をローカルに保存する（プライベートメソッド・仮実装）
  Future<_SaveUserResult> _saveUserToLocal(User user) async {
    try {
      // 実際にはSharedPreferencesやIsarなどで保存する想定
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 正常に保存完了
      return Result.success(user);
    } on StorageException catch (e) {
      return Result.failure(SaveUserStorageException(e));
    } on PermissionException catch (e) {
      return Result.failure(SaveUserPermissionException(e));
    } on Exception catch (e) {
      return Result.failure(SaveUserUnexpectedException(e));
    }
  }
}
