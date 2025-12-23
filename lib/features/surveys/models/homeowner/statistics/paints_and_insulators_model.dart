// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PaintsAndInsulatorsModel {
  int? paints_only;
  int? insulators_only;
  int? paints_and_insulators;
  PaintsAndInsulatorsModel({
    this.paints_only,
    this.insulators_only,
    this.paints_and_insulators,
  });

  PaintsAndInsulatorsModel copyWith({
    int? paints_only,
    int? insulators_only,
    int? paints_and_insulators,
  }) {
    return PaintsAndInsulatorsModel(
      paints_only: paints_only ?? this.paints_only,
      insulators_only: insulators_only ?? this.insulators_only,
      paints_and_insulators:
          paints_and_insulators ?? this.paints_and_insulators,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paints_only': paints_only,
      'insulators_only': insulators_only,
      'paints_and_insulators': paints_and_insulators,
    };
  }

  factory PaintsAndInsulatorsModel.fromMap(Map<String, dynamic> map) {
    return PaintsAndInsulatorsModel(
      paints_only:
          map['paints_only'] != null ? map['paints_only'] as int : null,
      insulators_only:
          map['insulators_only'] != null ? map['insulators_only'] as int : null,
      paints_and_insulators: map['paints_and_insulators'] != null
          ? map['paints_and_insulators'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaintsAndInsulatorsModel.fromJson(String source) =>
      PaintsAndInsulatorsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PaintsAndInsulatorsModel(paints_only: $paints_only, insulators_only: $insulators_only, paints_and_insulators: $paints_and_insulators)';

  @override
  bool operator ==(covariant PaintsAndInsulatorsModel other) {
    if (identical(this, other)) return true;

    return other.paints_only == paints_only &&
        other.insulators_only == insulators_only &&
        other.paints_and_insulators == paints_and_insulators;
  }

  @override
  int get hashCode =>
      paints_only.hashCode ^
      insulators_only.hashCode ^
      paints_and_insulators.hashCode;
}
