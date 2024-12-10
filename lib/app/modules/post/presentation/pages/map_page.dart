import 'package:auto_route/auto_route.dart';
import 'package:find_it/app/di/locator.dart';
import 'package:find_it/app/modules/building/domain/entities/building_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:find_it/app/modules/post/presentation/bloc/post_list_bloc.dart';
import 'package:find_it/app/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:intl/intl.dart';

@RoutePage()
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<PostListBloc>()..add(const PostListEvent.fetch(PostType.found)),
      child: const _Layout(),
    );
  }
}

class _Layout extends StatefulWidget {
  const _Layout();

  @override
  State<_Layout> createState() => _LayoutState();
}

class _LayoutState extends State<_Layout> {
  GeoPoint? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<PostListBloc, PostListState>(
          builder: (context, state) => _MapList(
            onClick: (point) => setState(() => _selectedPoint = point),
            points: state.list
                .map((e) => e.building.point)
                .whereType<GeoPoint>()
                .toList(),
          ),
        ),
        DraggableScrollableSheet(
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  BlocBuilder<PostListBloc, PostListState>(
                      builder: (context, state) {
                    final list = state.list
                        .where((e) => e.building.point is GeoPoint)
                        .where((e) => e.building.point == _selectedPoint)
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];

                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              '${item.building.displayName}\n${DateFormat.yMd().format(item.createdAt)}'),
                          isThreeLine: true,
                          onTap: () {
                            DetailRoute(post: item).push(context);
                          },
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MapList extends StatefulWidget {
  const _MapList({required this.points, required this.onClick});
  final List<GeoPoint> points;
  final void Function(GeoPoint) onClick;

  @override
  State<_MapList> createState() => _MapListState();
}

class _MapListState extends State<_MapList> {
  final _controller = MapController.withUserPosition();

  @override
  Widget build(BuildContext context) {
    return OSMFlutter(
      controller: _controller,
      onMapIsReady: (_) {
        for (var point in widget.points) {
          _controller.addMarker(
            point,
            markerIcon: const MarkerIcon(
              icon: Icon(Icons.location_on),
            ),
          );
        }
      },
      onGeoPointClicked: widget.onClick,
      osmOption: const OSMOption(
        zoomOption: ZoomOption(
          initZoom: 16,
          minZoomLevel: 10,
        ),
      ),
    );
  }
}

extension on GeoPoint {
  double distanceTo(GeoPoint point) {
    final x = (point.latitude - latitude) * 111.0;
    final y = (point.longitude - longitude) * 111.0;
    return x * x + y * y;
  }
}
