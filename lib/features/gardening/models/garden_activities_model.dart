// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GardenActivitiesModel {
  int? id;
  String? name;
  String? details;
  GardenActivitiesModel({
    this.id,
    this.name,
    this.details,
  });

  GardenActivitiesModel copyWith({
    int? id,
    String? name,
    String? details,
  }) {
    return GardenActivitiesModel(
      id: id ?? this.id,
      name: name ?? this.name,
      details: details ?? this.details,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'details': details,
    };
  }

  factory GardenActivitiesModel.fromMap(Map<String, dynamic> map) {
    return GardenActivitiesModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      details: map['details'] != null ? map['details'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GardenActivitiesModel.fromJson(String source) =>
      GardenActivitiesModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GardenActivitiesModel(id: $id, name: $name, details: $details)';

  @override
  bool operator ==(covariant GardenActivitiesModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.details == details;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ details.hashCode;
}
