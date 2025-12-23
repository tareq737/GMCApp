// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PuttySellingMethodModel {
  int? ready;
  int? assembled;
  int? none;
  PuttySellingMethodModel({
    this.ready,
    this.assembled,
    this.none,
  });

  PuttySellingMethodModel copyWith({
    int? ready,
    int? assembled,
    int? none,
  }) {
    return PuttySellingMethodModel(
      ready: ready ?? this.ready,
      assembled: assembled ?? this.assembled,
      none: none ?? this.none,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ready': ready,
      'assembled': assembled,
      'none': none,
    };
  }

  factory PuttySellingMethodModel.fromMap(Map<String, dynamic> map) {
    return PuttySellingMethodModel(
      ready: map['ready'] != null ? map['ready'] as int : null,
      assembled: map['assembled'] != null ? map['assembled'] as int : null,
      none: map['none'] != null ? map['none'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PuttySellingMethodModel.fromJson(String source) =>
      PuttySellingMethodModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PuttySellingMethodModel(ready: $ready, assembled: $assembled, none: $none)';

  @override
  bool operator ==(covariant PuttySellingMethodModel other) {
    if (identical(this, other)) return true;

    return other.ready == ready &&
        other.assembled == assembled &&
        other.none == none;
  }

  @override
  int get hashCode => ready.hashCode ^ assembled.hashCode ^ none.hashCode;
}
