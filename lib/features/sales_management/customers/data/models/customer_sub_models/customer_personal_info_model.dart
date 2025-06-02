import 'dart:convert';

import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerPersonalInfoModel extends CustomerPersonalInfoEntity {
  CustomerPersonalInfoModel({
    super.clientPlaceOfBirth,
    super.clientYearOfBirth = 1900,
    super.clientMaritalStatus,
    super.clientNumberOfChildren = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'client_place_of_birth': clientPlaceOfBirth,
      'client_year_of_birth': clientYearOfBirth,
      'client_marital_status': clientMaritalStatus,
      'client_number_of_children': clientNumberOfChildren,
    };
  }

  factory CustomerPersonalInfoModel.fromMap(Map<String, dynamic> map) {
    return CustomerPersonalInfoModel(
      clientPlaceOfBirth: map['client_place_of_birth'] != null
          ? map['client_place_of_birth'] as String
          : null,
      clientYearOfBirth: map['client_year_of_birth'] != null
          ? map['client_year_of_birth'] as int
          : 1900,
      clientMaritalStatus: map['client_marital_status'] != null
          ? map['client_marital_status'] as String
          : null,
      clientNumberOfChildren: map['client_number_of_children'] != null
          ? map['client_number_of_children'] as int
          : 0,
    );
  }

  factory CustomerPersonalInfoModel.fromEntity(
      CustomerPersonalInfoEntity entity) {
    return CustomerPersonalInfoModel(
      clientMaritalStatus: entity.clientMaritalStatus,
      clientNumberOfChildren: entity.clientNumberOfChildren,
      clientPlaceOfBirth: entity.clientPlaceOfBirth,
      clientYearOfBirth: entity.clientYearOfBirth,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerPersonalInfoModel.fromJson(String source) {
    return CustomerPersonalInfoModel.fromMap(
      json.decode(source) as Map<String, dynamic>,
    );
  }
}
