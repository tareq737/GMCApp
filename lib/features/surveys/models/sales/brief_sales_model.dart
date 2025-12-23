// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BriefSalesModel {
  int id;
  String? customer_name;
  String? shop_name;
  String? region_name;
  String? date;
  BriefSalesModel({
    required this.id,
    this.customer_name,
    this.shop_name,
    this.region_name,
    this.date,
  });

  BriefSalesModel copyWith({
    int? id,
    String? customer_name,
    String? shop_name,
    String? region_name,
    String? date,
  }) {
    return BriefSalesModel(
      id: id ?? this.id,
      customer_name: customer_name ?? this.customer_name,
      shop_name: shop_name ?? this.shop_name,
      region_name: region_name ?? this.region_name,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customer_name': customer_name,
      'shop_name': shop_name,
      'region_name': region_name,
      'date': date,
    };
  }

  factory BriefSalesModel.fromMap(Map<String, dynamic> map) {
    return BriefSalesModel(
      id: map['id'] as int,
      customer_name:
          map['customer_name'] != null ? map['customer_name'] as String : null,
      shop_name: map['shop_name'] != null ? map['shop_name'] as String : null,
      region_name:
          map['region_name'] != null ? map['region_name'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BriefSalesModel.fromJson(String source) =>
      BriefSalesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BriefSalesModel(id: $id, customer_name: $customer_name, shop_name: $shop_name, region_name: $region_name, date: $date)';
  }

  @override
  bool operator ==(covariant BriefSalesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.customer_name == customer_name &&
        other.shop_name == shop_name &&
        other.region_name == region_name &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customer_name.hashCode ^
        shop_name.hashCode ^
        region_name.hashCode ^
        date.hashCode;
  }
}
