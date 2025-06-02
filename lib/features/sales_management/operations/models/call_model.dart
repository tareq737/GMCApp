// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class CallModel {
  int? id;
  String? date;
  int? customer;
  int? duration;
  String? process_kind;
  String? discussion;
  bool? social_talk;
  bool? bill;
  bool? complaints;
  String? summary;
  String? sales_rep;
  String? connection_type;
  CallModel({
    this.id,
    this.date,
    this.customer,
    this.duration,
    this.process_kind,
    this.discussion,
    this.social_talk,
    this.bill,
    this.complaints,
    this.summary,
    this.sales_rep,
    this.connection_type,
  });

  CallModel copyWith({
    int? id,
    String? date,
    int? customer,
    int? duration,
    String? process_kind,
    String? discussion,
    bool? social_talk,
    bool? bill,
    bool? complaints,
    String? summary,
    String? sales_rep,
    String? connection_type,
  }) {
    return CallModel(
      id: id ?? this.id,
      date: date ?? this.date,
      customer: customer ?? this.customer,
      duration: duration ?? this.duration,
      process_kind: process_kind ?? this.process_kind,
      discussion: discussion ?? this.discussion,
      social_talk: social_talk ?? this.social_talk,
      bill: bill ?? this.bill,
      complaints: complaints ?? this.complaints,
      summary: summary ?? this.summary,
      sales_rep: sales_rep ?? this.sales_rep,
      connection_type: connection_type ?? this.connection_type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'customer': customer,
      'duration': duration,
      'process_kind': process_kind,
      'discussion': discussion,
      'social_talk': social_talk,
      'bill': bill,
      'complaints': complaints,
      'summary': summary,
      'sales_rep': sales_rep,
      'connection_type': connection_type,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      id: map['id'] != null ? map['id'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
      customer: map['customer'] != null ? map['customer'] as int : null,
      duration: map['duration'] != null ? map['duration'] as int : null,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory CallModel.fromJson(String source) =>
      CallModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CallModel(id: $id, date: $date, customer: $customer, duration: $duration, process_kind: $process_kind, discussion: $discussion, social_talk: $social_talk, bill: $bill, complaints: $complaints, summary: $summary, sales_rep: $sales_rep, connection_type: $connection_type)';
  }

  @override
  bool operator ==(covariant CallModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.customer == customer &&
        other.duration == duration &&
        other.process_kind == process_kind &&
        other.discussion == discussion &&
        other.social_talk == social_talk &&
        other.bill == bill &&
        other.complaints == complaints &&
        other.summary == summary &&
        other.sales_rep == sales_rep &&
        other.connection_type == connection_type;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        customer.hashCode ^
        duration.hashCode ^
        process_kind.hashCode ^
        discussion.hashCode ^
        social_talk.hashCode ^
        bill.hashCode ^
        complaints.hashCode ^
        summary.hashCode ^
        sales_rep.hashCode ^
        connection_type.hashCode;
  }
}
