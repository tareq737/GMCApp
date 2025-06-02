// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CharModel {
  String date;
  String? usd_sell;
  String? gold_ounce;
  CharModel({
    required this.date,
    required this.usd_sell,
    required this.gold_ounce,
  });

  CharModel copyWith({
    String? date,
    String? usd_sell,
    String? gold_ounce,
  }) {
    return CharModel(
      date: date ?? this.date,
      usd_sell: usd_sell ?? this.usd_sell,
      gold_ounce: gold_ounce ?? this.gold_ounce,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'usd_sell': usd_sell,
      'gold_ounce': gold_ounce,
    };
  }

  factory CharModel.fromMap(Map<String, dynamic> map) {
    return CharModel(
      date: map['date'] as String,
      usd_sell: map['usd_sell'] != null ? map['usd_sell'] as String : null,
      gold_ounce:
          map['gold_ounce'] != null ? map['gold_ounce'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CharModel.fromJson(String source) =>
      CharModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CharModel(date: $date, usd_sell: $usd_sell, gold_ounce: $gold_ounce)';

  @override
  bool operator ==(covariant CharModel other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.usd_sell == usd_sell &&
        other.gold_ounce == gold_ounce;
  }

  @override
  int get hashCode => date.hashCode ^ usd_sell.hashCode ^ gold_ounce.hashCode;
}
