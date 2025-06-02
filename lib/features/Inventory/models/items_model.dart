// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemsModel {
  int id;
  String? code;
  String? name;
  String? unit;
  String? min_limit;
  String? max_limit;
  int? group;
  ItemsModel({
    required this.id,
    this.code,
    this.name,
    this.unit,
    this.min_limit,
    this.max_limit,
    this.group,
  });

  ItemsModel copyWith({
    int? id,
    String? code,
    String? name,
    String? unit,
    String? min_limit,
    String? max_limit,
    int? group,
  }) {
    return ItemsModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      min_limit: min_limit ?? this.min_limit,
      max_limit: max_limit ?? this.max_limit,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'unit': unit,
      'min_limit': min_limit,
      'max_limit': max_limit,
      'group': group,
    };
  }

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    return ItemsModel(
      id: map['id'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      unit: map['unit'] != null ? map['unit'] as String : null,
      min_limit: map['min_limit'] != null ? map['min_limit'] as String : null,
      max_limit: map['max_limit'] != null ? map['max_limit'] as String : null,
      group: map['group'] != null ? map['group'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemsModel.fromJson(String source) =>
      ItemsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemsModel(id: $id, code: $code, name: $name, unit: $unit, min_limit: $min_limit, max_limit: $max_limit, group: $group)';
  }

  @override
  bool operator ==(covariant ItemsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.name == name &&
        other.unit == unit &&
        other.min_limit == min_limit &&
        other.max_limit == max_limit &&
        other.group == group;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        unit.hashCode ^
        min_limit.hashCode ^
        max_limit.hashCode ^
        group.hashCode;
  }
}
