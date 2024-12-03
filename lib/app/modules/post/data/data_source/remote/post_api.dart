import 'package:dio/dio.dart';
import 'package:find_it/app/modules/post/data/models/post_model.dart';
import 'package:retrofit/retrofit.dart';

part 'post_api.g.dart';

@RestApi(baseUrl: 'post/')
abstract class PostApi {
  factory PostApi(Dio dio, {String baseUrl}) = _PostApi;

  @GET('list')
  Future<List<PostModel>> getPosts();
}
