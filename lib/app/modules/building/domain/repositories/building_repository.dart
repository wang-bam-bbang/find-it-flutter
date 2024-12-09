import 'package:find_it/app/modules/building/domain/entities/building_entity.dart';

abstract class BuildingRepository {
  Future<List<BuildingEntity>> getBuildingList();
}
