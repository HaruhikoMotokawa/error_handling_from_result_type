import 'package:error_handling_from_result_type/core/constants/constants.dart';
import 'package:error_handling_from_result_type/core/log/logger.dart';
import 'package:error_handling_from_result_type/presentations/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gap/gap.dart';

/// アプリ全体のエラー画面
class MainAppError extends StatelessWidget {
  const MainAppError(
    this.error,
    this.stackTrace, {
    required this.onRestart,
    super.key,
  });
  final Object error;
  final StackTrace stackTrace;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [Locale('ja')],
      locale: const Locale('ja'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: createThemeData(Constants.baseSeedColor, Brightness.light),
      darkTheme: createThemeData(Constants.baseSeedColor, Brightness.dark),
      home: Scaffold(
        body: Center(
          child: _AppStartErrorWidget(
            error: error,
            stackTrace: stackTrace,
            onRestart: onRestart,
          ),
        ),
      ),
    );
  }
}

class _AppStartErrorWidget extends StatelessWidget {
  const _AppStartErrorWidget({
    required this.error,
    required this.stackTrace,
    required this.onRestart,
  });

  final Object error;
  final StackTrace stackTrace;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 60,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const Gap(16),
        Text(
          'アプリに問題が発生しました',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Gap(24),
        ElevatedButton(
          onPressed: () {
            logger.f('再起動ボタンが押されました');
            onRestart();
          },
          child: Text(
            'アプリを再起動',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
