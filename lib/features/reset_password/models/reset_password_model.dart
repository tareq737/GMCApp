// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResetPasswordModel {
  String? new_password;
  ResetPasswordModel({
    this.new_password,
  });

  ResetPasswordModel copyWith({
    String? new_password,
  }) {
    return ResetPasswordModel(
      new_password: new_password ?? this.new_password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'new_password': new_password,
    };
  }

  factory ResetPasswordModel.fromMap(Map<String, dynamic> map) {
    return ResetPasswordModel(
      new_password:
          map['new_password'] != null ? map['new_password'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResetPasswordModel.fromJson(String source) =>
      ResetPasswordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ResetPasswordModel(new_password: $new_password)';

  @override
  bool operator ==(covariant ResetPasswordModel other) {
    if (identical(this, other)) return true;

    return other.new_password == new_password;
  }

  @override
  int get hashCode => new_password.hashCode;
}
