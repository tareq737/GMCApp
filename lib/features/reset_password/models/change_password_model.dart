// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChangePasswordModel {
  String? old_password;
  String? new_password;
  ChangePasswordModel({
    this.old_password,
    this.new_password,
  });

  ChangePasswordModel copyWith({
    String? old_password,
    String? new_password,
  }) {
    return ChangePasswordModel(
      old_password: old_password ?? this.old_password,
      new_password: new_password ?? this.new_password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'old_password': old_password,
      'new_password': new_password,
    };
  }

  factory ChangePasswordModel.fromMap(Map<String, dynamic> map) {
    return ChangePasswordModel(
      old_password:
          map['old_password'] != null ? map['old_password'] as String : null,
      new_password:
          map['new_password'] != null ? map['new_password'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangePasswordModel.fromJson(String source) =>
      ChangePasswordModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChangePasswordModel(old_password: $old_password, new_password: $new_password)';

  @override
  bool operator ==(covariant ChangePasswordModel other) {
    if (identical(this, other)) return true;

    return other.old_password == old_password &&
        other.new_password == new_password;
  }

  @override
  int get hashCode => old_password.hashCode ^ new_password.hashCode;
}
