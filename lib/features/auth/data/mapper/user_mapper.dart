import 'package:haidiloa/features/auth/data/model/user_model.dart';
import 'package:haidiloa/features/auth/domain/entities/user_entity.dart';

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
}
