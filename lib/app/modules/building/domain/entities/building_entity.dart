import 'package:find_it/gen/strings.g.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

abstract class BuildingEntity {
  int get id;
  String get name;
  String get enName;
  String get gps;
  String get code;
}

extension BuildingEntityX on BuildingEntity {
  String get displayName =>
      LocaleSettings.currentLocale == AppLocale.ko ? name : enName;
  GeoPoint? get point {
    try {
      return GeoPoint.fromString(RegExp(r'(\d+\.?\d+)')
          .allMatches(gps)
          .map((i) => i.group(1))
          .join(','));
    } catch (_) {
      return null;
    }
  }
}
