import 'package:haidiloa/features/bills/data/model/bill_model.dart';
import 'package:haidiloa/features/bills/domain/entities/bill_entity.dart';

class BillMapper {
  static BillEntity toBillEntity(BillModel billModel) {
    return BillEntity(
      id: billModel.id,
      userId: billModel.userId,
      paymented: billModel.paymented,
      tableId: billModel.tableId,
      createdAt: billModel.createdAt,
      requestPayment: billModel.requestPayment,
      total: billModel.total,
    );
  }

  static List<BillEntity> toBillesEntityList(List<BillModel> models) {
    return models.map((e) => toBillEntity(e)).toList();
  }

  static BillModel toBillModel(BillEntity billEntity) {
    return BillModel(
      id: billEntity.id,
      userId: billEntity.userId,
      paymented: billEntity.paymented,
      tableId: billEntity.tableId,
      createdAt: billEntity.createdAt,
      requestPayment: billEntity.requestPayment,
      total: billEntity.total,
    );
  }

  static List<BillModel> toBillesModelList(List<BillEntity> entities) {
    return entities.map((e) => toBillModel(e)).toList();
  }

  static BillModel fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      paymented: json['paymented'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at']),
      tableId: json['table_id'] as int,
      requestPayment: json['request_payment'] as bool? ?? false,
      total: (json['total'] as num).toDouble(),
    );
  }

  static Map<String, dynamic> toJson(BillModel model) {
    return {
      'id': model.id,
      'user_id': model.userId,
      'paymented': model.paymented,
      'created_at': model.createdAt,
      'table_id': model.tableId,
      'request_payment': model.requestPayment,
      'total': model.total,
    };
  }

  static List<BillModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<BillModel> list) {
    return list.map((e) => toJson(e)).toList();
  }
}
