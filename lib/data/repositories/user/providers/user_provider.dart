import 'package:error_handling_from_result_type/core/result/result.dart';
import 'package:error_handling_from_result_type/data/repositories/user/providers/user_repository_provider.dart';
import 'package:error_handling_from_result_type/domains/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

/// 指定されたIDのユーザー情報を取得するプロバイダー
///
/// エラー時はGetUserExceptionをスローする
@riverpod
Future<User> user(Ref ref, String userId) async {
  final userRepository = ref.read(userRepositoryProvider);
  final userResult = await userRepository.getUser_ver2(userId);

  switch (userResult) {
    case Success(data: final user):
      return user;
    case Failure(error: final error):
      throw error;
  }
}
