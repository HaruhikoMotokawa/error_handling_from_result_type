import 'package:error_handling_from_result_type/core/constants/constants.dart';
import 'package:error_handling_from_result_type/presentations/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// アプリ全体のローディング画面
class MainAppLoading extends StatelessWidget {
  const MainAppLoading({super.key});

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
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
