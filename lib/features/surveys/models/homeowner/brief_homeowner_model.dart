// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BriefHomeownerModel {
  int id;
  String? visit_date;
  String? visit_time;
  String? region;
  String? store_name;
  String? customer_name;
  BriefHomeownerModel({
    required this.id,
    this.visit_date,
    this.visit_time,
    this.region,
    this.store_name,
    this.customer_name,
  });

  BriefHomeownerModel copyWith({
    int? id,
    String? visit_date,
    String? visit_time,
    String? region,
    String? store_name,
    String? customer_name,
  }) {
    return BriefHomeownerModel(
      id: id ?? this.id,
      visit_date: visit_date ?? this.visit_date,
      visit_time: visit_time ?? this.visit_time,
      region: region ?? this.region,
      store_name: store_name ?? this.store_name,
      customer_name: customer_name ?? this.customer_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visit_date': visit_date,
      'visit_time': visit_time,
      'region': region,
      'store_name': store_name,
      'customer_name': customer_name,
    };
  }

  factory BriefHomeownerModel.fromMap(Map<String, dynamic> map) {
    return BriefHomeownerModel(
      id: map['id'] as int,
      visit_date:
          map['visit_date'] != null ? map['visit_date'] as String : null,
      visit_time:
          map['visit_time'] != null ? map['visit_time'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      store_name:
          map['store_name'] != null ? map['store_name'] as String : null,
      customer_name:
          map['customer_name'] != null ? map['customer_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BriefHomeownerModel.fromJson(String source) =>
      BriefHomeownerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BriefHomeownerModel(id: $id, visit_date: $visit_date, visit_time: $visit_time, region: $region, store_name: $store_name, customer_name: $customer_name)';
  }

  @override
  bool operator ==(covariant BriefHomeownerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.visit_date == visit_date &&
        other.visit_time == visit_time &&
        other.region == region &&
        other.store_name == store_name &&
        other.customer_name == customer_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        visit_date.hashCode ^
        visit_time.hashCode ^
        region.hashCode ^
        store_name.hashCode ^
        customer_name.hashCode;
  }
}
