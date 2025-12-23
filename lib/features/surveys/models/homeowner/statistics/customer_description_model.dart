// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CustomerDescriptionModel {
  int? store_owner;
  int? worker;
  CustomerDescriptionModel({
    this.store_owner,
    this.worker,
  });

  CustomerDescriptionModel copyWith({
    int? store_owner,
    int? worker,
  }) {
    return CustomerDescriptionModel(
      store_owner: store_owner ?? this.store_owner,
      worker: worker ?? this.worker,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'store_owner': store_owner,
      'worker': worker,
    };
  }

  factory CustomerDescriptionModel.fromMap(Map<String, dynamic> map) {
    return CustomerDescriptionModel(
      store_owner:
          map['store_owner'] != null ? map['store_owner'] as int : null,
      worker: map['worker'] != null ? map['worker'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerDescriptionModel.fromJson(String source) =>
      CustomerDescriptionModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CustomerDescriptionModel(store_owner: $store_owner, worker: $worker)';

  @override
  bool operator ==(covariant CustomerDescriptionModel other) {
    if (identical(this, other)) return true;

    return other.store_owner == store_owner && other.worker == worker;
  }

  @override
  int get hashCode => store_owner.hashCode ^ worker.hashCode;
}
