// INFO: ViewModelでStateを保持する場合は以下のコメントアウトを外して生成してください。
// INFO: ViewModel自体が不要であればこのファイごと削除してください。

// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'view_model.freezed.dart';

// @freezed
// class HomeState with _$HomeState {
//   const factory HomeState({
//     @Default('') String title,
//   }) = _HomeState;
// }

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  void build() {}
}
