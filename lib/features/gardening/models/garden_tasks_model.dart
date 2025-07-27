// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gmcappclean/features/gardening/models/garden_activities_model.dart';

class GardenTasksModel {
  int? id;
  GardenActivitiesModel? activity;
  String? date;
  String? time_from;
  String? time_to;
  String? worker_name;
  String? notes;
  bool? done;
  int? activity_id;
  GardenTasksModel({
    this.id,
    this.activity,
    this.date,
    this.time_from,
    this.time_to,
    this.worker_name,
    this.notes,
    this.done,
    this.activity_id,
  });

  GardenTasksModel copyWith({
    int? id,
    GardenActivitiesModel? activity,
    String? date,
    String? time_from,
    String? time_to,
    String? worker_name,
    String? notes,
    bool? done,
    int? activity_id,
  }) {
    return GardenTasksModel(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      date: date ?? this.date,
      time_from: time_from ?? this.time_from,
      time_to: time_to ?? this.time_to,
      worker_name: worker_name ?? this.worker_name,
      notes: notes ?? this.notes,
      done: done ?? this.done,
      activity_id: activity_id ?? this.activity_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'time_from': time_from,
      'time_to': time_to,
      'worker_name': worker_name,
      'notes': notes,
      'done': done,
      'activity_id': activity_id,
    };
  }

  factory GardenTasksModel.fromMap(Map<String, dynamic> map) {
    return GardenTasksModel(
      id: map['id'] != null ? map['id'] as int : null,
      activity: map['activity'] != null
          ? GardenActivitiesModel.fromMap(
              map['activity'] as Map<String, dynamic>)
          : null,
      date: map['date'] != null ? map['date'] as String : null,
      time_from: map['time_from'] != null ? map['time_from'] as String : null,
      time_to: map['time_to'] != null ? map['time_to'] as String : null,
      worker_name: map['worker'] != null ? map['worker'] as String : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      done: map['done'] != null ? map['done'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GardenTasksModel.fromJson(String source) =>
      GardenTasksModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GardenTasksModel(id: $id, activity: $activity, date: $date, time_from: $time_from, time_to: $time_to, worker_name: $worker_name, notes: $notes, done: $done, activity_id: $activity_id)';
  }

  @override
  bool operator ==(covariant GardenTasksModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.activity == activity &&
        other.date == date &&
        other.time_from == time_from &&
        other.time_to == time_to &&
        other.worker_name == worker_name &&
        other.notes == notes &&
        other.done == done &&
        other.activity_id == activity_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        activity.hashCode ^
        date.hashCode ^
        time_from.hashCode ^
        time_to.hashCode ^
        worker_name.hashCode ^
        notes.hashCode ^
        done.hashCode ^
        activity_id.hashCode;
  }
}
