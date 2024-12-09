import 'package:dio/dio.dart';
import 'package:find_it/app/modules/building/data/models/building_model.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'building_api.g.dart';

@injectable
@RestApi(baseUrl: 'building/')
abstract class BuildingApi {
  @factoryMethod
  factory BuildingApi(Dio dio) = _BuildingApi;

  @GET('')
  Future<List<BuildingModel>> getBuildingList();
}
