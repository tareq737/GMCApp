// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerBriefModel {
  int id;
  String? customerName;
  String? shopName;
  String? governate;
  String? region;
  String? shopCoordinates;
  String? address;
  CustomerBriefModel({
    required this.id,
    this.customerName,
    this.shopName,
    this.governate,
    this.region,
    this.shopCoordinates,
    this.address,
  });

  CustomerBriefModel copyWith({
    int? id,
    String? customerName,
    String? shopName,
    String? governate,
    String? region,
    String? shopCoordinates,
    String? address,
  }) {
    return CustomerBriefModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      shopName: shopName ?? this.shopName,
      governate: governate ?? this.governate,
      region: region ?? this.region,
      shopCoordinates: shopCoordinates ?? this.shopCoordinates,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'customer_name': customerName,
      'shop_name': shopName,
      'governate': governate,
      'region': region,
      'shop_coordinates': shopCoordinates,
      'address': address,
    };
  }

  factory CustomerBriefModel.fromMap(Map<String, dynamic> map) {
    return CustomerBriefModel(
      id: map['id'] as int,
      customerName:
          map['customer_name'] != null ? map['customer_name'] as String : null,
      shopName: map['shop_name'] != null ? map['shop_name'] as String : null,
      governate: map['governate'] != null ? map['governate'] as String : null,
      region: map['region'] != null ? map['region'] as String : null,
      shopCoordinates: map['shop_coordinates'] != null
          ? map['shop_coordinates'] as String
          : null,
      address: map['address'] != null ? map['address'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerBriefModel.fromJson(String source) =>
      CustomerBriefModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CustomerBriefModel(id: $id, customerName: $customerName, shopName: $shopName, governate: $governate, region: $region, shopCoordinates: $shopCoordinates, address: $address)';
  }

  @override
  bool operator ==(covariant CustomerBriefModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.customerName == customerName &&
        other.shopName == shopName &&
        other.governate == governate &&
        other.region == region &&
        other.shopCoordinates == shopCoordinates &&
        other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerName.hashCode ^
        shopName.hashCode ^
        governate.hashCode ^
        region.hashCode ^
        shopCoordinates.hashCode ^
        address.hashCode;
  }
}
