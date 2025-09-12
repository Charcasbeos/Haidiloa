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
