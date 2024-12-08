import 'package:find_it/app/modules/post/domain/enums/item_category.dart';
import 'package:find_it/app/modules/post/domain/enums/post_status.dart';
import 'package:find_it/app/modules/post/domain/enums/post_type.dart';
import 'package:find_it/app/modules/user/domain/entities/public_user_entity.dart';

abstract class PostEntity {
  int get id;
  PostType get type;
  String get title;
  String get description;
  String get location;
  ItemCategory get category;
  PostStatus get status;
  PublicUserEntity get author;
  DateTime get createdAt;
  DateTime get updatedAt;
  List<String> get images;
}
