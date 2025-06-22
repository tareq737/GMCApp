// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ForPaymentsModel {
  int id;
  String? insert_date;
  String? type;
  String? details;
  String? price;
  ForPaymentsModel({
    required this.id,
    this.insert_date,
    this.type,
    this.details,
    this.price,
  });

  ForPaymentsModel copyWith({
    int? id,
    String? insert_date,
    String? type,
    String? details,
    String? price,
  }) {
    return ForPaymentsModel(
      id: id ?? this.id,
      insert_date: insert_date ?? this.insert_date,
      type: type ?? this.type,
      details: details ?? this.details,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'insert_date': insert_date,
      'type': type,
      'details': details,
      'price': price,
    };
  }

  factory ForPaymentsModel.fromMap(Map<String, dynamic> map) {
    return ForPaymentsModel(
      id: map['id'] as int,
      insert_date:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      details: map['details'] != null ? map['details'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ForPaymentsModel.fromJson(String source) =>
      ForPaymentsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ForPaymentsModel(id: $id, insert_date: $insert_date, type: $type, details: $details, price: $price)';
  }

  @override
  bool operator ==(covariant ForPaymentsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.insert_date == insert_date &&
        other.type == type &&
        other.details == details &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        insert_date.hashCode ^
        type.hashCode ^
        details.hashCode ^
        price.hashCode;
  }
}
