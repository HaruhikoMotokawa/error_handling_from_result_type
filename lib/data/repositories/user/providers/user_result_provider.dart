import 'package:error_handling_from_result_type/data/repositories/user/providers/user_repository_provider.dart';
import 'package:error_handling_from_result_type/data/repositories/user/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_result_provider.g.dart';

/// 指定されたIDのユーザー情報を取得するプロバイダー（Result型を返すバージョン）
@riverpod
Future<GetUserResult> userResult(Ref ref, String userId) async {
  final userRepository = ref.read(userRepositoryProvider);
  final userResult = await userRepository.getUser_ver2(userId);
  return userResult;
}
