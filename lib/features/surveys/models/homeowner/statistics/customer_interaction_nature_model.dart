// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerInteractionNatureModel {
  int? cooperative;
  int? practical;
  int? uncooperative;
  CustomerInteractionNatureModel({
    this.cooperative,
    this.practical,
    this.uncooperative,
  });

  CustomerInteractionNatureModel copyWith({
    int? cooperative,
    int? practical,
    int? uncooperative,
  }) {
    return CustomerInteractionNatureModel(
      cooperative: cooperative ?? this.cooperative,
      practical: practical ?? this.practical,
      uncooperative: uncooperative ?? this.uncooperative,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cooperative': cooperative,
      'practical': practical,
      'uncooperative': uncooperative,
    };
  }

  factory CustomerInteractionNatureModel.fromMap(Map<String, dynamic> map) {
    return CustomerInteractionNatureModel(
      cooperative:
          map['cooperative'] != null ? map['cooperative'] as int : null,
      practical: map['practical'] != null ? map['practical'] as int : null,
      uncooperative:
          map['uncooperative'] != null ? map['uncooperative'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerInteractionNatureModel.fromJson(String source) =>
      CustomerInteractionNatureModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CustomerInteractionNatureModel(cooperative: $cooperative, practical: $practical, uncooperative: $uncooperative)';

  @override
  bool operator ==(covariant CustomerInteractionNatureModel other) {
    if (identical(this, other)) return true;

    return other.cooperative == cooperative &&
        other.practical == practical &&
        other.uncooperative == uncooperative;
  }

  @override
  int get hashCode =>
      cooperative.hashCode ^ practical.hashCode ^ uncooperative.hashCode;
}
