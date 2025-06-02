// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class OperationsModel {
  int? id;
  String? type;
  String? date;
  String? duration;
  int? customer;
  String? process_kind;
  String? discussion;
  bool? social_talk;
  bool? bill;
  bool? complaints;
  String? summary;
  String? sales_rep;
  String? connection_type;
  bool? business_talk;
  String? selling_paints;
  bool? paid_money;
  bool? changes_of_shop;
  String? selling_others;
  String? sales_rep_1;
  String? sales_rep_2;
  String? reception;
  String? customer_name;
  String? shop_name;

  OperationsModel({
    this.id,
    this.type,
    this.date,
    this.duration,
    this.customer,
    this.process_kind,
    this.discussion,
    this.social_talk,
    this.bill,
    this.complaints,
    this.summary,
    this.sales_rep,
    this.connection_type,
    this.business_talk,
    this.selling_paints,
    this.paid_money,
    this.changes_of_shop,
    this.selling_others,
    this.sales_rep_1,
    this.sales_rep_2,
    this.reception,
    this.customer_name,
    this.shop_name,
  });

  OperationsModel copyWith({
    int? id,
    String? type,
    String? date,
    String? duration,
    int? customer,
    String? process_kind,
    String? discussion,
    bool? social_talk,
    bool? bill,
    bool? complaints,
    String? summary,
    String? sales_rep,
    String? connection_type,
    bool? business_talk,
    String? selling_paints,
    bool? paid_money,
    bool? changes_of_shop,
    String? selling_others,
    String? sales_rep_1,
    String? sales_rep_2,
    String? reception,
    String? customer_name,
    String? shop_name,
  }) {
    return OperationsModel(
      id: id ?? this.id,
      type: type ?? this.type,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      customer: customer ?? this.customer,
      process_kind: process_kind ?? this.process_kind,
      discussion: discussion ?? this.discussion,
      social_talk: social_talk ?? this.social_talk,
      bill: bill ?? this.bill,
      complaints: complaints ?? this.complaints,
      summary: summary ?? this.summary,
      sales_rep: sales_rep ?? this.sales_rep,
      connection_type: connection_type ?? this.connection_type,
      business_talk: business_talk ?? this.business_talk,
      selling_paints: selling_paints ?? this.selling_paints,
      paid_money: paid_money ?? this.paid_money,
      changes_of_shop: changes_of_shop ?? this.changes_of_shop,
      selling_others: selling_others ?? this.selling_others,
      sales_rep_1: sales_rep_1 ?? this.sales_rep_1,
      sales_rep_2: sales_rep_2 ?? this.sales_rep_2,
      reception: reception ?? this.reception,
      customer_name: customer_name ?? this.customer_name,
      shop_name: shop_name ?? this.shop_name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'date': date,
      'duration': duration,
      'customer': customer,
      'process_kind': process_kind,
      'discussion': discussion,
      'social_talk': social_talk,
      'bill': bill,
      'complaints': complaints,
      'summary': summary,
      'sales_rep': sales_rep,
      'connection_type': connection_type,
      'business_talk': business_talk,
      'selling_paints': selling_paints,
      'paid_money': paid_money,
      'changes_of_shop': changes_of_shop,
      'selling_others': selling_others,
      'sales_rep_1': sales_rep_1,
      'sales_rep_2': sales_rep_2,
      'reception': reception,
      'customer_name': customer_name,
      'shop_name': shop_name,
    };
  }

  factory OperationsModel.fromMap(Map<String, dynamic> map) {
    return OperationsModel(
      id: map['id'] != null ? map['id'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      duration: map['duration'] != null ? map['duration'] as String : null,
      customer: map['customer'] != null ? map['customer'] as int : null,
      process_kind:
          map['process_kind'] != null ? map['process_kind'] as String : null,
      discussion:
          map['discussion'] != null ? map['discussion'] as String : null,
      social_talk:
          map['social_talk'] != null ? map['social_talk'] as bool : null,
      bill: map['bill'] != null ? map['bill'] as bool : null,
      complaints: map['complaints'] != null ? map['complaints'] as bool : null,
      summary: map['summary'] != null ? map['summary'] as String : null,
      sales_rep: map['sales_rep'] != null ? map['sales_rep'] as String : null,
      connection_type: map['connection_type'] != null
          ? map['connection_type'] as String
          : null,
      business_talk:
          map['business_talk'] != null ? map['business_talk'] as bool : null,
      selling_paints: map['selling_paints'] != null
          ? map['selling_paints'] as String
          : null,
      paid_money: map['paid_money'] != null ? map['paid_money'] as bool : null,
      changes_of_shop: map['changes_of_shop'] != null
          ? map['changes_of_shop'] as bool
          : null,
      selling_others: map['selling_others'] != null
          ? map['selling_others'] as String
          : null,
      sales_rep_1:
          map['sales_rep_1'] != null ? map['sales_rep_1'] as String : null,
      sales_rep_2:
          map['sales_rep_2'] != null ? map['sales_rep_2'] as String : null,
      reception: map['reception'] != null ? map['reception'] as String : null,
      customer_name:
          map['customer_name'] != null ? map['customer_name'] as String : null,
      shop_name: map['shop_name'] != null ? map['shop_name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OperationsModel.fromJson(String source) =>
      OperationsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OperationsModel(id: $id, type: $type, date: $date, duration: $duration, customer: $customer, process_kind: $process_kind, discussion: $discussion, social_talk: $social_talk, bill: $bill, complaints: $complaints, summary: $summary, sales_rep: $sales_rep, connection_type: $connection_type, business_talk: $business_talk, selling_paints: $selling_paints, paid_money: $paid_money, changes_of_shop: $changes_of_shop, selling_others: $selling_others, sales_rep_1: $sales_rep_1, sales_rep_2: $sales_rep_2, reception: $reception, customer_name: $customer_name, shop_name: $shop_name)';
  }

  @override
  bool operator ==(covariant OperationsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.date == date &&
        other.duration == duration &&
        other.customer == customer &&
        other.process_kind == process_kind &&
        other.discussion == discussion &&
        other.social_talk == social_talk &&
        other.bill == bill &&
        other.complaints == complaints &&
        other.summary == summary &&
        other.sales_rep == sales_rep &&
        other.connection_type == connection_type &&
        other.business_talk == business_talk &&
        other.selling_paints == selling_paints &&
        other.paid_money == paid_money &&
        other.changes_of_shop == changes_of_shop &&
        other.selling_others == selling_others &&
        other.sales_rep_1 == sales_rep_1 &&
        other.sales_rep_2 == sales_rep_2 &&
        other.reception == reception &&
        other.customer_name == customer_name &&
        other.shop_name == shop_name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        date.hashCode ^
        duration.hashCode ^
        customer.hashCode ^
        process_kind.hashCode ^
        discussion.hashCode ^
        social_talk.hashCode ^
        bill.hashCode ^
        complaints.hashCode ^
        summary.hashCode ^
        sales_rep.hashCode ^
        connection_type.hashCode ^
        business_talk.hashCode ^
        selling_paints.hashCode ^
        paid_money.hashCode ^
        changes_of_shop.hashCode ^
        selling_others.hashCode ^
        sales_rep_1.hashCode ^
        sales_rep_2.hashCode ^
        reception.hashCode ^
        customer_name.hashCode ^
        shop_name.hashCode;
  }
}
