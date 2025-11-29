import 'package:error_handling_from_result_type/data/repositories/user/exceptions/get_user_exception.dart';
import 'package:error_handling_from_result_type/data/repositories/user/providers/user_provider.dart';
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
    final asyncUser = ref.watch(userProvider('123'));
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Repository Demo'),
      ),
      body: Center(
        child: switch (asyncUser) {
          AsyncData(value: final user) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('ID: ${user.id}'),
                Text('Name: ${user.name}'),
                Text('Email: ${user.email}'),
              ],
            ),
          AsyncError(:final error) => Text(
              switch (error) {
                final GetUserException e when e is GetUserFetchException =>
                  'Fetch Error: ${e.cause.message}',
                final GetUserException e when e is GetUserSaveException =>
                  'Save Error: ${e.cause.message}',
                GetUserException() => 'Unknown GetUser Error: $error',
                _ => 'Unexpected Error: $error',
              },
              style: const TextStyle(color: Colors.red),
            ),
          AsyncLoading() => const CircularProgressIndicator(),
        },
      ),
    );
  }
}
