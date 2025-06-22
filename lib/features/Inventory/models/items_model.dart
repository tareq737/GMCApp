// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemsModel {
  int id;
  String? code;
  String? name;
  String? unit;
  String? min_limit;
  String? max_limit;
  int? group;
  String? group_code_name;
  List<Map<String, dynamic>>? default_price; // Add this line

  ItemsModel({
    required this.id,
    this.code,
    this.name,
    this.unit,
    this.min_limit,
    this.max_limit,
    this.group,
    this.group_code_name,
    this.default_price, // Add this line
  });

  ItemsModel copyWith({
    int? id,
    String? code,
    String? name,
    String? unit,
    String? min_limit,
    String? max_limit,
    int? group,
    String? group_code_name,
    List<Map<String, dynamic>>? default_price, // Add this line
  }) {
    return ItemsModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      min_limit: min_limit ?? this.min_limit,
      max_limit: max_limit ?? this.max_limit,
      group: group ?? this.group,
      group_code_name: group_code_name ?? this.group_code_name,
      default_price: default_price ?? this.default_price, // Add this line
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'unit': unit,
      'min_limit': min_limit,
      'max_limit': max_limit,
      'group': group,
      'group_code_name': group_code_name,
      'default_price': default_price, // Add this line
    };
  }

  factory ItemsModel.fromMap(Map<String, dynamic> map) {
    return ItemsModel(
      id: map['id'] as int,
      code: map['code'] != null ? map['code'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      unit: map['unit'] != null ? map['unit'] as String : null,
      min_limit: map['min_limit'] != null ? map['min_limit'] as String : null,
      max_limit: map['max_limit'] != null ? map['max_limit'] as String : null,
      group: map['group'] != null ? map['group'] as int : null,
      group_code_name: map['group_code_name'] != null
          ? map['group_code_name'] as String
          : null,
      // Add this block for default_price
      default_price: map['default_price'] != null
          ? List<Map<String, dynamic>>.from(
              (map['default_price'] as List<dynamic>).map<Map<String, dynamic>>(
                (x) => x as Map<String, dynamic>,
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemsModel.fromJson(String source) =>
      ItemsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemsModel(id: $id, code: $code, name: $name, unit: $unit, min_limit: $min_limit, max_limit: $max_limit, group: $group, group_code_name: $group_code_name, default_price: $default_price)';
  }

  @override
  bool operator ==(covariant ItemsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.code == code &&
        other.name == name &&
        other.unit == unit &&
        other.min_limit == min_limit &&
        other.max_limit == max_limit &&
        other.group == group &&
        other.group_code_name == group_code_name &&
        // Add this line for default_price comparison
        listEquals(other.default_price, default_price);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        unit.hashCode ^
        min_limit.hashCode ^
        max_limit.hashCode ^
        group.hashCode ^
        group_code_name.hashCode ^
        // Add this line for default_price hash code
        default_price.hashCode;
  }
}

// You'll need this utility function for list comparison in operator ==
// Add this outside of your ItemsModel class, or in a utility file
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null && b == null) return true;
  if (a == null || b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
