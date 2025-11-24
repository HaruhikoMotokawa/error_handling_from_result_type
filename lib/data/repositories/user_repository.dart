import 'package:error_handling_from_result_type/core/exceptions/app_exception.dart';
import 'package:error_handling_from_result_type/core/result/result.dart';
import 'package:error_handling_from_result_type/data/sources/remote/user_remote_data_source.dart';
import 'package:error_handling_from_result_type/domains/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  return UserRepository(
    remoteDataSource: ref.watch(userRemoteDataSourceProvider),
  );
}

class UserRepository {
  UserRepository({
    required UserRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final UserRemoteDataSource _remoteDataSource;

  /// 指定されたIDのユーザー情報を取得する
  Future<Result<User>> getUser(String id) async {
    // 1. サーバーから取得
    final fetchResult = await _fetchUserFromServer(id);

    // 2. flatMapでローカル保存をチェーン
    return fetchResult.asyncFlatMap((user) async {
      return _saveUserToLocal(user);
    });
  }

  /// サーバーからユーザー情報を取得する（プライベートメソッド）
  Future<Result<User>> _fetchUserFromServer(String id) async {
    try {
      final user = await _remoteDataSource.getUser(id);
      return Result.success(user);
    } on NetworkException catch (e) {
      // ネットワークエラー
      return Result.failure(e);
    } on ServerException catch (e) {
      // サーバーエラー
      return Result.failure(e);
    } on TimeoutException catch (e) {
      // タイムアウトエラー
      return Result.failure(e);
    } on Exception catch (e) {
      // その他の予期しないエラー
      return Result.failure(e);
    }
  }

  /// ユーザー情報をローカルに保存する（プライベートメソッド・仮実装）
  Future<Result<User>> _saveUserToLocal(User user) async {
    try {
      // 実際にはSharedPreferencesやIsarなどで保存する想定
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // 正常に保存完了
      return Result.success(user);
    } on StorageException catch (e) {
      // ストレージ容量不足などのエラー
      return Result.failure(e);
    } on PermissionException catch (e) {
      // 書き込み権限がない場合のエラー
      return Result.failure(e);
    } on Exception catch (e) {
      // その他の予期しないエラー
      return Result.failure(e);
    }
  }
}
