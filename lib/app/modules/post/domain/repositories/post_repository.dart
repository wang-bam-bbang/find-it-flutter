import 'package:find_it/app/modules/post/domain/entities/post_creation_entity.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/entities/post_modification_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts(
      {required PostType type, ItemCategory? category});
  Future<List<PostEntity>> getMyPosts({required PostType type});
  Future<PostEntity> createPost({required PostCreationEntity post});
  Future<PostEntity> modifyPost(
      {required int id, required PostModificationEntity post});
}
