import 'package:dio/dio.dart';
import 'package:find_it/app/modules/post/data/models/my_posts_model.dart';
import 'package:find_it/app/modules/post/data/models/post_creation_model.dart';
import 'package:find_it/app/modules/post/data/models/post_list_model.dart';
import 'package:find_it/app/modules/post/data/models/post_list_query_model.dart';
import 'package:find_it/app/modules/post/data/models/post_model.dart';
import 'package:find_it/app/modules/post/data/models/post_modification_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'post_api.g.dart';

@injectable
@RestApi(baseUrl: 'post/')
abstract class PostApi {
  @factoryMethod
  factory PostApi(Dio dio) = _PostApi;

  @GET('list')
  Future<PostListModel> getPosts(@Queries() PostListQueryModel query);

  @GET('my-posts')
  Future<MyPostsModel> getMyPosts(@Queries() PostListQueryModel query);

  @POST('')
  Future<PostModel> createPost(@Body() PostCreationModel post);

  @PATCH('{id}')
  Future<PostModel> modifyPost(
      @Path('id') int id, @Body() PostModificationModel post);
}
