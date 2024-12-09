import 'package:find_it/app/modules/building/data/models/building_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'building_list_model.freezed.dart';
part 'building_list_model.g.dart';

@freezed
class BuildingListModel with _$BuildingListModel {
  const factory BuildingListModel({
    required List<BuildingModel> list,
  }) = _BuildingListModel;

  factory BuildingListModel.fromJson(Map<String, dynamic> json) =>
      _$BuildingListModelFromJson(json);
}
