import 'package:error_handling_from_result_type/data/repositories/user/user_repository.dart';
import 'package:error_handling_from_result_type/data/sources/remote/user_remote_data_source.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository_provider.g.dart';

@riverpod
UserRepository userRepository(Ref ref) => UserRepository(
      remoteDataSource: ref.watch(userRemoteDataSourceProvider),
    );
