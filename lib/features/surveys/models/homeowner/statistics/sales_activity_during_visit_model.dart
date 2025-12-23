// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SalesActivityDuringVisitModel {
  int? strong;
  int? mid;
  int? weak;
  int? no_activity;
  SalesActivityDuringVisitModel({
    this.strong,
    this.mid,
    this.weak,
    this.no_activity,
  });

  SalesActivityDuringVisitModel copyWith({
    int? strong,
    int? mid,
    int? weak,
    int? no_activity,
  }) {
    return SalesActivityDuringVisitModel(
      strong: strong ?? this.strong,
      mid: mid ?? this.mid,
      weak: weak ?? this.weak,
      no_activity: no_activity ?? this.no_activity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'strong': strong,
      'mid': mid,
      'weak': weak,
      'no_activity': no_activity,
    };
  }

  factory SalesActivityDuringVisitModel.fromMap(Map<String, dynamic> map) {
    return SalesActivityDuringVisitModel(
      strong: map['strong'] != null ? map['strong'] as int : null,
      mid: map['mid'] != null ? map['mid'] as int : null,
      weak: map['weak'] != null ? map['weak'] as int : null,
      no_activity:
          map['no_activity'] != null ? map['no_activity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesActivityDuringVisitModel.fromJson(String source) =>
      SalesActivityDuringVisitModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SalesActivityDuringVisitModel(strong: $strong, mid: $mid, weak: $weak, no_activity: $no_activity)';
  }

  @override
  bool operator ==(covariant SalesActivityDuringVisitModel other) {
    if (identical(this, other)) return true;

    return other.strong == strong &&
        other.mid == mid &&
        other.weak == weak &&
        other.no_activity == no_activity;
  }

  @override
  int get hashCode {
    return strong.hashCode ^
        mid.hashCode ^
        weak.hashCode ^
        no_activity.hashCode;
  }
}
