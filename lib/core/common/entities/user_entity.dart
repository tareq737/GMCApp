class UserEntity {
  final String accessToken;
  final String refreshToken;
  final String? firstName;
  final String? lastName;
  final List<String>? groups;

  UserEntity({
    required this.accessToken,
    required this.refreshToken,
    this.firstName,
    this.lastName,
    this.groups,
  });
}
