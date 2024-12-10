import 'package:find_it/app/modules/post/data/models/post_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_list_model.freezed.dart';
part 'post_list_model.g.dart';

@freezed
class PostListModel with _$PostListModel {
  const factory PostListModel({
    required int total,
    required List<PostModel> list,
    int? nextCursor,
  }) = _PostListModel;

  factory PostListModel.fromJson(Map<String, dynamic> json) =>
      _$PostListModelFromJson(json);
}
