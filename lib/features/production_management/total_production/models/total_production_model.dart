// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TotalProductionModel {
  int id;
  String? batch_number;
  String? department;
  String? operation;
  String? insert_date;
  String? worker;
  String? start_time;
  String? finish_time;
  TotalProductionModel({
    required this.id,
    this.batch_number,
    this.department,
    this.operation,
    this.insert_date,
    this.worker,
    this.start_time,
    this.finish_time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'batch_number': batch_number,
      'department': department,
      'operation': operation,
      'insert_date': insert_date,
      'worker': worker,
      'start_time': start_time,
      'finish_time': finish_time,
    };
  }

  factory TotalProductionModel.fromMap(Map<String, dynamic> map) {
    return TotalProductionModel(
      id: map['id'] as int,
      batch_number:
          map['batch_number'] != null ? map['batch_number'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      operation: map['operation'] != null ? map['operation'] as String : null,
      insert_date:
          map['insert_date'] != null ? map['insert_date'] as String : null,
      worker: map['worker'] != null ? map['worker'] as String : null,
      start_time:
          map['start_time'] != null ? map['start_time'] as String : null,
      finish_time:
          map['finish_time'] != null ? map['finish_time'] as String : null,
    );
  }

  TotalProductionModel copyWith({
    int? id,
    String? batch_number,
    String? department,
    String? operation,
    String? insert_date,
    String? worker,
    String? start_time,
    String? finish_time,
  }) {
    return TotalProductionModel(
      id: id ?? this.id,
      batch_number: batch_number ?? this.batch_number,
      department: department ?? this.department,
      operation: operation ?? this.operation,
      insert_date: insert_date ?? this.insert_date,
      worker: worker ?? this.worker,
      start_time: start_time ?? this.start_time,
      finish_time: finish_time ?? this.finish_time,
    );
  }

  String toJson() => json.encode(toMap());

  factory TotalProductionModel.fromJson(String source) =>
      TotalProductionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TotalProductionModel(id: $id, batch_number: $batch_number, department: $department, operation: $operation, insert_date: $insert_date, worker: $worker, start_time: $start_time, finish_time: $finish_time)';
  }

  @override
  bool operator ==(covariant TotalProductionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.batch_number == batch_number &&
        other.department == department &&
        other.operation == operation &&
        other.insert_date == insert_date &&
        other.worker == worker &&
        other.start_time == start_time &&
        other.finish_time == finish_time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        batch_number.hashCode ^
        department.hashCode ^
        operation.hashCode ^
        insert_date.hashCode ^
        worker.hashCode ^
        start_time.hashCode ^
        finish_time.hashCode;
  }
}
