import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  // 必要な場合はここに初期化を書く
  // shared_preferencesなどのFutureの初期化が必要な場合はここに書く
}
