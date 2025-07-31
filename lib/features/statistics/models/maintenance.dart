// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Maintenance {
  int? total_maintenance;
  int? maintenance_received_true;
  Maintenance({
    this.total_maintenance,
    this.maintenance_received_true,
  });

  Maintenance copyWith({
    int? total_maintenance,
    int? maintenance_received_true,
  }) {
    return Maintenance(
      total_maintenance: total_maintenance ?? this.total_maintenance,
      maintenance_received_true:
          maintenance_received_true ?? this.maintenance_received_true,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_maintenance': total_maintenance,
      'maintenance_received_true': maintenance_received_true,
    };
  }

  factory Maintenance.fromMap(Map<String, dynamic> map) {
    return Maintenance(
      total_maintenance: map['total_maintenance'] != null
          ? map['total_maintenance'] as int
          : null,
      maintenance_received_true: map['maintenance_received_true'] != null
          ? map['maintenance_received_true'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Maintenance.fromJson(String source) =>
      Maintenance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Maintenance(total_maintenance: $total_maintenance, maintenance_received_true: $maintenance_received_true)';

  @override
  bool operator ==(covariant Maintenance other) {
    if (identical(this, other)) return true;

    return other.total_maintenance == total_maintenance &&
        other.maintenance_received_true == maintenance_received_true;
  }

  @override
  int get hashCode =>
      total_maintenance.hashCode ^ maintenance_received_true.hashCode;
}
