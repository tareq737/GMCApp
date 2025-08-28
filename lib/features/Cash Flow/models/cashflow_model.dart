// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CashflowModel {
  String? date;
  String? note;
  String? reciept_number;
  String? inflow;
  String? outflow;
  String? balance;
  CashflowModel({
    this.date,
    this.note,
    this.reciept_number,
    this.inflow,
    this.outflow,
    this.balance,
  });

  CashflowModel copyWith({
    String? date,
    String? note,
    String? reciept_number,
    String? inflow,
    String? outflow,
    String? balance,
  }) {
    return CashflowModel(
      date: date ?? this.date,
      note: note ?? this.note,
      reciept_number: reciept_number ?? this.reciept_number,
      inflow: inflow ?? this.inflow,
      outflow: outflow ?? this.outflow,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'note': note,
      'reciept_number': reciept_number,
      'inflow': inflow,
      'outflow': outflow,
      'balance': balance,
    };
  }

  factory CashflowModel.fromMap(Map<String, dynamic> map) {
    return CashflowModel(
      date: map['date'] != null ? map['date'] as String : null,
      note: map['note'] != null ? map['note'] as String : null,
      reciept_number: map['reciept_number'] != null
          ? map['reciept_number'] as String
          : null,
      inflow: map['inflow'] != null ? map['inflow'] as String : null,
      outflow: map['outflow'] != null ? map['outflow'] as String : null,
      balance: map['balance'] != null ? map['balance'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CashflowModel.fromJson(String source) =>
      CashflowModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CashflowModel(date: $date, note: $note, reciept_number: $reciept_number, inflow: $inflow, outflow: $outflow, balance: $balance)';
  }

  @override
  bool operator ==(covariant CashflowModel other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.note == note &&
        other.reciept_number == reciept_number &&
        other.inflow == inflow &&
        other.outflow == outflow &&
        other.balance == balance;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        note.hashCode ^
        reciept_number.hashCode ^
        inflow.hashCode ^
        outflow.hashCode ^
        balance.hashCode;
  }
}
