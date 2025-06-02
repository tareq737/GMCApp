// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdditionalOperationsModel {
  int? id;
  String? start_time;
  String? finish_time;
  String? department;
  String? completion_date;
  String? operation;
  String? notes;
  bool? done;
  String? worker;
  AdditionalOperationsModel({
    this.id,
    this.start_time,
    this.finish_time,
    this.department,
    this.completion_date,
    this.operation,
    this.notes,
    this.done,
    this.worker,
  });

  AdditionalOperationsModel copyWith({
    int? id,
    String? start_time,
    String? finish_time,
    String? department,
    String? completion_date,
    String? operation,
    String? notes,
    bool? done,
    String? worker,
  }) {
    return AdditionalOperationsModel(
      id: id ?? this.id,
      start_time: start_time ?? this.start_time,
      finish_time: finish_time ?? this.finish_time,
      department: department ?? this.department,
      completion_date: completion_date ?? this.completion_date,
      operation: operation ?? this.operation,
      notes: notes ?? this.notes,
      done: done ?? this.done,
      worker: worker ?? this.worker,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'start_time': start_time,
      'finish_time': finish_time,
      'department': department,
      'completion_date': completion_date,
      'operation': operation,
      'notes': notes,
      'done': done,
      'worker': worker,
    };
  }

  factory AdditionalOperationsModel.fromMap(Map<String, dynamic> map) {
    return AdditionalOperationsModel(
      id: map['id'] != null ? map['id'] as int : null,
      start_time:
          map['start_time'] != null ? map['start_time'] as String : null,
      finish_time:
          map['finish_time'] != null ? map['finish_time'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      completion_date: map['completion_date'] != null
          ? map['completion_date'] as String
          : null,
      operation: map['operation'] != null ? map['operation'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      done: map['done'] != null ? map['done'] as bool : null,
      worker: map['worker'] != null ? map['worker'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdditionalOperationsModel.fromJson(String source) =>
      AdditionalOperationsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdditionalOperationsModel(id: $id, start_time: $start_time, finish_time: $finish_time, department: $department, completion_date: $completion_date, operation: $operation, notes: $notes, done: $done, worker: $worker)';
  }

  @override
  bool operator ==(covariant AdditionalOperationsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.start_time == start_time &&
        other.finish_time == finish_time &&
        other.department == department &&
        other.completion_date == completion_date &&
        other.operation == operation &&
        other.notes == notes &&
        other.done == done &&
        other.worker == worker;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        start_time.hashCode ^
        finish_time.hashCode ^
        department.hashCode ^
        completion_date.hashCode ^
        operation.hashCode ^
        notes.hashCode ^
        done.hashCode ^
        worker.hashCode;
  }
}
