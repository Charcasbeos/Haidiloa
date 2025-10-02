import 'package:haidiloa/features/auth/data/model/auth_model.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';

class AuthMapper {
  static AuthEntity toAuthEntityFromSupabase(AuthModel authModel) {
    return AuthEntity(
      id: authModel.id,
      name: authModel.name,
      email: authModel.email,
      phone: authModel.phone,
      created_at: authModel.created_at,
    );
  }

  static List<AuthEntity> toAuthEntityListFromSupabase(
    List<AuthModel> authModels,
  ) {
    return authModels.map((e) => toAuthEntityFromSupabase(e)).toList();
  }

  static AuthModel toAuthModelFromSupabase(AuthEntity authEntity) {
    return AuthModel(
      id: authEntity.id,
      name: authEntity.name,
      email: authEntity.email,
      phone: authEntity.phone,
      created_at: authEntity.created_at,
    );
  }

  static List<AuthModel> toAuthModelListFromSupabase(
    List<AuthEntity> authEntities,
  ) {
    return authEntities.map((e) => toAuthModelFromSupabase(e)).toList();
  }
}
