// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class BriefPurchaseModel {
  int id;
  String? insert_date;
  String? department;
  String? type;
  String? details;
  String? last_price;
  bool? manager_check;
  bool? manager2_check;
  bool? received_check;
  bool? archived;
  String? bill;
  int? duration;
  BriefPurchaseModel({
    required this.id,
    this.insert_date,
    this.department,
    this.type,
    this.details,
    this.last_price,
    this.manager_check,
    this.manager2_check,
    this.received_check,
    this.archived,
    this.bill,
    this.duration,
  });

  BriefPurchaseModel copyWith({
    int? id,
    String? insert_date,
    String? department,
    String? type,
    String? details,
    String? last_price,
    bool? manager_check,
    bool? manager2_check,
    bool? received_check,
    bool? archived,
    String? bill,
    int? duration,
  }) {
    return BriefPurchaseModel(
      id: id ?? this.id,
      insert_date: insert_date ?? this.insert_date,
      department: department ?? this.department,
      type: type ?? this.type,
      details: details ?? this.details,
      last_price: last_price ?? this.last_price,
      manager_check: manager_check ?? this.manager_check,
      manager2_check: manager2_check ?? this.manager2_check,
      received_check: received_check ?? this.received_check,
      archived: archived ?? this.archived,
      bill: bill ?? this.bill,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'insert_date': insert_date,
      'department': department,
      'type': type,
      'details': details,
      'last_price': last_price,
      'manager_check': manager_check,
      'manager2_check': manager2_check,
      'received_check': received_check,
      'archived': archived,
      'bill': bill,
      'duration': duration,
    };
  }

  factory BriefPurchaseModel.fromMap(Map<String, dynamic> map) {
    return BriefPurchaseModel(
      id: map['id'] as int,
      insert_date:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      details: map['details'] != null ? map['details'] as String : null,
      last_price:
          map['last_price'] != null ? map['last_price'] as String : null,
      manager_check:
          map['manager_check'] != null ? map['manager_check'] as bool : null,
      manager2_check:
          map['manager2_check'] != null ? map['manager2_check'] as bool : null,
      received_check:
          map['received_check'] != null ? map['received_check'] as bool : null,
      archived: map['archived'] != null ? map['archived'] as bool : null,
      bill: map['bill'] != null ? map['bill'] as String : null,
      duration: map['duration'] != null ? map['duration'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BriefPurchaseModel.fromJson(String source) =>
      BriefPurchaseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BriefPurchaseModel(id: $id, insert_date: $insert_date, department: $department, type: $type, details: $details, last_price: $last_price, manager_check: $manager_check, manager2_check: $manager2_check, received_check: $received_check, archived: $archived, bill: $bill, duration: $duration)';
  }

  @override
  bool operator ==(covariant BriefPurchaseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.insert_date == insert_date &&
        other.department == department &&
        other.type == type &&
        other.details == details &&
        other.last_price == last_price &&
        other.manager_check == manager_check &&
        other.manager2_check == manager2_check &&
        other.received_check == received_check &&
        other.archived == archived &&
        other.bill == bill &&
        other.duration == duration;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        insert_date.hashCode ^
        department.hashCode ^
        type.hashCode ^
        details.hashCode ^
        last_price.hashCode ^
        manager_check.hashCode ^
        manager2_check.hashCode ^
        received_check.hashCode ^
        archived.hashCode ^
        bill.hashCode ^
        duration.hashCode;
  }
}
