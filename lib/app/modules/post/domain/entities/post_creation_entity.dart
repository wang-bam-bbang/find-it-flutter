import 'dart:io';

import 'package:find_it/app/modules/building/domain/entities/building_entity.dart';
import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';

class PostCreationEntity {
  final String title;
  final PostType type;
  final BuildingEntity building;
  final ItemCategory itemType;
  final String description;
  final List<File> image;

  PostCreationEntity({
    required this.title,
    required this.type,
    required this.building,
    required this.itemType,
    required this.description,
    required this.image,
  });
}
