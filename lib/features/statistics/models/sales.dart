// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Sales {
  int? total_visits;
  int? visits_with_bill;
  int? visits_with_paid_money;
  int? reception_great;
  int? reception_good;
  int? reception_normal;
  int? reception_bad;
  int? reception_unavailable;
  int? reception_closed;
  Sales({
    this.total_visits,
    this.visits_with_bill,
    this.visits_with_paid_money,
    this.reception_great,
    this.reception_good,
    this.reception_normal,
    this.reception_bad,
    this.reception_unavailable,
    this.reception_closed,
  });

  Sales copyWith({
    int? total_visits,
    int? visits_with_bill,
    int? visits_with_paid_money,
    int? reception_great,
    int? reception_good,
    int? reception_normal,
    int? reception_bad,
    int? reception_unavailable,
    int? reception_closed,
  }) {
    return Sales(
      total_visits: total_visits ?? this.total_visits,
      visits_with_bill: visits_with_bill ?? this.visits_with_bill,
      visits_with_paid_money:
          visits_with_paid_money ?? this.visits_with_paid_money,
      reception_great: reception_great ?? this.reception_great,
      reception_good: reception_good ?? this.reception_good,
      reception_normal: reception_normal ?? this.reception_normal,
      reception_bad: reception_bad ?? this.reception_bad,
      reception_unavailable:
          reception_unavailable ?? this.reception_unavailable,
      reception_closed: reception_closed ?? this.reception_closed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_visits': total_visits,
      'visits_with_bill': visits_with_bill,
      'visits_with_paid_money': visits_with_paid_money,
      'reception_great': reception_great,
      'reception_good': reception_good,
      'reception_normal': reception_normal,
      'reception_bad': reception_bad,
      'reception_unavailable': reception_unavailable,
      'reception_closed': reception_closed,
    };
  }

  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      total_visits:
          map['total_visits'] != null ? map['total_visits'] as int : null,
      visits_with_bill: map['visits_with_bill'] != null
          ? map['visits_with_bill'] as int
          : null,
      visits_with_paid_money: map['visits_with_paid_money'] != null
          ? map['visits_with_paid_money'] as int
          : null,
      reception_great:
          map['reception_great'] != null ? map['reception_great'] as int : null,
      reception_good:
          map['reception_good'] != null ? map['reception_good'] as int : null,
      reception_normal: map['reception_normal'] != null
          ? map['reception_normal'] as int
          : null,
      reception_bad:
          map['reception_bad'] != null ? map['reception_bad'] as int : null,
      reception_unavailable: map['reception_unavailable'] != null
          ? map['reception_unavailable'] as int
          : null,
      reception_closed: map['reception_closed'] != null
          ? map['reception_closed'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sales.fromJson(String source) =>
      Sales.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sales(total_visits: $total_visits, visits_with_bill: $visits_with_bill, visits_with_paid_money: $visits_with_paid_money, reception_great: $reception_great, reception_good: $reception_good, reception_normal: $reception_normal, reception_bad: $reception_bad, reception_unavailable: $reception_unavailable, reception_closed: $reception_closed)';
  }

  @override
  bool operator ==(covariant Sales other) {
    if (identical(this, other)) return true;

    return other.total_visits == total_visits &&
        other.visits_with_bill == visits_with_bill &&
        other.visits_with_paid_money == visits_with_paid_money &&
        other.reception_great == reception_great &&
        other.reception_good == reception_good &&
        other.reception_normal == reception_normal &&
        other.reception_bad == reception_bad &&
        other.reception_unavailable == reception_unavailable &&
        other.reception_closed == reception_closed;
  }

  @override
  int get hashCode {
    return total_visits.hashCode ^
        visits_with_bill.hashCode ^
        visits_with_paid_money.hashCode ^
        reception_great.hashCode ^
        reception_good.hashCode ^
        reception_normal.hashCode ^
        reception_bad.hashCode ^
        reception_unavailable.hashCode ^
        reception_closed.hashCode;
  }
}
