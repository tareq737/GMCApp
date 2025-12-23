// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RecommendedPaintQualityModel {
  int? premium;
  int? medium;
  int? economy;
  int? undefined;
  RecommendedPaintQualityModel({
    this.premium,
    this.medium,
    this.economy,
    this.undefined,
  });

  RecommendedPaintQualityModel copyWith({
    int? premium,
    int? medium,
    int? economy,
    int? undefined,
  }) {
    return RecommendedPaintQualityModel(
      premium: premium ?? this.premium,
      medium: medium ?? this.medium,
      economy: economy ?? this.economy,
      undefined: undefined ?? this.undefined,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'premium': premium,
      'medium': medium,
      'economy': economy,
      'undefined': undefined,
    };
  }

  factory RecommendedPaintQualityModel.fromMap(Map<String, dynamic> map) {
    return RecommendedPaintQualityModel(
      premium: map['premium'] != null ? map['premium'] as int : null,
      medium: map['medium'] != null ? map['medium'] as int : null,
      economy: map['economy'] != null ? map['economy'] as int : null,
      undefined: map['undefined'] != null ? map['undefined'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecommendedPaintQualityModel.fromJson(String source) =>
      RecommendedPaintQualityModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RecommendedPaintQualityModel(premium: $premium, medium: $medium, economy: $economy, undefined: $undefined)';
  }

  @override
  bool operator ==(covariant RecommendedPaintQualityModel other) {
    if (identical(this, other)) return true;

    return other.premium == premium &&
        other.medium == medium &&
        other.economy == economy &&
        other.undefined == undefined;
  }

  @override
  int get hashCode {
    return premium.hashCode ^
        medium.hashCode ^
        economy.hashCode ^
        undefined.hashCode;
  }
}
