// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductEfficiencyModel {
  int id;
  String? type;
  String? product;
  String? gloss;
  String? manufacturer;
  String? base;
  double? ease_of_dilution;
  double? ease_of_application;
  double? number_of_coats;
  double? smoothness;
  double? whiteness;
  double? opacity;
  double? total_opacity;
  double? coverage_per_liter;
  double? coverage_per_kg;
  double? efficiency_level;
  double? price_per_liter;
  double? efficiency_price_ratio;
  String? technical_notes;
  String? sales_notes;
  double? gloss_scrub_ratio;
  ProductEfficiencyModel({
    required this.id,
    this.type,
    this.product,
    this.gloss,
    this.manufacturer,
    this.base,
    this.ease_of_dilution,
    this.ease_of_application,
    this.number_of_coats,
    this.smoothness,
    this.whiteness,
    this.opacity,
    this.total_opacity,
    this.coverage_per_liter,
    this.coverage_per_kg,
    this.efficiency_level,
    this.price_per_liter,
    this.efficiency_price_ratio,
    this.technical_notes,
    this.sales_notes,
    this.gloss_scrub_ratio,
  });

  ProductEfficiencyModel copyWith({
    int? id,
    String? type,
    String? product,
    String? gloss,
    String? manufacturer,
    String? base,
    double? ease_of_dilution,
    double? ease_of_application,
    double? number_of_coats,
    double? smoothness,
    double? whiteness,
    double? opacity,
    double? total_opacity,
    double? coverage_per_liter,
    double? coverage_per_kg,
    double? efficiency_level,
    double? price_per_liter,
    double? efficiency_price_ratio,
    String? technical_notes,
    String? sales_notes,
    double? gloss_scrub_ratio,
  }) {
    return ProductEfficiencyModel(
      id: id ?? this.id,
      type: type ?? this.type,
      product: product ?? this.product,
      gloss: gloss ?? this.gloss,
      manufacturer: manufacturer ?? this.manufacturer,
      base: base ?? this.base,
      ease_of_dilution: ease_of_dilution ?? this.ease_of_dilution,
      ease_of_application: ease_of_application ?? this.ease_of_application,
      number_of_coats: number_of_coats ?? this.number_of_coats,
      smoothness: smoothness ?? this.smoothness,
      whiteness: whiteness ?? this.whiteness,
      opacity: opacity ?? this.opacity,
      total_opacity: total_opacity ?? this.total_opacity,
      coverage_per_liter: coverage_per_liter ?? this.coverage_per_liter,
      coverage_per_kg: coverage_per_kg ?? this.coverage_per_kg,
      efficiency_level: efficiency_level ?? this.efficiency_level,
      price_per_liter: price_per_liter ?? this.price_per_liter,
      efficiency_price_ratio:
          efficiency_price_ratio ?? this.efficiency_price_ratio,
      technical_notes: technical_notes ?? this.technical_notes,
      sales_notes: sales_notes ?? this.sales_notes,
      gloss_scrub_ratio: gloss_scrub_ratio ?? this.gloss_scrub_ratio,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'product': product,
      'gloss': gloss,
      'manufacturer': manufacturer,
      'base': base,
      'ease_of_dilution': ease_of_dilution,
      'ease_of_application': ease_of_application,
      'number_of_coats': number_of_coats,
      'smoothness': smoothness,
      'whiteness': whiteness,
      'opacity': opacity,
      'total_opacity': total_opacity,
      'coverage_per_liter': coverage_per_liter,
      'coverage_per_kg': coverage_per_kg,
      'efficiency_level': efficiency_level,
      'price_per_liter': price_per_liter,
      'efficiency_price_ratio': efficiency_price_ratio,
      'technical_notes': technical_notes,
      'sales_notes': sales_notes,
      'gloss_scrub_ratio': gloss_scrub_ratio,
    };
  }

  factory ProductEfficiencyModel.fromMap(Map<String, dynamic> map) {
    return ProductEfficiencyModel(
      id: map['id'] as int,
      type: map['type'] != null ? map['type'] as String : null,
      product: map['product'] != null ? map['product'] as String : null,
      gloss: map['gloss'] != null ? map['gloss'] as String : null,
      manufacturer:
          map['manufacturer'] != null ? map['manufacturer'] as String : null,
      base: map['base'] != null ? map['base'] as String : null,
      ease_of_dilution: map['ease_of_dilution'] != null
          ? map['ease_of_dilution'] as double
          : null,
      ease_of_application: map['ease_of_application'] != null
          ? map['ease_of_application'] as double
          : null,
      number_of_coats: map['number_of_coats'] != null
          ? map['number_of_coats'] as double
          : null,
      smoothness:
          map['smoothness'] != null ? map['smoothness'] as double : null,
      whiteness: map['whiteness'] != null ? map['whiteness'] as double : null,
      opacity: map['opacity'] != null ? map['opacity'] as double : null,
      total_opacity:
          map['total_opacity'] != null ? map['total_opacity'] as double : null,
      coverage_per_liter: map['coverage_per_liter'] != null
          ? map['coverage_per_liter'] as double
          : null,
      coverage_per_kg: map['coverage_per_kg'] != null
          ? map['coverage_per_kg'] as double
          : null,
      efficiency_level: map['efficiency_level'] != null
          ? map['efficiency_level'] as double
          : null,
      price_per_liter: map['price_per_liter'] != null
          ? map['price_per_liter'] as double
          : null,
      efficiency_price_ratio: map['efficiency_price_ratio'] != null
          ? map['efficiency_price_ratio'] as double
          : null,
      technical_notes: map['technical_notes'] != null
          ? map['technical_notes'] as String
          : null,
      sales_notes:
          map['sales_notes'] != null ? map['sales_notes'] as String : null,
      gloss_scrub_ratio: map['gloss_scrub_ratio'] != null
          ? map['gloss_scrub_ratio'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductEfficiencyModel.fromJson(String source) =>
      ProductEfficiencyModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductEfficiencyModel(id: $id, type: $type, product: $product, gloss: $gloss, manufacturer: $manufacturer, base: $base, ease_of_dilution: $ease_of_dilution, ease_of_application: $ease_of_application, number_of_coats: $number_of_coats, smoothness: $smoothness, whiteness: $whiteness, opacity: $opacity, total_opacity: $total_opacity, coverage_per_liter: $coverage_per_liter, coverage_per_kg: $coverage_per_kg, efficiency_level: $efficiency_level, price_per_liter: $price_per_liter, efficiency_price_ratio: $efficiency_price_ratio, technical_notes: $technical_notes, sales_notes: $sales_notes, gloss_scrub_ratio: $gloss_scrub_ratio)';
  }

  @override
  bool operator ==(covariant ProductEfficiencyModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.product == product &&
        other.gloss == gloss &&
        other.manufacturer == manufacturer &&
        other.base == base &&
        other.ease_of_dilution == ease_of_dilution &&
        other.ease_of_application == ease_of_application &&
        other.number_of_coats == number_of_coats &&
        other.smoothness == smoothness &&
        other.whiteness == whiteness &&
        other.opacity == opacity &&
        other.total_opacity == total_opacity &&
        other.coverage_per_liter == coverage_per_liter &&
        other.coverage_per_kg == coverage_per_kg &&
        other.efficiency_level == efficiency_level &&
        other.price_per_liter == price_per_liter &&
        other.efficiency_price_ratio == efficiency_price_ratio &&
        other.technical_notes == technical_notes &&
        other.sales_notes == sales_notes &&
        other.gloss_scrub_ratio == gloss_scrub_ratio;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        product.hashCode ^
        gloss.hashCode ^
        manufacturer.hashCode ^
        base.hashCode ^
        ease_of_dilution.hashCode ^
        ease_of_application.hashCode ^
        number_of_coats.hashCode ^
        smoothness.hashCode ^
        whiteness.hashCode ^
        opacity.hashCode ^
        total_opacity.hashCode ^
        coverage_per_liter.hashCode ^
        coverage_per_kg.hashCode ^
        efficiency_level.hashCode ^
        price_per_liter.hashCode ^
        efficiency_price_ratio.hashCode ^
        technical_notes.hashCode ^
        sales_notes.hashCode ^
        gloss_scrub_ratio.hashCode;
  }
}
