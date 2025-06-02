import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CheckModel {
  int depId;
  int planId;
  String notes;
  bool check;
  double? density;
  CheckModel({
    required this.depId,
    required this.planId,
    required this.notes,
    required this.check,
    this.density,
  });

  Map<String, dynamic> toMap() {
    switch (depId) {
      case 1:
        return <String, dynamic>{
          'raw_material_check': check,
          'raw_material_notes': notes,
        };

      case 2:
        return <String, dynamic>{
          'manufacturing_check': check,
          'manufacturing_notes': notes,
        };
      case 4:
        return <String, dynamic>{
          'emptyPackaging_check': check,
          'emptyPackaging_notes': notes,
        };
      case 5:
        return <String, dynamic>{
          'packaging_check': check,
          'packaging_notes': notes,
        };

      case 6:
        return <String, dynamic>{
          'finishedGoods_check': check,
          'finishedGoods_notes': notes,
        };
      case 3:
        return <String, dynamic>{
          'lab_check': check,
          'lab_notes': notes,
          'density': density,
        };
      default:
        return <String, dynamic>{};
    }
  }

  String toJson() => json.encode(toMap());
}
