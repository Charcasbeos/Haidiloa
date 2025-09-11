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
}
