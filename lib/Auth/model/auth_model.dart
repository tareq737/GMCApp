// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthModel {
  int User_ID;
  String Username;
  String Password;
  AuthModel({
    required this.User_ID,
    required this.Username,
    required this.Password,
  });

  AuthModel copyWith({
    int? User_ID,
    String? Username,
    String? Password,
  }) {
    return AuthModel(
      User_ID: User_ID ?? this.User_ID,
      Username: Username ?? this.Username,
      Password: Password ?? this.Password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'User_ID': User_ID,
      'Username': Username,
      'Password': Password,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      User_ID: map['User_ID'] as int,
      Username: map['Username'] as String,
      Password: map['Password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthModel(User_ID: $User_ID, Username: $Username, Password: $Password)';

  @override
  bool operator ==(covariant AuthModel other) {
    if (identical(this, other)) return true;

    return other.User_ID == User_ID &&
        other.Username == Username &&
        other.Password == Password;
  }

  @override
  int get hashCode => User_ID.hashCode ^ Username.hashCode ^ Password.hashCode;
}
