import 'package:find_it/app/modules/building/domain/entities/building_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'building_model.freezed.dart';
part 'building_model.g.dart';

@freezed
class BuildingModel with _$BuildingModel implements BuildingEntity {
  const factory BuildingModel({
    required int id,
    required String name,
    required String enName,
    required String gps,
    required String code,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BuildingModel;

  factory BuildingModel.fromJson(Map<String, dynamic> json) =>
      _$BuildingModelFromJson(json);
}
