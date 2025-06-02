// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MachineMaintenanceModel {
  Map<String, List<String>> machines;
  MachineMaintenanceModel({
    required this.machines,
  });

  MachineMaintenanceModel copyWith({
    Map<String, List<String>>? categories,
  }) {
    return MachineMaintenanceModel(
      machines: categories ?? this.machines,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categories': machines,
    };
  }

  factory MachineMaintenanceModel.fromMap(Map<String, dynamic> map) {
    return MachineMaintenanceModel(
      machines: map.map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory MachineMaintenanceModel.fromJson(String source) =>
      MachineMaintenanceModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MachineMaintenanceModel(categories: $machines)';

  @override
  bool operator ==(covariant MachineMaintenanceModel other) {
    if (identical(this, other)) return true;

    return mapEquals(other.machines, machines);
  }

  @override
  int get hashCode => machines.hashCode;
}
