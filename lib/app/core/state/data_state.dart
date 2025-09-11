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
