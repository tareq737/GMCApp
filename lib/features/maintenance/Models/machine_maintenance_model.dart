import 'dart:convert';

import 'package:flutter/foundation.dart';

class MachineMaintenanceModel {
  final Map<String, List<Map<String, dynamic>>> machines;

  MachineMaintenanceModel({required this.machines});

  MachineMaintenanceModel copyWith({
    Map<String, List<Map<String, dynamic>>>? machines,
  }) {
    return MachineMaintenanceModel(
      machines: machines ?? this.machines,
    );
  }

  Map<String, dynamic> toMap() {
    return machines.map((key, value) => MapEntry(key, value));
  }

  factory MachineMaintenanceModel.fromMap(Map<String, dynamic> map) {
    // parse each list of machines safely
    final parsedMap = map.map((key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => Map<String, dynamic>.from(e))
              .toList(),
        ));
    return MachineMaintenanceModel(machines: parsedMap);
  }

  String toJson() => json.encode(toMap());

  factory MachineMaintenanceModel.fromJson(String source) =>
      MachineMaintenanceModel.fromMap(json.decode(source));

  @override
  String toString() => 'MachineMaintenanceModel(machines: $machines)';

  @override
  bool operator ==(covariant MachineMaintenanceModel other) {
    return mapEquals(other.machines, machines);
  }

  @override
  int get hashCode => machines.hashCode;
}
