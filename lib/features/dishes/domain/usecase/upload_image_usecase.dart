import 'dart:typed_data';

import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/app/core/usecases/base_usecase.dart';
import 'package:haidiloa/features/dishes/domain/repositories/dish_repository.dart';

class UploadImageUsecase
    implements Usecase<DataState<String>, Uint8List> {
  final DishRepository _dishRepository;
  UploadImageUsecase(this._dishRepository);

  @override
  Future<DataState<String>> call({required Uint8List params}) {
    return _dishRepository.uploadImage(data: params);
  }
}
