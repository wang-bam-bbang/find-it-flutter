import 'package:find_it/app/modules/post/domain/entities/post_creation_entity.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts({required PostType type});
  Future<List<PostEntity>> getMyPosts({required PostType type});
  Future<PostEntity> createPost({required PostCreationEntity post});
}
