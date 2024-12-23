// ignore_for_file: public_member_api_docs, sort_constructors_first, non_constant_identifier_names
import 'dart:convert';

class BriefPurchaseModel {
  int? Pur_ID;
  String? Section;
  String? Item;
  String? Usage;
  int? Approved;
  int? Received;
  int? Archived;
  BriefPurchaseModel({
    this.Pur_ID,
    this.Section,
    this.Item,
    this.Usage,
    this.Approved,
    this.Received,
    this.Archived,
  });

  BriefPurchaseModel copyWith({
    int? Pur_ID,
    String? Section,
    String? Item,
    String? Usage,
    int? Approved,
    int? Received,
    int? Archived,
  }) {
    return BriefPurchaseModel(
      Pur_ID: Pur_ID ?? this.Pur_ID,
      Section: Section ?? this.Section,
      Item: Item ?? this.Item,
      Usage: Usage ?? this.Usage,
      Approved: Approved ?? this.Approved,
      Received: Received ?? this.Received,
      Archived: Archived ?? this.Archived,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Pur_ID': Pur_ID,
      'Section': Section,
      'Item': Item,
      'Usage': Usage,
      'Approved': Approved,
      'Received': Received,
      'Archived': Archived,
    };
  }

  factory BriefPurchaseModel.fromMap(Map<String, dynamic> map) {
    return BriefPurchaseModel(
      Pur_ID: map['Pur_ID'] != null ? map['Pur_ID'] as int : null,
      Section: map['Section'] != null ? map['Section'] as String : null,
      Item: map['Item'] != null ? map['Item'] as String : null,
      Usage: map['Usage'] != null ? map['Usage'] as String : null,
      Approved: map['Approved'] != null ? map['Approved'] as int : null,
      Received: map['Received'] != null ? map['Received'] as int : null,
      Archived: map['Archived'] != null ? map['Archived'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BriefPurchaseModel.fromJson(String source) =>
      BriefPurchaseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BriefPurchaseModel(Pur_ID: $Pur_ID, Section: $Section, Item: $Item, Usage: $Usage, Approved: $Approved, Received: $Received, Archived: $Archived)';
  }

  @override
  bool operator ==(covariant BriefPurchaseModel other) {
    if (identical(this, other)) return true;

    return other.Pur_ID == Pur_ID &&
        other.Section == Section &&
        other.Item == Item &&
        other.Usage == Usage &&
        other.Approved == Approved &&
        other.Received == Received &&
        other.Archived == Archived;
  }

  @override
  int get hashCode {
    return Pur_ID.hashCode ^
        Section.hashCode ^
        Item.hashCode ^
        Usage.hashCode ^
        Approved.hashCode ^
        Received.hashCode ^
        Archived.hashCode;
  }
}
