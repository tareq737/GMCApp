// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaintersModel {
  int id;
  String? painter_name;
  String? mobile_number;
  String? region;
  PaintersModel({
    required this.id,
    this.painter_name,
    this.mobile_number,
    this.region,
  });

  PaintersModel copyWith({
    int? id,
    String? painter_name,
    String? mobile_number,
    String? region,
  }) {
    return PaintersModel(
      id: id ?? this.id,
      painter_name: painter_name ?? this.painter_name,
      mobile_number: mobile_number ?? this.mobile_number,
      region: region ?? this.region,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'painter_name': painter_name,
      'mobile_number': mobile_number,
      'region': region,
    };
  }

  factory PaintersModel.fromMap(Map<String, dynamic> map) {
    return PaintersModel(
      id: map['id'] as int,
      painter_name:
          map['painter_name'] != null ? map['painter_name'] as String : null,
      mobile_number:
          map['mobile_number'] != null ? map['mobile_number'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaintersModel.fromJson(String source) =>
      PaintersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaintersModel(id: $id, painter_name: $painter_name, mobile_number: $mobile_number, region: $region)';
  }

  @override
  bool operator ==(covariant PaintersModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.painter_name == painter_name &&
        other.mobile_number == mobile_number &&
        other.region == region;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        painter_name.hashCode ^
        mobile_number.hashCode ^
        region.hashCode;
  }
}
