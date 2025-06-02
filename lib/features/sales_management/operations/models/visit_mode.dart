// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class VisitModel {
  int? id;
  String? date;
  int? duration;
  String? process_kind;
  String? discussion;
  bool? social_talk;
  bool? business_talk;
  bool? bill;
  bool? complaints;
  String? selling_paints;
  bool? paid_money;
  bool? changes_of_shop;
  String? selling_others;
  String? summary;
  String? sales_rep_1;
  String? sales_rep_2;
  int? customer;
  String? reception;
  VisitModel({
    this.id,
    this.date,
    this.duration,
    this.process_kind,
    this.discussion,
    this.social_talk,
    this.business_talk,
    this.bill,
    this.complaints,
    this.selling_paints,
    this.paid_money,
    this.changes_of_shop,
    this.selling_others,
    this.summary,
    this.sales_rep_1,
    this.sales_rep_2,
    this.customer,
    this.reception,
  });

  VisitModel copyWith({
    int? id,
    String? date,
    int? duration,
    String? process_kind,
    String? discussion,
    bool? social_talk,
    bool? business_talk,
    bool? bill,
    bool? complaints,
    String? selling_paints,
    bool? paid_money,
    bool? changes_of_shop,
    String? selling_others,
    String? summary,
    String? sales_rep_1,
    String? sales_rep_2,
    int? customer,
    String? reception,
  }) {
    return VisitModel(
      id: id ?? this.id,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      process_kind: process_kind ?? this.process_kind,
      discussion: discussion ?? this.discussion,
      social_talk: social_talk ?? this.social_talk,
      business_talk: business_talk ?? this.business_talk,
      bill: bill ?? this.bill,
      complaints: complaints ?? this.complaints,
      selling_paints: selling_paints ?? this.selling_paints,
      paid_money: paid_money ?? this.paid_money,
      changes_of_shop: changes_of_shop ?? this.changes_of_shop,
      selling_others: selling_others ?? this.selling_others,
      summary: summary ?? this.summary,
      sales_rep_1: sales_rep_1 ?? this.sales_rep_1,
      sales_rep_2: sales_rep_2 ?? this.sales_rep_2,
      customer: customer ?? this.customer,
      reception: reception ?? this.reception,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'duration': duration,
      'process_kind': process_kind,
      'discussion': discussion,
      'social_talk': social_talk,
      'business_talk': business_talk,
      'bill': bill,
      'complaints': complaints,
      'selling_paints': selling_paints,
      'paid_money': paid_money,
      'changes_of_shop': changes_of_shop,
      'selling_others': selling_others,
      'summary': summary,
      'sales_rep_1': sales_rep_1,
      'sales_rep_2': sales_rep_2,
      'customer': customer,
      'reception': reception,
    };
  }

  factory VisitModel.fromMap(Map<String, dynamic> map) {
    return VisitModel(
      id: map['id'] != null ? map['id'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
      duration: map['duration'] != null ? map['duration'] as int : null,
      process_kind:
          map['process_kind'] != null ? map['process_kind'] as String : null,
      discussion:
          map['discussion'] != null ? map['discussion'] as String : null,
      social_talk:
          map['social_talk'] != null ? map['social_talk'] as bool : null,
      business_talk:
          map['business_talk'] != null ? map['business_talk'] as bool : null,
      bill: map['bill'] != null ? map['bill'] as bool : null,
      complaints: map['complaints'] != null ? map['complaints'] as bool : null,
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
      summary: map['summary'] != null ? map['summary'] as String : null,
      sales_rep_1:
          map['sales_rep_1'] != null ? map['sales_rep_1'] as String : null,
      sales_rep_2:
          map['sales_rep_2'] != null ? map['sales_rep_2'] as String : null,
      customer: map['customer'] != null ? map['customer'] as int : null,
      reception: map['reception'] != null ? map['reception'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitModel.fromJson(String source) =>
      VisitModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VisitModel(id: $id, date: $date, duration: $duration, process_kind: $process_kind, discussion: $discussion, social_talk: $social_talk, business_talk: $business_talk, bill: $bill, complaints: $complaints, selling_paints: $selling_paints, paid_money: $paid_money, changes_of_shop: $changes_of_shop, selling_others: $selling_others, summary: $summary, sales_rep_1: $sales_rep_1, sales_rep_2: $sales_rep_2, customer: $customer, reception: $reception)';
  }

  @override
  bool operator ==(covariant VisitModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.duration == duration &&
        other.process_kind == process_kind &&
        other.discussion == discussion &&
        other.social_talk == social_talk &&
        other.business_talk == business_talk &&
        other.bill == bill &&
        other.complaints == complaints &&
        other.selling_paints == selling_paints &&
        other.paid_money == paid_money &&
        other.changes_of_shop == changes_of_shop &&
        other.selling_others == selling_others &&
        other.summary == summary &&
        other.sales_rep_1 == sales_rep_1 &&
        other.sales_rep_2 == sales_rep_2 &&
        other.customer == customer &&
        other.reception == reception;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        duration.hashCode ^
        process_kind.hashCode ^
        discussion.hashCode ^
        social_talk.hashCode ^
        business_talk.hashCode ^
        bill.hashCode ^
        complaints.hashCode ^
        selling_paints.hashCode ^
        paid_money.hashCode ^
        changes_of_shop.hashCode ^
        selling_others.hashCode ^
        summary.hashCode ^
        sales_rep_1.hashCode ^
        sales_rep_2.hashCode ^
        customer.hashCode ^
        reception.hashCode;
  }
}
