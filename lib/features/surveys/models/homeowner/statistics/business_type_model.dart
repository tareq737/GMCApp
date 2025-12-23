// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BusinessTypeModel {
  int? retail;
  int? semi_wholesale;
  int? wholesale;
  BusinessTypeModel({
    this.retail,
    this.semi_wholesale,
    this.wholesale,
  });

  BusinessTypeModel copyWith({
    int? retail,
    int? semi_wholesale,
    int? wholesale,
  }) {
    return BusinessTypeModel(
      retail: retail ?? this.retail,
      semi_wholesale: semi_wholesale ?? this.semi_wholesale,
      wholesale: wholesale ?? this.wholesale,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'retail': retail,
      'semi_wholesale': semi_wholesale,
      'wholesale': wholesale,
    };
  }

  factory BusinessTypeModel.fromMap(Map<String, dynamic> map) {
    return BusinessTypeModel(
      retail: map['retail'] != null ? map['retail'] as int : null,
      semi_wholesale:
          map['semi_wholesale'] != null ? map['semi_wholesale'] as int : null,
      wholesale: map['wholesale'] != null ? map['wholesale'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BusinessTypeModel.fromJson(String source) =>
      BusinessTypeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BusinessTypeModel(retail: $retail, semi_wholesale: $semi_wholesale, wholesale: $wholesale)';

  @override
  bool operator ==(covariant BusinessTypeModel other) {
    if (identical(this, other)) return true;

    return other.retail == retail &&
        other.semi_wholesale == semi_wholesale &&
        other.wholesale == wholesale;
  }

  @override
  int get hashCode =>
      retail.hashCode ^ semi_wholesale.hashCode ^ wholesale.hashCode;
}
