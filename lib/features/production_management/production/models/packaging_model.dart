// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PackagingModel {
  int? id;
  String? start_time;
  String? finish_time;
  String? employee;
  String? notes;
  String? problems;
  String? completion_date;
  bool? packaging_check_1;
  bool? packaging_check_2;
  bool? packaging_check_3;
  bool? packaging_check_4;
  bool? packaging_check_5;
  bool? packaging_check_6;
  double? packaging_density;
  String? batch_leftover;
  int? receipt_number;
  double? container_empty;
  double? packaging_weight;
  String? printing;
  String? filling;
  String? shrinkage;
  String? bagging;
  String? strapping;
  String? pressing;
  String? stickers;
  String? wrapping;
  String? cartons;
  PackagingModel({
    this.id,
    this.start_time,
    this.finish_time,
    this.employee,
    this.notes,
    this.problems,
    this.completion_date,
    this.packaging_check_1,
    this.packaging_check_2,
    this.packaging_check_3,
    this.packaging_check_4,
    this.packaging_check_5,
    this.packaging_check_6,
    this.packaging_density,
    this.batch_leftover,
    this.receipt_number,
    this.container_empty,
    this.packaging_weight,
    this.printing,
    this.filling,
    this.shrinkage,
    this.bagging,
    this.strapping,
    this.pressing,
    this.stickers,
    this.wrapping,
    this.cartons,
  });

  PackagingModel copyWith({
    int? id,
    String? start_time,
    String? finish_time,
    String? employee,
    String? notes,
    String? problems,
    String? completion_date,
    bool? packaging_check_1,
    bool? packaging_check_2,
    bool? packaging_check_3,
    bool? packaging_check_4,
    bool? packaging_check_5,
    bool? packaging_check_6,
    double? packaging_density,
    String? batch_leftover,
    int? receipt_number,
    double? container_empty,
    double? packaging_weight,
    String? printing,
    String? filling,
    String? shrinkage,
    String? bagging,
    String? strapping,
    String? pressing,
    String? stickers,
    String? wrapping,
    String? cartons,
  }) {
    return PackagingModel(
      id: id ?? this.id,
      start_time: start_time ?? this.start_time,
      finish_time: finish_time ?? this.finish_time,
      employee: employee ?? this.employee,
      notes: notes ?? this.notes,
      problems: problems ?? this.problems,
      completion_date: completion_date ?? this.completion_date,
      packaging_check_1: packaging_check_1 ?? this.packaging_check_1,
      packaging_check_2: packaging_check_2 ?? this.packaging_check_2,
      packaging_check_3: packaging_check_3 ?? this.packaging_check_3,
      packaging_check_4: packaging_check_4 ?? this.packaging_check_4,
      packaging_check_5: packaging_check_5 ?? this.packaging_check_5,
      packaging_check_6: packaging_check_6 ?? this.packaging_check_6,
      packaging_density: packaging_density ?? this.packaging_density,
      batch_leftover: batch_leftover ?? this.batch_leftover,
      receipt_number: receipt_number ?? this.receipt_number,
      container_empty: container_empty ?? this.container_empty,
      packaging_weight: packaging_weight ?? this.packaging_weight,
      printing: printing ?? this.printing,
      filling: filling ?? this.filling,
      shrinkage: shrinkage ?? this.shrinkage,
      bagging: bagging ?? this.bagging,
      strapping: strapping ?? this.strapping,
      pressing: pressing ?? this.pressing,
      stickers: stickers ?? this.stickers,
      wrapping: wrapping ?? this.wrapping,
      cartons: cartons ?? this.cartons,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'packaging': {
        'id': id,
        'start_time': start_time,
        'finish_time': finish_time,
        'employee': employee,
        'notes': notes,
        'problems': problems,
        'completion_date': completion_date,
        'packaging_check_1': packaging_check_1,
        'packaging_check_2': packaging_check_2,
        'packaging_check_3': packaging_check_3,
        'packaging_check_4': packaging_check_4,
        'packaging_check_5': packaging_check_5,
        'packaging_check_6': packaging_check_6,
        'packaging_density': packaging_density,
        'batch_leftover': batch_leftover,
        'receipt_number': receipt_number,
        'container_empty': container_empty,
        'packaging_weight': packaging_weight,
        'printing': printing,
        'filling': filling,
        'shrinkage': shrinkage,
        'bagging': bagging,
        'strapping': strapping,
        'pressing': pressing,
        'stickers': stickers,
        'wrapping': wrapping,
        'cartons': cartons,
      }
    };
  }

  factory PackagingModel.fromMap(Map<String, dynamic> map) {
    return PackagingModel(
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
      packaging_check_1: map['packaging_check_1'] != null
          ? map['packaging_check_1'] as bool
          : false,
      packaging_check_2: map['packaging_check_2'] != null
          ? map['packaging_check_2'] as bool
          : false,
      packaging_check_3: map['packaging_check_3'] != null
          ? map['packaging_check_3'] as bool
          : false,
      packaging_check_4: map['packaging_check_4'] != null
          ? map['packaging_check_4'] as bool
          : false,
      packaging_check_5: map['packaging_check_5'] != null
          ? map['packaging_check_5'] as bool
          : false,
      packaging_check_6: map['packaging_check_6'] != null
          ? map['packaging_check_6'] as bool
          : false,
      packaging_density: map['packaging_density'] != null
          ? map['packaging_density'] as double
          : null,
      batch_leftover: map['batch_leftover'] != null
          ? map['batch_leftover'] as String
          : null,
      receipt_number:
          map['receipt_number'] != null ? map['receipt_number'] as int : null,
      container_empty: map['container_empty'] != null
          ? map['container_empty'] as double
          : null,
      packaging_weight: map['packaging_weight'] != null
          ? map['packaging_weight'] as double
          : null,
      printing: map['printing'] != null ? map['printing'] as String : null,
      filling: map['filling'] != null ? map['filling'] as String : null,
      shrinkage: map['shrinkage'] != null ? map['shrinkage'] as String : null,
      bagging: map['bagging'] != null ? map['bagging'] as String : null,
      strapping: map['strapping'] != null ? map['strapping'] as String : null,
      pressing: map['pressing'] != null ? map['pressing'] as String : null,
      stickers: map['stickers'] != null ? map['stickers'] as String : null,
      wrapping: map['wrapping'] != null ? map['wrapping'] as String : null,
      cartons: map['cartons'] != null ? map['cartons'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PackagingModel.fromJson(String source) =>
      PackagingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PackagingModel(id: $id, start_time: $start_time, finish_time: $finish_time, employee: $employee, notes: $notes, problems: $problems, completion_date: $completion_date, packaging_check_1: $packaging_check_1, packaging_check_2: $packaging_check_2, packaging_check_3: $packaging_check_3, packaging_check_4: $packaging_check_4, packaging_check_5: $packaging_check_5, packaging_check_6: $packaging_check_6, packaging_density: $packaging_density, batch_leftover: $batch_leftover, receipt_number: $receipt_number, container_empty: $container_empty, packaging_weight: $packaging_weight, printing: $printing, filling: $filling, shrinkage: $shrinkage, bagging: $bagging, strapping: $strapping, pressing: $pressing, stickers: $stickers, wrapping: $wrapping, cartons: $cartons)';
  }

  @override
  bool operator ==(covariant PackagingModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.start_time == start_time &&
        other.finish_time == finish_time &&
        other.employee == employee &&
        other.notes == notes &&
        other.problems == problems &&
        other.completion_date == completion_date &&
        other.packaging_check_1 == packaging_check_1 &&
        other.packaging_check_2 == packaging_check_2 &&
        other.packaging_check_3 == packaging_check_3 &&
        other.packaging_check_4 == packaging_check_4 &&
        other.packaging_check_5 == packaging_check_5 &&
        other.packaging_check_6 == packaging_check_6 &&
        other.packaging_density == packaging_density &&
        other.batch_leftover == batch_leftover &&
        other.receipt_number == receipt_number &&
        other.container_empty == container_empty &&
        other.packaging_weight == packaging_weight &&
        other.printing == printing &&
        other.filling == filling &&
        other.shrinkage == shrinkage &&
        other.bagging == bagging &&
        other.strapping == strapping &&
        other.pressing == pressing &&
        other.stickers == stickers &&
        other.wrapping == wrapping &&
        other.cartons == cartons;
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
        packaging_check_1.hashCode ^
        packaging_check_2.hashCode ^
        packaging_check_3.hashCode ^
        packaging_check_4.hashCode ^
        packaging_check_5.hashCode ^
        packaging_check_6.hashCode ^
        packaging_density.hashCode ^
        batch_leftover.hashCode ^
        receipt_number.hashCode ^
        container_empty.hashCode ^
        packaging_weight.hashCode ^
        printing.hashCode ^
        filling.hashCode ^
        shrinkage.hashCode ^
        bagging.hashCode ^
        strapping.hashCode ^
        pressing.hashCode ^
        stickers.hashCode ^
        wrapping.hashCode ^
        cartons.hashCode;
  }
}
