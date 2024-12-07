import 'dart:io';

import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';

class PostCreationEntity {
  final String title;
  final PostType type;
  final String location;
  final ItemCategory itemType;
  final String description;
  final List<File> image;

  PostCreationEntity({
    required this.title,
    required this.type,
    required this.location,
    required this.itemType,
    required this.description,
    required this.image,
  });
}
