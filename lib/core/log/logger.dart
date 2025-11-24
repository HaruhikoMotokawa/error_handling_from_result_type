import 'package:logger/web.dart';

/// loggerのインスタンスを生成
final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1, // 表示されるコールスタックの数
    errorMethodCount: 5, // 表示されるスタックトレースのコールスタックの数
    lineLength: 80, // 区切りラインの長さ
    dateTimeFormat: DateTimeFormat.dateAndTime, // タイムスタンプを出力するかどうか
  ),
);
