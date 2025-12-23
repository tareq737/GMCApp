// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ColorantsTypeModel {
  int? rehongi;
  int? rawae;
  int? gmc;
  int? other;
  int? none;
  ColorantsTypeModel({
    this.rehongi,
    this.rawae,
    this.gmc,
    this.other,
    this.none,
  });

  ColorantsTypeModel copyWith({
    int? rehongi,
    int? rawae,
    int? gmc,
    int? other,
    int? none,
  }) {
    return ColorantsTypeModel(
      rehongi: rehongi ?? this.rehongi,
      rawae: rawae ?? this.rawae,
      gmc: gmc ?? this.gmc,
      other: other ?? this.other,
      none: none ?? this.none,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rehongi': rehongi,
      'rawae': rawae,
      'gmc': gmc,
      'other': other,
      'none': none,
    };
  }

  factory ColorantsTypeModel.fromMap(Map<String, dynamic> map) {
    return ColorantsTypeModel(
      rehongi: map['rehongi'] != null ? map['rehongi'] as int : null,
      rawae: map['rawae'] != null ? map['rawae'] as int : null,
      gmc: map['gmc'] != null ? map['gmc'] as int : null,
      other: map['other'] != null ? map['other'] as int : null,
      none: map['none'] != null ? map['none'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ColorantsTypeModel.fromJson(String source) =>
      ColorantsTypeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ColorantsTypeModel(rehongi: $rehongi, rawae: $rawae, gmc: $gmc, other: $other, none: $none)';
  }

  @override
  bool operator ==(covariant ColorantsTypeModel other) {
    if (identical(this, other)) return true;

    return other.rehongi == rehongi &&
        other.rawae == rawae &&
        other.gmc == gmc &&
        other.other == other &&
        other.none == none;
  }

  @override
  int get hashCode {
    return rehongi.hashCode ^
        rawae.hashCode ^
        gmc.hashCode ^
        other.hashCode ^
        none.hashCode;
  }
}
