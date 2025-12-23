// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoreSizeModel {
  int? large;
  int? medium;
  int? small;
  StoreSizeModel({
    this.large,
    this.medium,
    this.small,
  });

  StoreSizeModel copyWith({
    int? large,
    int? medium,
    int? small,
  }) {
    return StoreSizeModel(
      large: large ?? this.large,
      medium: medium ?? this.medium,
      small: small ?? this.small,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'large': large,
      'medium': medium,
      'small': small,
    };
  }

  factory StoreSizeModel.fromMap(Map<String, dynamic> map) {
    return StoreSizeModel(
      large: map['large'] != null ? map['large'] as int : null,
      medium: map['medium'] != null ? map['medium'] as int : null,
      small: map['small'] != null ? map['small'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreSizeModel.fromJson(String source) =>
      StoreSizeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StoreSizeModel(large: $large, medium: $medium, small: $small)';

  @override
  bool operator ==(covariant StoreSizeModel other) {
    if (identical(this, other)) return true;

    return other.large == large &&
        other.medium == medium &&
        other.small == small;
  }

  @override
  int get hashCode => large.hashCode ^ medium.hashCode ^ small.hashCode;
}
