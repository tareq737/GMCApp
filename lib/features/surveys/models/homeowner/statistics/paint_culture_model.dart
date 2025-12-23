// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaintCultureModel {
  int? technical;
  int? aware;
  int? seller;
  PaintCultureModel({
    this.technical,
    this.aware,
    this.seller,
  });

  PaintCultureModel copyWith({
    int? technical,
    int? aware,
    int? seller,
  }) {
    return PaintCultureModel(
      technical: technical ?? this.technical,
      aware: aware ?? this.aware,
      seller: seller ?? this.seller,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'technical': technical,
      'aware': aware,
      'seller': seller,
    };
  }

  factory PaintCultureModel.fromMap(Map<String, dynamic> map) {
    return PaintCultureModel(
      technical: map['technical'] != null ? map['technical'] as int : null,
      aware: map['aware'] != null ? map['aware'] as int : null,
      seller: map['seller'] != null ? map['seller'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaintCultureModel.fromJson(String source) =>
      PaintCultureModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PaintCultureModel(technical: $technical, aware: $aware, seller: $seller)';

  @override
  bool operator ==(covariant PaintCultureModel other) {
    if (identical(this, other)) return true;

    return other.technical == technical &&
        other.aware == aware &&
        other.seller == seller;
  }

  @override
  int get hashCode => technical.hashCode ^ aware.hashCode ^ seller.hashCode;
}
