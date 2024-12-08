import 'package:find_it/app/modules/post/data/models/public_user_model.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_status.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
class PostModel with _$PostModel implements PostEntity {
  const factory PostModel({
    required int id,
    required PostType type,
    required String title,
    required String description,
    required String location,
    required ItemCategory category,
    required PostStatus status,
    required PublicUserModel author,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> images,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}
