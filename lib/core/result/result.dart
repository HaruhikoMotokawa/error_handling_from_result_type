import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// 処理の成功・失敗を表すResult型
@freezed
sealed class Result<T> with _$Result<T> {
  const Result._();

  /// 成功
  const factory Result.success(T data) = Success<T>;

  /// 失敗
  const factory Result.failure(Exception error) = Failure<T>;

  /// flatMap - 成功時に別のResult処理を実行
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return switch (this) {
      Success(:final data) => () {
          try {
            return transform(data);
          } on Exception catch (e) {
            return Result<R>.failure(e);
          }
        }(),
      Failure(:final error) => Result<R>.failure(error),
    };
  }

  /// asyncFlatMap - 成功時に非同期のResult処理を実行
  Future<Result<R>> asyncFlatMap<R>(
    Future<Result<R>> Function(T data) transform,
  ) async {
    return switch (this) {
      Success(:final data) => () async {
          try {
            return await transform(data);
          } on Exception catch (e) {
            return Result<R>.failure(e);
          }
        }(),
      Failure(:final error) => Future.value(Result<R>.failure(error)),
    };
  }
}
