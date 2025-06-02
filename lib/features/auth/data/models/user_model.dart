import 'package:gmcappclean/core/common/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.accessToken,
    required super.refreshToken,
    super.firstName,
    super.lastName,
    super.groups,
  });

  Map<String, dynamic> toMap() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
      'first_name': firstName,
      'last_name': lastName,
      'groups': groups,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    List groupsList = map['groups'];
    return UserModel(
      accessToken: map['access'],
      refreshToken: map['refresh'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      groups: List.generate(groupsList.length, (index) => groupsList[index].toString()),
    );
  }
}
