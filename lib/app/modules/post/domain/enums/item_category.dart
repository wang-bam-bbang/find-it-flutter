import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum ItemCategory {
  electronics,
  card,
  clothing,
  bag,
  wallet,
  accessories,
  document,
  etc,
}
