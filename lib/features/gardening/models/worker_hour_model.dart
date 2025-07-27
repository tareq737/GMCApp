// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WorkerHourModel {
  String? worker_name;
  String? total_hours;
  String? completed_hours;
  WorkerHourModel({
    this.worker_name,
    this.total_hours,
    this.completed_hours,
  });

  WorkerHourModel copyWith({
    String? worker_name,
    String? total_hours,
    String? completed_hours,
  }) {
    return WorkerHourModel(
      worker_name: worker_name ?? this.worker_name,
      total_hours: total_hours ?? this.total_hours,
      completed_hours: completed_hours ?? this.completed_hours,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'worker_name': worker_name,
      'total_hours': total_hours,
      'completed_hours': completed_hours,
    };
  }

  factory WorkerHourModel.fromMap(Map<String, dynamic> map) {
    return WorkerHourModel(
      worker_name:
          map['worker_name'] != null ? map['worker_name'] as String : null,
      total_hours:
          map['total_hours'] != null ? map['total_hours'] as String : null,
      completed_hours: map['completed_hours'] != null
          ? map['completed_hours'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WorkerHourModel.fromJson(String source) =>
      WorkerHourModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WorkerHourModel(worker_name: $worker_name, total_hours: $total_hours, completed_hours: $completed_hours)';

  @override
  bool operator ==(covariant WorkerHourModel other) {
    if (identical(this, other)) return true;

    return other.worker_name == worker_name &&
        other.total_hours == total_hours &&
        other.completed_hours == completed_hours;
  }

  @override
  int get hashCode =>
      worker_name.hashCode ^ total_hours.hashCode ^ completed_hours.hashCode;
}
