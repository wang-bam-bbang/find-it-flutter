import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_creation_model.freezed.dart';
part 'post_creation_model.g.dart';

@freezed
class PostCreationModel with _$PostCreationModel {
  const factory PostCreationModel({
    required String title,
    required String location,
    required String description,
    required PostType type,
    required ItemCategory category,
    required List<String> images,
  }) = _PostCreationModel;

  factory PostCreationModel.fromJson(Map<String, dynamic> json) =>
      _$PostCreationModelFromJson(json);
}
