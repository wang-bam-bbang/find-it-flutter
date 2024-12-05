import 'package:find_it/app/modules/post/data/models/post_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_posts_model.freezed.dart';
part 'my_posts_model.g.dart';

@freezed
class MyPostsModel with _$MyPostsModel {
  const factory MyPostsModel({
    required int total,
    required List<PostModel> list,
  }) = _MyPostsModel;

  factory MyPostsModel.fromJson(Map<String, dynamic> json) =>
      _$MyPostsModelFromJson(json);
}
