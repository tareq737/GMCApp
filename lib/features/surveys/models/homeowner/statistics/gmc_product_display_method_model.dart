// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GmcProductDisplayMethodModel {
  int? front;
  int? inside_clear;
  int? inside_unclear;
  int? exists_not_visible;
  int? not_available;
  GmcProductDisplayMethodModel({
    this.front,
    this.inside_clear,
    this.inside_unclear,
    this.exists_not_visible,
    this.not_available,
  });

  GmcProductDisplayMethodModel copyWith({
    int? front,
    int? inside_clear,
    int? inside_unclear,
    int? exists_not_visible,
    int? not_available,
  }) {
    return GmcProductDisplayMethodModel(
      front: front ?? this.front,
      inside_clear: inside_clear ?? this.inside_clear,
      inside_unclear: inside_unclear ?? this.inside_unclear,
      exists_not_visible: exists_not_visible ?? this.exists_not_visible,
      not_available: not_available ?? this.not_available,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'front': front,
      'inside_clear': inside_clear,
      'inside_unclear': inside_unclear,
      'exists_not_visible': exists_not_visible,
      'not_available': not_available,
    };
  }

  factory GmcProductDisplayMethodModel.fromMap(Map<String, dynamic> map) {
    return GmcProductDisplayMethodModel(
      front: map['front'] != null ? map['front'] as int : null,
      inside_clear:
          map['inside_clear'] != null ? map['inside_clear'] as int : null,
      inside_unclear:
          map['inside_unclear'] != null ? map['inside_unclear'] as int : null,
      exists_not_visible: map['exists_not_visible'] != null
          ? map['exists_not_visible'] as int
          : null,
      not_available:
          map['not_available'] != null ? map['not_available'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GmcProductDisplayMethodModel.fromJson(String source) =>
      GmcProductDisplayMethodModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GmcProductDisplayMethodModel(front: $front, inside_clear: $inside_clear, inside_unclear: $inside_unclear, exists_not_visible: $exists_not_visible, not_available: $not_available)';
  }

  @override
  bool operator ==(covariant GmcProductDisplayMethodModel other) {
    if (identical(this, other)) return true;

    return other.front == front &&
        other.inside_clear == inside_clear &&
        other.inside_unclear == inside_unclear &&
        other.exists_not_visible == exists_not_visible &&
        other.not_available == not_available;
  }

  @override
  int get hashCode {
    return front.hashCode ^
        inside_clear.hashCode ^
        inside_unclear.hashCode ^
        exists_not_visible.hashCode ^
        not_available.hashCode;
  }
}
