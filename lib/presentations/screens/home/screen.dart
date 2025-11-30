import 'package:error_handling_from_result_type/core/result/result.dart';
import 'package:error_handling_from_result_type/data/repositories/user/exceptions/fetch_user_exception.dart';
import 'package:error_handling_from_result_type/data/repositories/user/exceptions/get_user_exception.dart';
import 'package:error_handling_from_result_type/data/repositories/user/exceptions/save_user_exception.dart';
import 'package:error_handling_from_result_type/data/repositories/user/providers/user_provider.dart';
import 'package:error_handling_from_result_type/data/repositories/user/providers/user_repository_provider.dart';
import 'package:error_handling_from_result_type/data/repositories/user/providers/user_result_provider.dart';
import 'package:error_handling_from_result_type/data/repositories/user/user_repository.dart';
import 'package:error_handling_from_result_type/domains/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  static const name = 'HomeScreen';
  static const path = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(userProvider('123'));

    final asyncUserResult = ref.watch(userResultProvider('123'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Repository Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              const Text('User Info \n(using AsyncValue<User>)'),
              _AsyncUserInfo(asyncUser),
              const Divider(),
              const Text(
                'User Info '
                '\n(using AsyncValue<Result<User, GetUserException>>>)',
              ),
              _AsyncUserResultInfo(asyncUserResult),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // 新規ユーザー（入力されたユーザーと仮定）
          const newUser = User(
            id: 'generated-id',
            name: 'Steven Gerard',
            email: 'steven.gerard@example.com',
          );

          // ユーザー情報の保存処理を実行
          final repository = ref.read(userRepositoryProvider);
          final result = await repository.saveUser(newUser);

          // 結果に応じてメッセージを表示
          late final String message;
          switch (result) {
            case Success(data: final user):
              message = 'User ${user.name} created successfully!';

            case Failure(error: final error):
              final description = switch (error) {
                SaveUserStorageException() =>
                  '💽 Storage Error: ${error.message}',
                SaveUserPermissionException() =>
                  '✍️ Permission Error: ${error.message}',
                SaveUserUnexpectedException() =>
                  '❓ Unexpected Error: ${error.message}',
              };
              message = 'Error creating user: $description';
          }

          if (context.mounted == false) return;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message)));
        },
      ),
    );
  }
}

class _AsyncUserInfo extends HookWidget {
  const _AsyncUserInfo(this.asyncUser);

  final AsyncValue<User> asyncUser;

  @override
  Widget build(BuildContext context) {
    return switch (asyncUser) {
      AsyncData(value: final user) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID: ${user.id}'),
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
          ],
        ),
      AsyncError(:final error) => switch (error) {
          GetUserFetchException(cause: final cause) => switch (cause) {
              FetchUserNetworkException() => Text(
                  'Network Error: ${cause.message}',
                  style: const TextStyle(color: Colors.orange),
                ),
              FetchUserServerException() => Text(
                  'Server Error: ${cause.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              FetchUserTimeoutException() => Text(
                  'Timeout Error: ${cause.message}',
                  style: const TextStyle(color: Colors.amber),
                ),
              FetchUserUnexpectedException() => Text(
                  'Unexpected Fetch Error: ${cause.message}',
                  style: const TextStyle(color: Colors.grey),
                ),
            },
          GetUserSaveException(cause: final cause) => switch (cause) {
              SaveUserStorageException() => Text(
                  'Storage Error: ${cause.message}',
                  style: const TextStyle(color: Colors.purple),
                ),
              SaveUserPermissionException() => Text(
                  'Permission Error: ${cause.message}',
                  style: const TextStyle(color: Colors.pink),
                ),
              SaveUserUnexpectedException() => Text(
                  'Unexpected Save Error: ${cause.message}',
                  style: const TextStyle(color: Colors.grey),
                ),
            },
          _ => Text(
              'Unexpected Error: $error',
              style: const TextStyle(color: Colors.red),
            ),
        },
      AsyncLoading() => const CircularProgressIndicator(),
    };
  }
}

class _AsyncUserResultInfo extends HookWidget {
  const _AsyncUserResultInfo(this.asyncUser);

  final AsyncValue<GetUserResult> asyncUser;

  @override
  Widget build(BuildContext context) {
    return switch (asyncUser) {
      AsyncData(value: Success(data: final user)) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ID: ${user.id}'),
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
          ],
        ),
      AsyncData(value: Failure(error: final error)) => switch (error) {
          GetUserFetchException(cause: final cause) => switch (cause) {
              FetchUserNetworkException() => Text(
                  'Network Error: ${cause.message}',
                  style: const TextStyle(color: Colors.orange),
                ),
              FetchUserServerException() => Text(
                  'Server Error: ${cause.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              FetchUserTimeoutException() => Text(
                  'Timeout Error: ${cause.message}',
                  style: const TextStyle(color: Colors.amber),
                ),
              FetchUserUnexpectedException() => Text(
                  'Unexpected Fetch Error: ${cause.message}',
                  style: const TextStyle(color: Colors.grey),
                ),
            },
          GetUserSaveException(cause: final cause) => switch (cause) {
              SaveUserStorageException() => Text(
                  'Storage Error: ${cause.message}',
                  style: const TextStyle(color: Colors.purple),
                ),
              SaveUserPermissionException() => Text(
                  'Permission Error: ${cause.message}',
                  style: const TextStyle(color: Colors.pink),
                ),
              SaveUserUnexpectedException() => Text(
                  'Unexpected Save Error: ${cause.message}',
                  style: const TextStyle(color: Colors.grey),
                ),
            },
        },
      AsyncError(:final error) => Text(
          'Unexpected Error: $error',
          style: const TextStyle(color: Colors.red),
        ),
      AsyncLoading() => const CircularProgressIndicator(),
    };
  }
}
