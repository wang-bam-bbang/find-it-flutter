import 'package:find_it/app/modules/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> refetchMe();
  Stream<UserEntity?> get me;
}
