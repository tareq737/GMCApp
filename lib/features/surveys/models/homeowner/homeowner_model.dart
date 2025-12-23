// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HomeownerModel {
  int id;
  String? visit_date;
  String? visit_time;
  String? visitor;
  int? visit_duration_minutes;
  String? region;
  String? store_name;
  String? customer_name;
  String? detailed_address;
  String? phone_number;
  String? mobile_number;
  int? store_visibility_percentage;
  String? business_type;
  String? paint_culture;
  String? customer_description;
  String? store_size;
  String? paint_approval_in_store;
  String? sales_activity_during_visit;
  String? recommended_brand_1;
  String? recommended_brand_2;
  String? recommended_brand_3;
  String? recommended_brand_4;
  String? recommended_brand_5;
  String? gmc_product_display_method;
  String? customer_interaction_nature;
  int? healthy_percentage;
  int? paints_percentage;
  int? hardware_percentage;
  int? electrical_percentage;
  int? building_materials_percentage;
  String? recommended_paint_quality;
  String? paints_and_insulators;
  String? colorants_type;
  String? putty_selling_method;
  String? notes;
  String? shop_coordinates;
  HomeownerModel({
    required this.id,
    this.visit_date,
    this.visit_time,
    this.visitor,
    this.visit_duration_minutes,
    this.region,
    this.store_name,
    this.customer_name,
    this.detailed_address,
    this.phone_number,
    this.mobile_number,
    this.store_visibility_percentage,
    this.business_type,
    this.paint_culture,
    this.customer_description,
    this.store_size,
    this.paint_approval_in_store,
    this.sales_activity_during_visit,
    this.recommended_brand_1,
    this.recommended_brand_2,
    this.recommended_brand_3,
    this.recommended_brand_4,
    this.recommended_brand_5,
    this.gmc_product_display_method,
    this.customer_interaction_nature,
    this.healthy_percentage,
    this.paints_percentage,
    this.hardware_percentage,
    this.electrical_percentage,
    this.building_materials_percentage,
    this.recommended_paint_quality,
    this.paints_and_insulators,
    this.colorants_type,
    this.putty_selling_method,
    this.notes,
    this.shop_coordinates,
  });

  HomeownerModel copyWith({
    int? id,
    String? visit_date,
    String? visit_time,
    String? visitor,
    int? visit_duration_minutes,
    String? region,
    String? store_name,
    String? customer_name,
    String? detailed_address,
    String? phone_number,
    String? mobile_number,
    int? store_visibility_percentage,
    String? business_type,
    String? paint_culture,
    String? customer_description,
    String? store_size,
    String? paint_approval_in_store,
    String? sales_activity_during_visit,
    String? recommended_brand_1,
    String? recommended_brand_2,
    String? recommended_brand_3,
    String? recommended_brand_4,
    String? recommended_brand_5,
    String? gmc_product_display_method,
    String? customer_interaction_nature,
    int? healthy_percentage,
    int? paints_percentage,
    int? hardware_percentage,
    int? electrical_percentage,
    int? building_materials_percentage,
    String? recommended_paint_quality,
    String? paints_and_insulators,
    String? colorants_type,
    String? putty_selling_method,
    String? notes,
    String? shop_coordinates,
  }) {
    return HomeownerModel(
      id: id ?? this.id,
      visit_date: visit_date ?? this.visit_date,
      visit_time: visit_time ?? this.visit_time,
      visitor: visitor ?? this.visitor,
      visit_duration_minutes:
          visit_duration_minutes ?? this.visit_duration_minutes,
      region: region ?? this.region,
      store_name: store_name ?? this.store_name,
      customer_name: customer_name ?? this.customer_name,
      detailed_address: detailed_address ?? this.detailed_address,
      phone_number: phone_number ?? this.phone_number,
      mobile_number: mobile_number ?? this.mobile_number,
      store_visibility_percentage:
          store_visibility_percentage ?? this.store_visibility_percentage,
      business_type: business_type ?? this.business_type,
      paint_culture: paint_culture ?? this.paint_culture,
      customer_description: customer_description ?? this.customer_description,
      store_size: store_size ?? this.store_size,
      paint_approval_in_store:
          paint_approval_in_store ?? this.paint_approval_in_store,
      sales_activity_during_visit:
          sales_activity_during_visit ?? this.sales_activity_during_visit,
      recommended_brand_1: recommended_brand_1 ?? this.recommended_brand_1,
      recommended_brand_2: recommended_brand_2 ?? this.recommended_brand_2,
      recommended_brand_3: recommended_brand_3 ?? this.recommended_brand_3,
      recommended_brand_4: recommended_brand_4 ?? this.recommended_brand_4,
      recommended_brand_5: recommended_brand_5 ?? this.recommended_brand_5,
      gmc_product_display_method:
          gmc_product_display_method ?? this.gmc_product_display_method,
      customer_interaction_nature:
          customer_interaction_nature ?? this.customer_interaction_nature,
      healthy_percentage: healthy_percentage ?? this.healthy_percentage,
      paints_percentage: paints_percentage ?? this.paints_percentage,
      hardware_percentage: hardware_percentage ?? this.hardware_percentage,
      electrical_percentage:
          electrical_percentage ?? this.electrical_percentage,
      building_materials_percentage:
          building_materials_percentage ?? this.building_materials_percentage,
      recommended_paint_quality:
          recommended_paint_quality ?? this.recommended_paint_quality,
      paints_and_insulators:
          paints_and_insulators ?? this.paints_and_insulators,
      colorants_type: colorants_type ?? this.colorants_type,
      putty_selling_method: putty_selling_method ?? this.putty_selling_method,
      notes: notes ?? this.notes,
      shop_coordinates: shop_coordinates ?? this.shop_coordinates,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'visit_date': visit_date,
      'visit_time': visit_time,
      'visitor': visitor,
      'visit_duration_minutes': visit_duration_minutes,
      'region': region,
      'store_name': store_name,
      'customer_name': customer_name,
      'detailed_address': detailed_address,
      'phone_number': phone_number,
      'mobile_number': mobile_number,
      'store_visibility_percentage': store_visibility_percentage,
      'business_type': business_type,
      'paint_culture': paint_culture,
      'customer_description': customer_description,
      'store_size': store_size,
      'paint_approval_in_store': paint_approval_in_store,
      'sales_activity_during_visit': sales_activity_during_visit,
      'recommended_brand_1': recommended_brand_1,
      'recommended_brand_2': recommended_brand_2,
      'recommended_brand_3': recommended_brand_3,
      'recommended_brand_4': recommended_brand_4,
      'recommended_brand_5': recommended_brand_5,
      'gmc_product_display_method': gmc_product_display_method,
      'customer_interaction_nature': customer_interaction_nature,
      'healthy_percentage': healthy_percentage,
      'paints_percentage': paints_percentage,
      'hardware_percentage': hardware_percentage,
      'electrical_percentage': electrical_percentage,
      'building_materials_percentage': building_materials_percentage,
      'recommended_paint_quality': recommended_paint_quality,
      'paints_and_insulators': paints_and_insulators,
      'colorants_type': colorants_type,
      'putty_selling_method': putty_selling_method,
      'notes': notes,
      'shop_coordinates': shop_coordinates,
    };
  }

  factory HomeownerModel.fromMap(Map<String, dynamic> map) {
    return HomeownerModel(
      id: map['id'] as int,
      visit_date:
          map['visit_date'] != null ? map['visit_date'] as String : null,
      visit_time:
          map['visit_time'] != null ? map['visit_time'] as String : null,
      visitor: map['visitor'] != null ? map['visitor'] as String : null,
      visit_duration_minutes: map['visit_duration_minutes'] != null
          ? map['visit_duration_minutes'] as int
          : null,
      region: map['region'] != null ? map['region'] as String : null,
      store_name:
          map['store_name'] != null ? map['store_name'] as String : null,
      customer_name:
          map['customer_name'] != null ? map['customer_name'] as String : null,
      detailed_address: map['detailed_address'] != null
          ? map['detailed_address'] as String
          : null,
      phone_number:
          map['phone_number'] != null ? map['phone_number'] as String : null,
      mobile_number:
          map['mobile_number'] != null ? map['mobile_number'] as String : null,
      store_visibility_percentage: map['store_visibility_percentage'] != null
          ? map['store_visibility_percentage'] as int
          : null,
      business_type:
          map['business_type'] != null ? map['business_type'] as String : null,
      paint_culture:
          map['paint_culture'] != null ? map['paint_culture'] as String : null,
      customer_description: map['customer_description'] != null
          ? map['customer_description'] as String
          : null,
      store_size:
          map['store_size'] != null ? map['store_size'] as String : null,
      paint_approval_in_store: map['paint_approval_in_store'] != null
          ? map['paint_approval_in_store'] as String
          : null,
      sales_activity_during_visit: map['sales_activity_during_visit'] != null
          ? map['sales_activity_during_visit'] as String
          : null,
      recommended_brand_1: map['recommended_brand_1'] != null
          ? map['recommended_brand_1'] as String
          : null,
      recommended_brand_2: map['recommended_brand_2'] != null
          ? map['recommended_brand_2'] as String
          : null,
      recommended_brand_3: map['recommended_brand_3'] != null
          ? map['recommended_brand_3'] as String
          : null,
      recommended_brand_4: map['recommended_brand_4'] != null
          ? map['recommended_brand_4'] as String
          : null,
      recommended_brand_5: map['recommended_brand_5'] != null
          ? map['recommended_brand_5'] as String
          : null,
      gmc_product_display_method: map['gmc_product_display_method'] != null
          ? map['gmc_product_display_method'] as String
          : null,
      customer_interaction_nature: map['customer_interaction_nature'] != null
          ? map['customer_interaction_nature'] as String
          : null,
      healthy_percentage: map['healthy_percentage'] != null
          ? map['healthy_percentage'] as int
          : null,
      paints_percentage: map['paints_percentage'] != null
          ? map['paints_percentage'] as int
          : null,
      hardware_percentage: map['hardware_percentage'] != null
          ? map['hardware_percentage'] as int
          : null,
      electrical_percentage: map['electrical_percentage'] != null
          ? map['electrical_percentage'] as int
          : null,
      building_materials_percentage:
          map['building_materials_percentage'] != null
              ? map['building_materials_percentage'] as int
              : null,
      recommended_paint_quality: map['recommended_paint_quality'] != null
          ? map['recommended_paint_quality'] as String
          : null,
      paints_and_insulators: map['paints_and_insulators'] != null
          ? map['paints_and_insulators'] as String
          : null,
      colorants_type: map['colorants_type'] != null
          ? map['colorants_type'] as String
          : null,
      putty_selling_method: map['putty_selling_method'] != null
          ? map['putty_selling_method'] as String
          : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      shop_coordinates: map['shop_coordinates'] != null
          ? map['shop_coordinates'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeownerModel.fromJson(String source) =>
      HomeownerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HomeownerModel(id: $id, visit_date: $visit_date, visit_time: $visit_time, visitor: $visitor, visit_duration_minutes: $visit_duration_minutes, region: $region, store_name: $store_name, customer_name: $customer_name, detailed_address: $detailed_address, phone_number: $phone_number, mobile_number: $mobile_number, store_visibility_percentage: $store_visibility_percentage, business_type: $business_type, paint_culture: $paint_culture, customer_description: $customer_description, store_size: $store_size, paint_approval_in_store: $paint_approval_in_store, sales_activity_during_visit: $sales_activity_during_visit, recommended_brand_1: $recommended_brand_1, recommended_brand_2: $recommended_brand_2, recommended_brand_3: $recommended_brand_3, recommended_brand_4: $recommended_brand_4, recommended_brand_5: $recommended_brand_5, gmc_product_display_method: $gmc_product_display_method, customer_interaction_nature: $customer_interaction_nature, healthy_percentage: $healthy_percentage, paints_percentage: $paints_percentage, hardware_percentage: $hardware_percentage, electrical_percentage: $electrical_percentage, building_materials_percentage: $building_materials_percentage, recommended_paint_quality: $recommended_paint_quality, paints_and_insulators: $paints_and_insulators, colorants_type: $colorants_type, putty_selling_method: $putty_selling_method, notes: $notes, shop_coordinates: $shop_coordinates)';
  }

  @override
  bool operator ==(covariant HomeownerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.visit_date == visit_date &&
        other.visit_time == visit_time &&
        other.visitor == visitor &&
        other.visit_duration_minutes == visit_duration_minutes &&
        other.region == region &&
        other.store_name == store_name &&
        other.customer_name == customer_name &&
        other.detailed_address == detailed_address &&
        other.phone_number == phone_number &&
        other.mobile_number == mobile_number &&
        other.store_visibility_percentage == store_visibility_percentage &&
        other.business_type == business_type &&
        other.paint_culture == paint_culture &&
        other.customer_description == customer_description &&
        other.store_size == store_size &&
        other.paint_approval_in_store == paint_approval_in_store &&
        other.sales_activity_during_visit == sales_activity_during_visit &&
        other.recommended_brand_1 == recommended_brand_1 &&
        other.recommended_brand_2 == recommended_brand_2 &&
        other.recommended_brand_3 == recommended_brand_3 &&
        other.recommended_brand_4 == recommended_brand_4 &&
        other.recommended_brand_5 == recommended_brand_5 &&
        other.gmc_product_display_method == gmc_product_display_method &&
        other.customer_interaction_nature == customer_interaction_nature &&
        other.healthy_percentage == healthy_percentage &&
        other.paints_percentage == paints_percentage &&
        other.hardware_percentage == hardware_percentage &&
        other.electrical_percentage == electrical_percentage &&
        other.building_materials_percentage == building_materials_percentage &&
        other.recommended_paint_quality == recommended_paint_quality &&
        other.paints_and_insulators == paints_and_insulators &&
        other.colorants_type == colorants_type &&
        other.putty_selling_method == putty_selling_method &&
        other.notes == notes &&
        other.shop_coordinates == shop_coordinates;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        visit_date.hashCode ^
        visit_time.hashCode ^
        visitor.hashCode ^
        visit_duration_minutes.hashCode ^
        region.hashCode ^
        store_name.hashCode ^
        customer_name.hashCode ^
        detailed_address.hashCode ^
        phone_number.hashCode ^
        mobile_number.hashCode ^
        store_visibility_percentage.hashCode ^
        business_type.hashCode ^
        paint_culture.hashCode ^
        customer_description.hashCode ^
        store_size.hashCode ^
        paint_approval_in_store.hashCode ^
        sales_activity_during_visit.hashCode ^
        recommended_brand_1.hashCode ^
        recommended_brand_2.hashCode ^
        recommended_brand_3.hashCode ^
        recommended_brand_4.hashCode ^
        recommended_brand_5.hashCode ^
        gmc_product_display_method.hashCode ^
        customer_interaction_nature.hashCode ^
        healthy_percentage.hashCode ^
        paints_percentage.hashCode ^
        hardware_percentage.hashCode ^
        electrical_percentage.hashCode ^
        building_materials_percentage.hashCode ^
        recommended_paint_quality.hashCode ^
        paints_and_insulators.hashCode ^
        colorants_type.hashCode ^
        putty_selling_method.hashCode ^
        notes.hashCode ^
        shop_coordinates.hashCode;
  }
}
