import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// 処理の成功・失敗を表すResult型
@freezed
sealed class Result<T, E extends Exception> with _$Result<T, E> {
  const Result._();

  /// 成功
  const factory Result.success(T data) = Success<T, E>;

  /// 失敗
  const factory Result.failure(E error) = Failure<T, E>;

  /// flatMap - 成功時に別のResult処理を実行
  Result<R, E> flatMap<R>(Result<R, E> Function(T data) transform) {
    return switch (this) {
      Success(:final data) => () {
          try {
            return transform(data);
          } on Exception catch (e) {
            return Result<R, E>.failure(e as E);
          }
        }(),
      Failure(:final error) => Result<R, E>.failure(error),
    };
  }

  /// asyncFlatMap - 成功時に非同期のResult処理を実行
  Future<Result<R, E>> asyncFlatMap<R>(
    Future<Result<R, E>> Function(T data) transform,
  ) async {
    return switch (this) {
      Success(:final data) => () async {
          try {
            return await transform(data);
          } on Exception catch (e) {
            return Result<R, E>.failure(e as E);
          }
        }(),
      Failure(:final error) => Future.value(Result<R, E>.failure(error)),
    };
  }

  /// mapError - エラー型を別の型に変換
  Result<T, E2> mapError<E2 extends Exception>(
    E2 Function(E error) convert,
  ) {
    return switch (this) {
      Success(:final data) => Result<T, E2>.success(data),
      Failure(:final error) => Result<T, E2>.failure(convert(error)),
    };
  }
}
