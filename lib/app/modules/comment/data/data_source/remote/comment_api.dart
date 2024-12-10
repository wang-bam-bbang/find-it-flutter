import 'package:dio/dio.dart';
import 'package:find_it/app/modules/comment/data/models/comment_creation_model.dart';
import 'package:find_it/app/modules/comment/data/models/comment_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'comment_api.g.dart';

@injectable
@RestApi(baseUrl: 'comment/')
abstract class CommentApi {
  @factoryMethod
  factory CommentApi(Dio dio) = _CommentApi;

  @GET('{id}')
  Future<List<CommentModel>> getComments(@Path('id') int postId);

  @POST('')
  Future<CommentModel> createComment(@Body() CommentCreationModel data);

  @DELETE('{id}')
  Future<void> deleteComment(@Path('id') int id);
}
