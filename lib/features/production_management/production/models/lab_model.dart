// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LabModel {
  int? id;
  String? start_time;
  String? finish_time;
  String? employee;
  String? notes;
  String? problems;
  String? completion_date;
  bool? lab_check_1;
  bool? lab_check_2;
  bool? lab_check_3;
  bool? lab_check_4;
  bool? lab_check_5;
  bool? lab_check_6;
  double? concealment;
  double? gloss;
  String? viscosity;
  double? density;
  int? smoothness;
  bool? lab_color;
  double? batch_temperature;
  LabModel({
    this.id,
    this.start_time,
    this.finish_time,
    this.employee,
    this.notes,
    this.problems,
    this.completion_date,
    this.lab_check_1,
    this.lab_check_2,
    this.lab_check_3,
    this.lab_check_4,
    this.lab_check_5,
    this.lab_check_6,
    this.concealment,
    this.gloss,
    this.viscosity,
    this.density,
    this.smoothness,
    this.lab_color,
    this.batch_temperature,
  });

  LabModel copyWith({
    int? id,
    String? start_time,
    String? finish_time,
    String? employee,
    String? notes,
    String? problems,
    String? completion_date,
    bool? lab_check_1,
    bool? lab_check_2,
    bool? lab_check_3,
    bool? lab_check_4,
    bool? lab_check_5,
    bool? lab_check_6,
    double? concealment,
    double? gloss,
    String? viscosity,
    double? density,
    int? smoothness,
    bool? lab_color,
    double? batch_temperature,
  }) {
    return LabModel(
      id: id ?? this.id,
      start_time: start_time ?? this.start_time,
      finish_time: finish_time ?? this.finish_time,
      employee: employee ?? this.employee,
      notes: notes ?? this.notes,
      problems: problems ?? this.problems,
      completion_date: completion_date ?? this.completion_date,
      lab_check_1: lab_check_1 ?? this.lab_check_1,
      lab_check_2: lab_check_2 ?? this.lab_check_2,
      lab_check_3: lab_check_3 ?? this.lab_check_3,
      lab_check_4: lab_check_4 ?? this.lab_check_4,
      lab_check_5: lab_check_5 ?? this.lab_check_5,
      lab_check_6: lab_check_6 ?? this.lab_check_6,
      concealment: concealment ?? this.concealment,
      gloss: gloss ?? this.gloss,
      viscosity: viscosity ?? this.viscosity,
      density: density ?? this.density,
      smoothness: smoothness ?? this.smoothness,
      lab_color: lab_color ?? this.lab_color,
      batch_temperature: batch_temperature ?? this.batch_temperature,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lab': {
        'id': id,
        'start_time': start_time,
        'finish_time': finish_time,
        'employee': employee,
        'notes': notes,
        'problems': problems,
        'completion_date': completion_date,
        'lab_check_1': lab_check_1,
        'lab_check_2': lab_check_2,
        'lab_check_3': lab_check_3,
        'lab_check_4': lab_check_4,
        'lab_check_5': lab_check_5,
        'lab_check_6': lab_check_6,
        'concealment': concealment,
        'gloss': gloss,
        'viscosity': viscosity,
        'density': density,
        'smoothness': smoothness,
        'lab_color': lab_color,
        'batch_temperature': batch_temperature,
      }
    };
  }

  factory LabModel.fromMap(Map<String, dynamic> map) {
    return LabModel(
      id: map['id'] != null ? map['id'] as int : null,
      start_time:
          map['start_time'] != null ? map['start_time'] as String : null,
      finish_time:
          map['finish_time'] != null ? map['finish_time'] as String : null,
      employee: map['employee'] != null ? map['employee'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      problems: map['problems'] != null ? map['problems'] as String : null,
      completion_date: map['completion_date'] != null
          ? map['completion_date'] as String
          : null,
      lab_check_1:
          map['lab_check_1'] != null ? map['lab_check_1'] as bool : null,
      lab_check_2:
          map['lab_check_2'] != null ? map['lab_check_2'] as bool : null,
      lab_check_3:
          map['lab_check_3'] != null ? map['lab_check_3'] as bool : null,
      lab_check_4:
          map['lab_check_4'] != null ? map['lab_check_4'] as bool : null,
      lab_check_5:
          map['lab_check_5'] != null ? map['lab_check_5'] as bool : null,
      lab_check_6:
          map['lab_check_6'] != null ? map['lab_check_6'] as bool : null,
      concealment:
          map['concealment'] != null ? map['concealment'] as double : null,
      gloss: map['gloss'] != null ? map['gloss'] as double : null,
      viscosity: map['viscosity'] != null ? map['viscosity'] as String : null,
      density: map['density'] != null ? map['density'] as double : null,
      smoothness: map['smoothness'] != null ? map['smoothness'] as int : null,
      lab_color: map['lab_color'] != null ? map['lab_color'] as bool : null,
      batch_temperature: map['batch_temperature'] != null
          ? map['batch_temperature'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LabModel.fromJson(String source) =>
      LabModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LabModel(id: $id, start_time: $start_time, finish_time: $finish_time, employee: $employee, notes: $notes, problems: $problems, completion_date: $completion_date, lab_check_1: $lab_check_1, lab_check_2: $lab_check_2, lab_check_3: $lab_check_3, lab_check_4: $lab_check_4, lab_check_5: $lab_check_5, lab_check_6: $lab_check_6, concealment: $concealment, gloss: $gloss, viscosity: $viscosity, density: $density, smoothness: $smoothness, lab_color: $lab_color, batch_temperature: $batch_temperature)';
  }

  @override
  bool operator ==(covariant LabModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.start_time == start_time &&
        other.finish_time == finish_time &&
        other.employee == employee &&
        other.notes == notes &&
        other.problems == problems &&
        other.completion_date == completion_date &&
        other.lab_check_1 == lab_check_1 &&
        other.lab_check_2 == lab_check_2 &&
        other.lab_check_3 == lab_check_3 &&
        other.lab_check_4 == lab_check_4 &&
        other.lab_check_5 == lab_check_5 &&
        other.lab_check_6 == lab_check_6 &&
        other.concealment == concealment &&
        other.gloss == gloss &&
        other.viscosity == viscosity &&
        other.density == density &&
        other.smoothness == smoothness &&
        other.lab_color == lab_color &&
        other.batch_temperature == batch_temperature;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        start_time.hashCode ^
        finish_time.hashCode ^
        employee.hashCode ^
        notes.hashCode ^
        problems.hashCode ^
        completion_date.hashCode ^
        lab_check_1.hashCode ^
        lab_check_2.hashCode ^
        lab_check_3.hashCode ^
        lab_check_4.hashCode ^
        lab_check_5.hashCode ^
        lab_check_6.hashCode ^
        concealment.hashCode ^
        gloss.hashCode ^
        viscosity.hashCode ^
        density.hashCode ^
        smoothness.hashCode ^
        lab_color.hashCode ^
        batch_temperature.hashCode;
  }
}
