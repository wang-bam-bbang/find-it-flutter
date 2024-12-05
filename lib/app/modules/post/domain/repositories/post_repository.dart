import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/content_type.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts({required PostType type});
  Future<List<PostEntity>> getMyPosts({required PostType type});
}
