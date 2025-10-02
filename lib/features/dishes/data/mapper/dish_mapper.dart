import 'package:haidiloa/features/dishes/data/model/dish_model.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';

class DishMapper {
  static DishEntity toDishEntity(DishModel dishModel) {
    return DishEntity(
      id: dishModel.id,
      name: dishModel.name,
      imageURL: dishModel.imageURL,
      description: dishModel.description,
      note: dishModel.note,
      quantity: dishModel.quantity,
      price: dishModel.price,
    );
  }

  static List<DishEntity> toDishesEntityList(List<DishModel> models) {
    return models.map((e) => toDishEntity(e)).toList();
  }

  static DishModel toDishModel(DishEntity dishEntity) {
    return DishModel(
      id: dishEntity.id,
      name: dishEntity.name,
      imageURL: dishEntity.imageURL,
      description: dishEntity.description,
      note: dishEntity.note,
      quantity: dishEntity.quantity,
      price: dishEntity.price,
    );
  }

  static List<DishModel> toDishesModelList(List<DishEntity> entities) {
    return entities.map((e) => toDishModel(e)).toList();
  }
}
