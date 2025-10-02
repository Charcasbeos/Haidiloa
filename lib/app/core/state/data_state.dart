import 'package:haidiloa/app/core/network/app_exception.dart';

abstract class DataState<T> {
  final T? data;
  final AppException? error;
  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataError<T> extends DataState<T> {
  const DataError(AppException error) : super(error: error);
}

extension DataStateX<T> on DataState<T> {
  R maybeWhen<R>({
    required R Function() orElse,
    R Function(T data)? data,
    R Function(dynamic error)? error,
  }) {
    if (this is DataSuccess<T>) {
      if (data != null) return data((this as DataSuccess<T>).data!);
    } else if (this is DataError<T>) {
      if (error != null) return error((this as DataError<T>).error);
    }
    return orElse();
  }
}
