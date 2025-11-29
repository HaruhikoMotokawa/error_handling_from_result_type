import 'package:error_handling_from_result_type/core/result/result.dart';
import 'package:error_handling_from_result_type/data/repositories/user/exceptions/get_user_exception.dart';
import 'package:error_handling_from_result_type/data/repositories/user/providers/user_repository_provider.dart';
import 'package:error_handling_from_result_type/domains/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  static const name = 'HomeScreen';
  static const path = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Repository Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final repository = ref.read(userRepositoryProvider);
                final result = await repository.getUser('123');
                if (context.mounted) {
                  result.when(
                    success: (user) => _showUserDialog(context, user),
                    failure: (error) {
                      // エラーの種類に応じてメッセージを表示
                      final message = switch (error) {
                        GetUserFetchException(cause: final fetchError) =>
                          'Fetch error: ${fetchError.runtimeType}',
                        GetUserSaveException(cause: final saveError) =>
                          'Save error: ${saveError.runtimeType}',
                      };
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    },
                  );
                }
              },
              child: const Text('Get User (Success)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final repository = ref.read(userRepositoryProvider);
                // 'network-error' IDでネットワークエラーをシミュレート
                final result = await repository.getUser('network-error');
                if (context.mounted) {
                  result.when(
                    success: (user) => _showUserDialog(context, user),
                    failure: (error) {
                      final message = switch (error) {
                        GetUserFetchException(cause: final fetchError) =>
                          'Fetch error: ${fetchError.runtimeType}',
                        GetUserSaveException(cause: final saveError) =>
                          'Save error: ${saveError.runtimeType}',
                      };
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                }
              },
              child: const Text('Get User (Network Error)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final repository = ref.read(userRepositoryProvider);
                // 'timeout-error' IDでタイムアウトエラーをシミュレート
                final result = await repository.getUser('timeout-error');
                if (context.mounted) {
                  result.when(
                    success: (user) => _showUserDialog(context, user),
                    failure: (error) {
                      final message = switch (error) {
                        GetUserFetchException(cause: final fetchError) =>
                          'Fetch error: ${fetchError.runtimeType}',
                        GetUserSaveException(cause: final saveError) =>
                          'Save error: ${saveError.runtimeType}',
                      };
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  );
                }
              },
              child: const Text('Get User (Timeout Error)'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDialog(BuildContext context, User user) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${user.id}'),
            Text('Name: ${user.name}'),
            Text('Email: ${user.email}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
