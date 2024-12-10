import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_list_query_model.freezed.dart';
part 'post_list_query_model.g.dart';

@freezed
class PostListQueryModel with _$PostListQueryModel {
  const factory PostListQueryModel({
    required PostType type,
    @JsonKey(includeIfNull: false) ItemCategory? category,
  }) = _PostListQueryModel;

  factory PostListQueryModel.fromJson(Map<String, dynamic> json) =>
      _$PostListQueryModelFromJson(json);
}
