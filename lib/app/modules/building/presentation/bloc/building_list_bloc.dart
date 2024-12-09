import 'package:find_it/app/modules/building/domain/entities/building_entity.dart';
import 'package:find_it/app/modules/building/domain/repositories/building_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'building_list_bloc.freezed.dart';

@injectable
class BuildingListBloc extends Bloc<BuildingListEvent, BuildingListState> {
  final BuildingRepository _repository;

  BuildingListBloc(this._repository) : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const _Loading());
      try {
        final posts = await _repository.getBuildingList();
        emit(_Loaded(posts));
      } catch (e) {
        emit(_Error([], e.toString()));
      }
    });
  }
}

@freezed
class BuildingListEvent with _$BuildingListEvent {
  const factory BuildingListEvent.fetch() = _Fetch;
}

@freezed
class BuildingListState with _$BuildingListState {
  const factory BuildingListState.initial(
      [@Default([]) List<BuildingEntity> list]) = _Initial;
  const factory BuildingListState.loading(
      [@Default([]) List<BuildingEntity> list]) = _Loading;
  const factory BuildingListState.loaded(List<BuildingEntity> list) = _Loaded;
  const factory BuildingListState.error(
      List<BuildingEntity> list, String error) = _Error;
}
