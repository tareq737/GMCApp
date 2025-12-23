// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaintApprovalInStoreModel {
  int? primary;
  int? secondary;
  int? on_demand;
  int? not_dealing;
  PaintApprovalInStoreModel({
    this.primary,
    this.secondary,
    this.on_demand,
    this.not_dealing,
  });

  PaintApprovalInStoreModel copyWith({
    int? primary,
    int? secondary,
    int? on_demand,
    int? not_dealing,
  }) {
    return PaintApprovalInStoreModel(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      on_demand: on_demand ?? this.on_demand,
      not_dealing: not_dealing ?? this.not_dealing,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'primary': primary,
      'secondary': secondary,
      'on_demand': on_demand,
      'not_dealing': not_dealing,
    };
  }

  factory PaintApprovalInStoreModel.fromMap(Map<String, dynamic> map) {
    return PaintApprovalInStoreModel(
      primary: map['primary'] != null ? map['primary'] as int : null,
      secondary: map['secondary'] != null ? map['secondary'] as int : null,
      on_demand: map['on_demand'] != null ? map['on_demand'] as int : null,
      not_dealing:
          map['not_dealing'] != null ? map['not_dealing'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaintApprovalInStoreModel.fromJson(String source) =>
      PaintApprovalInStoreModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaintApprovalInStoreModel(primary: $primary, secondary: $secondary, on_demand: $on_demand, not_dealing: $not_dealing)';
  }

  @override
  bool operator ==(covariant PaintApprovalInStoreModel other) {
    if (identical(this, other)) return true;

    return other.primary == primary &&
        other.secondary == secondary &&
        other.on_demand == on_demand &&
        other.not_dealing == not_dealing;
  }

  @override
  int get hashCode {
    return primary.hashCode ^
        secondary.hashCode ^
        on_demand.hashCode ^
        not_dealing.hashCode;
  }
}
