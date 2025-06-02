// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GroupsModel {
  int id;
  String? code;
  String? name;
  int? parent;
  GroupsModel({
    required this.id,
    this.code,
    this.name,
    this.parent,
  });

  GroupsModel copyWith({
    int? id,
    String? code,
    String? name,
    int? parent,
  }) {
    return GroupsModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      parent: parent ?? this.parent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'parent': parent,
    };
  }

  factory GroupsModel.fromMap(Map<String, dynamic> map) {
    return GroupsModel(
      id: map['id'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      parent: map['parent'] != null ? map['parent'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupsModel.fromJson(String source) =>
      GroupsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupsModel(id: $id, code: $code, name: $name, parent: $parent)';
  }

  @override
  bool operator ==(covariant GroupsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.name == name &&
        other.parent == parent;
  }

  @override
  int get hashCode {
    return id.hashCode ^ code.hashCode ^ name.hashCode ^ parent.hashCode;
  }
}
