import 'package:dio/dio.dart';
import 'package:find_it/app/modules/user/data/data_sources/models/token_model.dart';
import 'package:find_it/app/modules/user/data/data_sources/remote/authorize_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'user_api.g.dart';

@injectable
@RestApi(baseUrl: 'user/')
abstract class UserApi {
  @factoryMethod
  factory UserApi(Dio dio) = _UserApi;

  @GET('callback')
  Future<String> login(
    @Query('code') String code,
  );

  @POST('refresh')
  @Extra({AuthorizeInterceptor.retriedKey: true})
  Future<TokenModel> refresh();
}
