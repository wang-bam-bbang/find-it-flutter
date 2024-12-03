class UserEntity {
  final String uuid;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.uuid,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}
