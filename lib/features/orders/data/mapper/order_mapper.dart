import 'package:haidiloa/features/orders/data/model/order_model.dart';
import 'package:haidiloa/features/orders/domain/entities/order_entity.dart';

class OrderMapper {
  static OrderEntity toOrderEntity(OrderModel orderModel) {
    return OrderEntity(
      billId: orderModel.billId,
      dishId: orderModel.dishId,
      name: orderModel.name,
      imageURL: orderModel.imageURL,
      price: orderModel.price,
      quantity: orderModel.quantity,
      served: orderModel.served,
      createdAt: orderModel.createdAt,
    );
  }

  static List<OrderEntity> toOrdersEntityList(List<OrderModel> models) {
    return models.map((e) => toOrderEntity(e)).toList();
  }

  static OrderModel toOrderModel(OrderEntity orderEntity) {
    return OrderModel(
      billId: orderEntity.billId,
      dishId: orderEntity.dishId,
      name: orderEntity.name,
      imageURL: orderEntity.imageURL,
      price: orderEntity.price,
      quantity: orderEntity.quantity,
      served: orderEntity.served,
      createdAt: orderEntity.createdAt,
    );
  }

  static List<OrderModel> toOrdersModelList(List<OrderEntity> entities) {
    return entities.map((e) => toOrderModel(e)).toList();
  }

  static OrderModel fromJson(Map<String, dynamic> json) {
    return OrderModel(
      billId: json['bill_id'] as int,
      dishId: json['dish_id'] as int,
      name: json['name'] as String,
      imageURL: json['image_url'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      served: json['served'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static Map<String, dynamic> toJson(OrderModel model) {
    return {
      'bill_id': model.billId,
      'dish_id': model.dishId,
      'name': model.name,
      'image_url': model.imageURL,
      'price': model.price,
      'quantity': model.quantity,
      'served': model.served,
    };
  }

  static List<OrderModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<OrderModel> list) {
    return list.map((e) => toJson(e)).toList();
  }
}
