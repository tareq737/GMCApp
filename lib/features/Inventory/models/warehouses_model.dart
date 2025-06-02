// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WarehousesModel {
  int id;
  String? code;
  String? name;
  WarehousesModel({
    required this.id,
    this.code,
    this.name,
  });

  WarehousesModel copyWith({
    int? id,
    String? code,
    String? name,
  }) {
    return WarehousesModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
    };
  }

  factory WarehousesModel.fromMap(Map<String, dynamic> map) {
    return WarehousesModel(
      id: map['id'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WarehousesModel.fromJson(String source) =>
      WarehousesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WarehousesModel(id: $id, code: $code, name: $name)';

  @override
  bool operator ==(covariant WarehousesModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.code == code && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ code.hashCode ^ name.hashCode;
}
