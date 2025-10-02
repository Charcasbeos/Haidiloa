import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haidiloa/app/core/network/app_exception.dart';
import 'package:haidiloa/app/core/state/data_state.dart';
import 'package:haidiloa/features/dishes/domain/entities/dish_entity.dart';
import 'package:haidiloa/features/dishes/domain/usecase/create_dish_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/delete_dish_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/get_dishes_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/update_dish_usecase.dart';
import 'package:haidiloa/features/dishes/domain/usecase/upload_image_usecase.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_event.dart';
import 'package:haidiloa/features/dishes/presentation/bloc/dish_state.dart';

class DishBloc extends Bloc<DishEvent, DishState> {
  final CreateDishUsecase _createDishUsecase;
  final UpdateDishUsecase _updateDishUsecase;
  final DeleteDishUsecase _deleteDishUsecase;
  final GetDishesUsecase _getDishesUsecase;
  final UploadImageUsecase _uploadImageUsecase;
  DishBloc(
    this._createDishUsecase,
    this._updateDishUsecase,
    this._deleteDishUsecase,
    this._getDishesUsecase,
    this._uploadImageUsecase,
  ) : super(DishInitial()) {
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
    on<UpdateDishEvent>((event, emit) async {
      emit(DishLoading());

      String imageUrl = event.dishEntity.imageURL;

      // Nếu có ảnh mới thì upload
      if (event.data != null) {
        print(event.dishEntity.quantity);
        final resultUploadImage = await _uploadImageUsecase(
          params: event.data!,
        );

        if (resultUploadImage is DataSuccess<String>) {
          imageUrl = resultUploadImage.data!;
        } else if (resultUploadImage is DataError) {
          emit(UploadImageFailure(resultUploadImage.error!));
          return; // thoát không update
        }
      }

      // Tạo DishEntity mới với URL ảnh (cũ hoặc mới)
      final updatedDish = DishEntity(
        id: event.dishEntity.id,
        name: event.dishEntity.name,
        imageURL: imageUrl,
        description: event.dishEntity.description,
        note: event.dishEntity.note,
        quantity: event.dishEntity.quantity,
        price: event.dishEntity.price,
      );

      // Gọi usecase update
      final resultUpdate = await _updateDishUsecase(params: updatedDish);

      if (resultUpdate is DataSuccess<void>) {
        emit(UpdateDishSuccess("Cập nhật thành công"));
        add(GetListDishesEvent());
      } else if (resultUpdate is DataError) {
        emit(UpdateDishFailure(resultUpdate.error!));
      }
    });

    on<GetListDishesEvent>((event, emit) async {
      emit(DishLoading());
      final listDishes = await _getDishesUsecase();
      if (listDishes is DataSuccess<List<DishEntity>>) {
        emit(GetListDishesSuccess(listDishes.data!));
      } else if (listDishes is DataError<List<DishEntity>>) {
        emit(GetListDishesFailure(listDishes.error!));
      }
    });
    on<DeleteDishEvent>((event, emit) async {
      emit(DishLoading());
      final deleteDish = await _deleteDishUsecase(params: event.id);
      if (deleteDish is DataSuccess) {
        final listDishes = await _getDishesUsecase();
        if (listDishes is DataSuccess<List<DishEntity>>) {
          emit(GetListDishesSuccess(listDishes.data!));
        } else if (listDishes is DataError<List<DishEntity>>) {
          emit(GetListDishesFailure(listDishes.error!));
        }
      } else if (deleteDish is DataError<List<DishEntity>>) {
        emit(DeleteDishFailure());
      }
    });
  }
}
