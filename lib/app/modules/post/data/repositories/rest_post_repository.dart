import 'package:find_it/app/modules/post/data/data_source/remote/post_api.dart';
import 'package:find_it/app/modules/post/data/models/post_list_query_model.dart';
import 'package:find_it/app/modules/post/domain/entities/post_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/content_type.dart';
import 'package:find_it/app/modules/post/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PostRepository)
class RestPostRepository implements PostRepository {
  final PostApi _api;

  RestPostRepository(this._api);

  @override
  Future<List<PostEntity>> getPosts({required PostType type}) async {
    final result = await _api.getPosts(PostListQueryModel(type: type));
    return result.list;
  }
}
