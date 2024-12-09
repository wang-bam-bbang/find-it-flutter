import 'package:find_it/app/modules/building/data/data_source/remote/building_api.dart';
import 'package:find_it/app/modules/building/domain/entities/building_entity.dart';
import 'package:find_it/app/modules/building/domain/repositories/building_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BuildingRepository)
class RestBuildingRepository implements BuildingRepository {
  final BuildingApi _api;

  RestBuildingRepository(
    this._api,
  );

  @override
  Future<List<BuildingEntity>> getBuildingList() async {
    final result = await _api.getBuildingList();
    return result;
  }
}
