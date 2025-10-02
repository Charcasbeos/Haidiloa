import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';

abstract class DishState {
  const DishState();
}

class DishInitial extends DishState {}

class CreateDishSuccess extends DishState {
  final String message;
  const CreateDishSuccess(this.message);
}

class CreateDishFailure extends DishState {
  final AppException error;
  const CreateDishFailure(this.error);
}

class UploadImageSuccess extends DishState {
  final String imagePath;
  const UploadImageSuccess(this.imagePath);
}

class UploadImageFailure extends DishState {
  final AppException error;
  const UploadImageFailure(this.error);
}

class DishLoading extends DishState {
  const DishLoading();
}

class GetListDishesSuccess extends DishState {
  final List<DishEntity> listDishesEntity;
  GetListDishesSuccess(this.listDishesEntity);
}

class GetListDishesFailure extends DishState {
  final AppException error;
  GetListDishesFailure(this.error);
}

class DeleteDishSuccess extends DishState {}

class DeleteDishFailure extends DishState {}

class UpdateDishSuccess extends DishState {
  final String message;
  UpdateDishSuccess(this.message);
}

class UpdateDishFailure extends DishState {
  final AppException error;
  UpdateDishFailure(this.error);
}
