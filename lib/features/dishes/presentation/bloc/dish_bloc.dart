import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/domain/usecase/create_dish_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/upload_image_usecase.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_event.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_state.dart';

class DishBloc extends Bloc<DishEvent, DishState> {
  final CreateDishUsecase _createDishUsecase;
  final UploadImageUsecase _uploadImageUsecase;
  DishBloc(this._createDishUsecase, this._uploadImageUsecase)
    : super(DishInitial()) {
    // ====================
    /// Create Dish
    /// ====================

    on<CreateDishEvent>((event, emit) async {
      emit(DishLoading());

      // upload ảnh
      final resultUploadImage = await _uploadImageUsecase(params: event.data);

      if (resultUploadImage is DataSuccess<String>) {
        final imageUrl = resultUploadImage.data!;

        // tạo DishEntity mới với URL ảnh đã upload
        final dishNew = DishEntity(
          id: event.dishEntity.id,
          name: event.dishEntity.name,
          imageURL: imageUrl,
          description: event.dishEntity.description,
          note: event.dishEntity.note,
          quantity: event.dishEntity.quantity,
          price: event.dishEntity.price,
        );

        // gọi usecase tạo món
        final resultCreate = await _createDishUsecase(params: dishNew);
        if (resultCreate is DataSuccess<void>) {
          emit(CreateDishSuccess("Success create"));
          
        } else {
          emit(CreateDishFailure(UnknownException("Failure create")));
        }
      } else if (resultUploadImage is DataError) {
        emit(UploadImageFailure(resultUploadImage.error!));
      }
    });
  }
}
