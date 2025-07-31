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

  UserEntity copyWith({
    String? accessToken,
    String? refreshToken,
    String? firstName,
    String? lastName,
    List<String>? groups,
  }) {
    return UserEntity(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      groups: groups ?? this.groups,
    );
  }
}
