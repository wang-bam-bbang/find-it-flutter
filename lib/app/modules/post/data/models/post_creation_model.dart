import 'package:find_it/app/modules/post/domain/entities/post_creation_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_creation_model.freezed.dart';
part 'post_creation_model.g.dart';

@freezed
class PostCreationModel with _$PostCreationModel {
  const factory PostCreationModel({
    required String title,
    required int buildingId,
    required String description,
    required PostType type,
    required ItemCategory category,
    required List<String> images,
  }) = _PostCreationModel;

  factory PostCreationModel.fromJson(Map<String, dynamic> json) =>
      _$PostCreationModelFromJson(json);
  factory PostCreationModel.fromEntity(
          {required PostCreationEntity entity, required List<String> images}) =>
      PostCreationModel(
        title: entity.title,
        buildingId: entity.building.id,
        description: entity.description,
        type: entity.type,
        category: entity.itemType,
        images: images,
      );
}
