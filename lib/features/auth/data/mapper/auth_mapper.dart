import 'package:haidiloa/features/auth/data/model/auth_model.dart';
import 'package:haidiloa/features/auth/domain/entities/auth_entity.dart';

class AuthMapper {
  static AuthEntity toAuthEntityFromSupabase(AuthModel authModel) {
    return AuthEntity(
      id: authModel.id,
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
}
