// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Production {
  int? total_productions;
  int? finished_productions;
  int? pending_productions;
  int? productions_oil_based;
  int? productions_acrylic;
  int? productions_water_based;
  int? productions_other;
  int? productions_done_in_3_days;
  int? late_productions;
  int? average_duration_days;
  Production({
    this.total_productions,
    this.finished_productions,
    this.pending_productions,
    this.productions_oil_based,
    this.productions_acrylic,
    this.productions_water_based,
    this.productions_other,
    this.productions_done_in_3_days,
    this.late_productions,
    this.average_duration_days,
  });

  Production copyWith({
    int? total_productions,
    int? finished_productions,
    int? pending_productions,
    int? productions_oil_based,
    int? productions_acrylic,
    int? productions_water_based,
    int? productions_other,
    int? productions_done_in_3_days,
    int? late_productions,
    int? average_duration_days,
  }) {
    return Production(
      total_productions: total_productions ?? this.total_productions,
      finished_productions: finished_productions ?? this.finished_productions,
      pending_productions: pending_productions ?? this.pending_productions,
      productions_oil_based:
          productions_oil_based ?? this.productions_oil_based,
      productions_acrylic: productions_acrylic ?? this.productions_acrylic,
      productions_water_based:
          productions_water_based ?? this.productions_water_based,
      productions_other: productions_other ?? this.productions_other,
      productions_done_in_3_days:
          productions_done_in_3_days ?? this.productions_done_in_3_days,
      late_productions: late_productions ?? this.late_productions,
      average_duration_days:
          average_duration_days ?? this.average_duration_days,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_productions': total_productions,
      'finished_productions': finished_productions,
      'pending_productions': pending_productions,
      'productions_oil_based': productions_oil_based,
      'productions_acrylic': productions_acrylic,
      'productions_water_based': productions_water_based,
      'productions_other': productions_other,
      'productions_done_in_3_days': productions_done_in_3_days,
      'late_productions': late_productions,
      'average_duration_days': average_duration_days,
    };
  }

  factory Production.fromMap(Map<String, dynamic> map) {
    return Production(
      total_productions: map['total_productions'] != null
          ? map['total_productions'] as int
          : null,
      finished_productions: map['finished_productions'] != null
          ? map['finished_productions'] as int
          : null,
      pending_productions: map['pending_productions'] != null
          ? map['pending_productions'] as int
          : null,
      productions_oil_based: map['productions_oil_based'] != null
          ? map['productions_oil_based'] as int
          : null,
      productions_acrylic: map['productions_acrylic'] != null
          ? map['productions_acrylic'] as int
          : null,
      productions_water_based: map['productions_water_based'] != null
          ? map['productions_water_based'] as int
          : null,
      productions_other: map['productions_other'] != null
          ? map['productions_other'] as int
          : null,
      productions_done_in_3_days: map['productions_done_in_3_days'] != null
          ? map['productions_done_in_3_days'] as int
          : null,
      late_productions: map['late_productions'] != null
          ? map['late_productions'] as int
          : null,
      average_duration_days: map['average_duration_days'] != null
          ? map['average_duration_days'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Production.fromJson(String source) =>
      Production.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Production(total_productions: $total_productions, finished_productions: $finished_productions, pending_productions: $pending_productions, productions_oil_based: $productions_oil_based, productions_acrylic: $productions_acrylic, productions_water_based: $productions_water_based, productions_other: $productions_other, productions_done_in_3_days: $productions_done_in_3_days, late_productions: $late_productions, average_duration_days: $average_duration_days)';
  }

  @override
  bool operator ==(covariant Production other) {
    if (identical(this, other)) return true;

    return other.total_productions == total_productions &&
        other.finished_productions == finished_productions &&
        other.pending_productions == pending_productions &&
        other.productions_oil_based == productions_oil_based &&
        other.productions_acrylic == productions_acrylic &&
        other.productions_water_based == productions_water_based &&
        other.productions_other == productions_other &&
        other.productions_done_in_3_days == productions_done_in_3_days &&
        other.late_productions == late_productions &&
        other.average_duration_days == average_duration_days;
  }

  @override
  int get hashCode {
    return total_productions.hashCode ^
        finished_productions.hashCode ^
        pending_productions.hashCode ^
        productions_oil_based.hashCode ^
        productions_acrylic.hashCode ^
        productions_water_based.hashCode ^
        productions_other.hashCode ^
        productions_done_in_3_days.hashCode ^
        late_productions.hashCode ^
        average_duration_days.hashCode;
  }
}
