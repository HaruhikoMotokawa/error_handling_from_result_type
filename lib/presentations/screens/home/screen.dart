import 'package:error_handling_from_result_type/core/result/result.dart';
import 'package:error_handling_from_result_type/data/repositories/user_repository.dart';
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
                    failure: (error) =>
                        ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $error')),
                    ),
                  );
                }
              },
              child: const Text('Get User'),
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
