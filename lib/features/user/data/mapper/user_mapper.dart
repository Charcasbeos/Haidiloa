import 'package:haidiloa/features/user/data/model/user_model.dart';
import 'package:haidiloa/features/user/domain/entities/user_entity.dart';

class UserMapper {
  static UserEntity toUserEntityFromSupabase(UserModel userModel) {
    return UserEntity(
      id: userModel.id,
      name: userModel.name,
      email: userModel.email,
      phone: userModel.phone,
      birthday: userModel.birthday,
      point: userModel.point,
      role: userModel.role,
    );
  }

  static List<UserEntity> toUserEntityListFromSupabase(List<UserModel> models) {
    return models.map((e) => toUserEntityFromSupabase(e)).toList();
  }

  static UserModel toUserModelFromSupabase(UserEntity userEntity) {
    return UserModel(
      id: userEntity.id,
      name: userEntity.name,
      email: userEntity.email,
      phone: userEntity.phone,
      birthday: userEntity.birthday,
      point: userEntity.point,
      role: userEntity.role,
    );
  }

  static List<UserModel> toUserModelListFromSupabase(
    List<UserEntity> entities,
  ) {
    return entities.map((e) => toUserModelFromSupabase(e)).toList();
  }
}
