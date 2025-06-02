// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RateModel {
  int id;
  String date;
  String time;
  String? usd_buy;
  String? usd_sell;
  String? euro_buy;
  String? euro_sell;
  String? sar_buy;
  String? sar_sell;
  String? aed_buy;
  String? aed_sell;
  String? gold_18;
  String? gold_21;
  String? gold_24;
  String? gold_ounce;
  RateModel({
    required this.id,
    required this.date,
    required this.time,
    this.usd_buy,
    this.usd_sell,
    this.euro_buy,
    this.euro_sell,
    this.sar_buy,
    this.sar_sell,
    this.aed_buy,
    this.aed_sell,
    this.gold_18,
    this.gold_21,
    this.gold_24,
    this.gold_ounce,
  });

  RateModel copyWith({
    int? id,
    String? date,
    String? time,
    String? usd_buy,
    String? usd_sell,
    String? euro_buy,
    String? euro_sell,
    String? sar_buy,
    String? sar_sell,
    String? aed_buy,
    String? aed_sell,
    String? gold_18,
    String? gold_21,
    String? gold_24,
    String? gold_ounce,
  }) {
    return RateModel(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      usd_buy: usd_buy ?? this.usd_buy,
      usd_sell: usd_sell ?? this.usd_sell,
      euro_buy: euro_buy ?? this.euro_buy,
      euro_sell: euro_sell ?? this.euro_sell,
      sar_buy: sar_buy ?? this.sar_buy,
      sar_sell: sar_sell ?? this.sar_sell,
      aed_buy: aed_buy ?? this.aed_buy,
      aed_sell: aed_sell ?? this.aed_sell,
      gold_18: gold_18 ?? this.gold_18,
      gold_21: gold_21 ?? this.gold_21,
      gold_24: gold_24 ?? this.gold_24,
      gold_ounce: gold_ounce ?? this.gold_ounce,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'time': time,
      'usd_buy': usd_buy,
      'usd_sell': usd_sell,
      'euro_buy': euro_buy,
      'euro_sell': euro_sell,
      'sar_buy': sar_buy,
      'sar_sell': sar_sell,
      'aed_buy': aed_buy,
      'aed_sell': aed_sell,
      'gold_18': gold_18,
      'gold_21': gold_21,
      'gold_24': gold_24,
      'gold_ounce': gold_ounce,
    };
  }

  factory RateModel.fromMap(Map<String, dynamic> map) {
    return RateModel(
      id: map['id'] as int,
      date: map['date'] as String,
      time: map['time'] as String,
      usd_buy: map['usd_buy'] != null ? map['usd_buy'] as String : null,
      usd_sell: map['usd_sell'] != null ? map['usd_sell'] as String : null,
      euro_buy: map['euro_buy'] != null ? map['euro_buy'] as String : null,
      euro_sell: map['euro_sell'] != null ? map['euro_sell'] as String : null,
      sar_buy: map['sar_buy'] != null ? map['sar_buy'] as String : null,
      sar_sell: map['sar_sell'] != null ? map['sar_sell'] as String : null,
      aed_buy: map['aed_buy'] != null ? map['aed_buy'] as String : null,
      aed_sell: map['aed_sell'] != null ? map['aed_sell'] as String : null,
      gold_18: map['gold_18'] != null ? map['gold_18'] as String : null,
      gold_21: map['gold_21'] != null ? map['gold_21'] as String : null,
      gold_24: map['gold_24'] != null ? map['gold_24'] as String : null,
      gold_ounce:
          map['gold_ounce'] != null ? map['gold_ounce'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RateModel.fromJson(String source) =>
      RateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RateModel(id: $id, date: $date, time: $time, usd_buy: $usd_buy, usd_sell: $usd_sell, euro_buy: $euro_buy, euro_sell: $euro_sell, sar_buy: $sar_buy, sar_sell: $sar_sell, aed_buy: $aed_buy, aed_sell: $aed_sell, gold_18: $gold_18, gold_21: $gold_21, gold_24: $gold_24, gold_ounce: $gold_ounce)';
  }

  @override
  bool operator ==(covariant RateModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.time == time &&
        other.usd_buy == usd_buy &&
        other.usd_sell == usd_sell &&
        other.euro_buy == euro_buy &&
        other.euro_sell == euro_sell &&
        other.sar_buy == sar_buy &&
        other.sar_sell == sar_sell &&
        other.aed_buy == aed_buy &&
        other.aed_sell == aed_sell &&
        other.gold_18 == gold_18 &&
        other.gold_21 == gold_21 &&
        other.gold_24 == gold_24 &&
        other.gold_ounce == gold_ounce;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        time.hashCode ^
        usd_buy.hashCode ^
        usd_sell.hashCode ^
        euro_buy.hashCode ^
        euro_sell.hashCode ^
        sar_buy.hashCode ^
        sar_sell.hashCode ^
        aed_buy.hashCode ^
        aed_sell.hashCode ^
        gold_18.hashCode ^
        gold_21.hashCode ^
        gold_24.hashCode ^
        gold_ounce.hashCode;
  }
}
