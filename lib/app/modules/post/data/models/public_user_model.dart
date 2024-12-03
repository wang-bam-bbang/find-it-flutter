import 'package:find_it/app/modules/user/domain/entities/public_user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'public_user_model.freezed.dart';
part 'public_user_model.g.dart';

@freezed
class PublicUserModel with _$PublicUserModel implements PublicUserEntity {
  const factory PublicUserModel({
    required String uuid,
    required String name,
  }) = _PublicUserModel;

  factory PublicUserModel.fromJson(Map<String, dynamic> json) =>
      _$PublicUserModelFromJson(json);
}
