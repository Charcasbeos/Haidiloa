import 'package:haidiloa/app/core/network/app_exception.dart';

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
