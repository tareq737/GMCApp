import 'dart:convert';

import 'package:gmcappclean/features/sales_management/customers/domain/entities/customer_entity.dart';

class CustomerActivityModel extends CustomerActivityEntity {
  CustomerActivityModel({
    super.activityPaints = false,
    super.activityPlumping = false,
    super.activityElectrical = false,
    super.activityHaberdashery = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activity_paints': activityPaints,
      'activity_plumping': activityPlumping,
      'activity_electrical': activityElectrical,
      'activity_haberdashery': activityHaberdashery,
    };
  }

  factory CustomerActivityModel.fromMap(Map<String, dynamic> map) {
    return CustomerActivityModel(
      activityPaints: map['activity_paints'] != null
          ? map['activity_paints'] as bool
          : false,
      activityPlumping: map['activity_plumping'] != null
          ? map['activity_plumping'] as bool
          : false,
      activityElectrical: map['activity_electrical'] != null
          ? map['activity_electrical'] as bool
          : false,
      activityHaberdashery: map['activity_haberdashery'] != null
          ? map['activity_haberdashery'] as bool
          : false,
    );
  }
  factory CustomerActivityModel.fromEntity(CustomerActivityEntity entity) {
    return CustomerActivityModel(
      activityElectrical: entity.activityElectrical,
      activityHaberdashery: entity.activityHaberdashery,
      activityPaints: entity.activityPaints,
      activityPlumping: entity.activityPlumping,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerActivityModel.fromJson(String source) =>
      CustomerActivityModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
