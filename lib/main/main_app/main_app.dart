import 'package:error_handling_from_result_type/core/constants/constants.dart';
import 'package:error_handling_from_result_type/core/router/router.dart';
import 'package:error_handling_from_result_type/presentations/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// アプリの基盤となるウィジェット
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: Constants.appName,
      theme: createThemeData(Constants.baseSeedColor, Brightness.light),
      darkTheme: createThemeData(Constants.baseSeedColor, Brightness.dark),
      supportedLocales: const [Locale('ja')],
      locale: const Locale('ja'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.read(routerProvider),
    );
  }
}
