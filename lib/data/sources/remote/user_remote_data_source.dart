import 'package:error_handling_from_result_type/domains/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_remote_data_source.g.dart';

@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) {
  return UserRemoteDataSource();
}

class UserRemoteDataSource {
  /// ユーザー情報を取得する（仮実装）
  /// 実際にはDioでAPIを呼び出す想定
  Future<User> getUser(String id) async {
    // サーバーからの取得を模擬するために遅延を追加
    await Future<void>.delayed(const Duration(seconds: 1));

    // 仮のデータを返す
    return User(
      id: id,
      name: 'Sample User $id',
      email: 'user$id@example.com',
    );
  }

  /// ユーザー一覧を取得する（仮実装）
  Future<List<User>> getUsers() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    return [
      const User(id: '1', name: 'Alice', email: 'alice@example.com'),
      const User(id: '2', name: 'Bob', email: 'bob@example.com'),
      const User(id: '3', name: 'Charlie', email: 'charlie@example.com'),
    ];
  }
}
