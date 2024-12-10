import 'package:find_it/app/modules/post/domain/entities/post_modification_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_status.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_modification_model.freezed.dart';
part 'post_modification_model.g.dart';

@freezed
class PostModificationModel with _$PostModificationModel {
  const factory PostModificationModel({
    required String title,
    required int buildingId,
    required String locationDetail,
    required String description,
    required PostType type,
    required ItemCategory category,
    required PostStatus status,
  }) = _PostModificationModel;

  factory PostModificationModel.fromJson(Map<String, dynamic> json) =>
      _$PostModificationModelFromJson(json);
  factory PostModificationModel.fromEntity(
          {required PostModificationEntity entity}) =>
      PostModificationModel(
        title: entity.title,
        buildingId: entity.building.id,
        locationDetail: entity.locationDetail,
        description: entity.description,
        type: entity.type,
        category: entity.itemType,
        status: entity.status,
      );
}
