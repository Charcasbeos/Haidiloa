import 'dart:typed_data';

import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';

abstract class DishEvent {
  const DishEvent();
}

class CreateDishEvent extends DishEvent {
  final Uint8List data;
  final DishEntity dishEntity;
  CreateDishEvent(this.data, this.dishEntity);
}

class UpdateDishEvent extends DishEvent {
  final Uint8List? data;
  final DishEntity dishEntity;
  UpdateDishEvent(this.data, this.dishEntity);
}

class GetListDishesEvent extends DishEvent {}

class DeleteDishEvent extends DishEvent {
  final int id;
  DeleteDishEvent(this.id);
}
