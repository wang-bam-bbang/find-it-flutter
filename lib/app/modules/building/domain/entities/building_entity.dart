import 'package:find_it/gen/strings.g.dart';

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
}
