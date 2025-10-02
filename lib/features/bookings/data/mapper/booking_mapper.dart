import 'package:haidiloa/features/bookings/data/model/booking_model.dart';
import 'package:haidiloa/features/bookings/domain/entities/booking_entity.dart';

class BookingMapper {
  static BookingEntity toBookingEntity(BookingModel bookingModel) {
    return BookingEntity(
      id: bookingModel.id,
      phone: bookingModel.phone,
      userId: bookingModel.userId,
      name: bookingModel.name,
      time: bookingModel.time,
      createdAt: bookingModel.createdAt,
      persons: bookingModel.persons,
      tableId: bookingModel.tableId,
      note: bookingModel.note,
      rejectReason: bookingModel.rejectReason,
      status: bookingModel.status,
    );
  }

  static List<BookingEntity> toBookingsEntityList(List<BookingModel> models) {
    return models.map((e) => toBookingEntity(e)).toList();
  }

  static BookingModel toBookingModel(BookingEntity bookingEntity) {
    return BookingModel(
      id: bookingEntity.id,
      phone: bookingEntity.phone,
      userId: bookingEntity.userId,
      name: bookingEntity.name,
      time: bookingEntity.time,
      createdAt: bookingEntity.createdAt,
      persons: bookingEntity.persons,
      tableId: bookingEntity.tableId,
      note: bookingEntity.note,
      rejectReason: bookingEntity.rejectReason,
      status: bookingEntity.status,
    );
  }

  static List<BookingModel> toBookingsModelList(List<BookingEntity> entities) {
    return entities.map((e) => toBookingModel(e)).toList();
  }

  static BookingModel fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      phone: json['phone'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      time: DateTime.parse(json['time']),
      createdAt: DateTime.parse(json['created_at']),
      persons: json['persons'] as int,
      tableId: json['table_id'] ?? 0,
      note: json['note'] ?? "",
      rejectReason: json['reject_reason'] ?? "",
      status: json['status'] as String,
    );
  }

  static List<BookingModel> fromJsonList(List<dynamic> list) {
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }
}
