import 'package:find_it/app/modules/user/domain/entities/public_user_entity.dart';

class UserEntity implements PublicUserEntity {
  @override
  final String uuid;
  @override
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.uuid,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}
