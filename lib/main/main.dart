import 'package:error_handling_from_result_type/main/app_startup/consumer.dart';
import 'package:error_handling_from_result_type/main/main_app/error.dart';
import 'package:error_handling_from_result_type/main/main_app/loading.dart';
import 'package:error_handling_from_result_type/main/main_app/main_app.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// アプリのエントリーポイント
void main() {
  runApp(
    const ProviderScope(
      child: AppStartupConsumer(
        onLoaded: MainApp.new,
        onLoading: MainAppLoading.new,
        onError: MainAppError.new,
      ),
    ),
  );
}
