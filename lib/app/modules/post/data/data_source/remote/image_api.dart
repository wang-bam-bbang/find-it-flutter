import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'image_api.g.dart';

@injectable
@RestApi(baseUrl: 'image/')
abstract class ImageApi {
  @factoryMethod
  factory ImageApi(Dio dio) = _ImageApi;

  @POST('upload')
  Future<List<String>> uploadImages(@Part() List<File> images);
}
