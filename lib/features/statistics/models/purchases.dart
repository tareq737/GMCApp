// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Purchases {
  int? total_purchases;
  int? purchases_received_true;
  int? purchases_within_7_days;
  int? purchases_received_after_7_days;
  int? purchases_pending;
  Purchases({
    this.total_purchases,
    this.purchases_received_true,
    this.purchases_within_7_days,
    this.purchases_received_after_7_days,
    this.purchases_pending,
  });

  Purchases copyWith({
    int? total_purchases,
    int? purchases_received_true,
    int? purchases_within_7_days,
    int? purchases_received_after_7_days,
    int? purchases_pending,
  }) {
    return Purchases(
      total_purchases: total_purchases ?? this.total_purchases,
      purchases_received_true:
          purchases_received_true ?? this.purchases_received_true,
      purchases_within_7_days:
          purchases_within_7_days ?? this.purchases_within_7_days,
      purchases_received_after_7_days: purchases_received_after_7_days ??
          this.purchases_received_after_7_days,
      purchases_pending: purchases_pending ?? this.purchases_pending,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_purchases': total_purchases,
      'purchases_received_true': purchases_received_true,
      'purchases_within_7_days': purchases_within_7_days,
      'purchases_received_after_7_days': purchases_received_after_7_days,
      'purchases_pending': purchases_pending,
    };
  }

  factory Purchases.fromMap(Map<String, dynamic> map) {
    return Purchases(
      total_purchases:
          map['total_purchases'] != null ? map['total_purchases'] as int : null,
      purchases_received_true: map['purchases_received_true'] != null
          ? map['purchases_received_true'] as int
          : null,
      purchases_within_7_days: map['purchases_within_7_days'] != null
          ? map['purchases_within_7_days'] as int
          : null,
      purchases_received_after_7_days:
          map['purchases_received_after_7_days'] != null
              ? map['purchases_received_after_7_days'] as int
              : null,
      purchases_pending: map['purchases_pending'] != null
          ? map['purchases_pending'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Purchases.fromJson(String source) =>
      Purchases.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Purchases(total_purchases: $total_purchases, purchases_received_true: $purchases_received_true, purchases_within_7_days: $purchases_within_7_days, purchases_received_after_7_days: $purchases_received_after_7_days, purchases_pending: $purchases_pending)';
  }

  @override
  bool operator ==(covariant Purchases other) {
    if (identical(this, other)) return true;

    return other.total_purchases == total_purchases &&
        other.purchases_received_true == purchases_received_true &&
        other.purchases_within_7_days == purchases_within_7_days &&
        other.purchases_received_after_7_days ==
            purchases_received_after_7_days &&
        other.purchases_pending == purchases_pending;
  }

  @override
  int get hashCode {
    return total_purchases.hashCode ^
        purchases_received_true.hashCode ^
        purchases_within_7_days.hashCode ^
        purchases_received_after_7_days.hashCode ^
        purchases_pending.hashCode;
  }
}
