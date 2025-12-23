// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SalesModel {
  int id;
  String? applicant_name;
  int? applicant;
  String? customer_name;
  String? shop_name;
  String? region_name;
  int? customer;
  String? date;
  int? healthy_percentage;
  int? paints_percentage;
  int? hardware_percentage;
  int? electrical_percentage;
  int? building_materials_percentage;
  int? rating_current_year;
  int? rating_last_year;
  int? rating_two_years_ago;
  int? rating_three_years_ago;
  int? rating_four_years_ago;
  int? oil_paints_sold_precentage;
  int? oil_paints_slow_percentage;
  int? oil_paints_slow_best_percenatge;
  String? oil_paints_slow_best_brand;
  int? oil_paints_slow_mid_percenatge;
  String? oil_paints_slow_mid_brand;
  int? oil_paints_slow_eco_percenatge;
  String? oil_paints_slow_eco_brand;
  int? oil_paints_fast_percentage;
  int? oil_paints_fast_best_percenatge;
  String? oil_paints_fast_best_brand;
  int? oil_paints_fast_mid_percenatge;
  String? oil_paints_fast_mid_brand;
  int? oil_paints_fast_eco_percenatge;
  String? oil_paints_fast_eco_brand;
  int? oil_paints_ind_percentage;
  int? oil_paints_ind_best_percenatge;
  String? oil_paints_ind_best_brand;
  int? oil_paints_ind_mid_percenatge;
  String? oil_paints_ind_mid_brand;
  int? oil_paints_ind_eco_percenatge;
  String? oil_paints_ind_eco_brand;
  int? emul_paints_sold_precentage;
  int? emul_paints_water_percentage;
  int? emul_paints_water_best_percenatge;
  String? emul_paints_water_best_brand;
  int? emul_paints_water_mid_percenatge;
  String? emul_paints_water_mid_brand;
  int? emul_paints_water_eco_percenatge;
  String? emul_paints_water_eco_brand;
  int? emul_paints_acrylic_percentage;
  int? emul_paints_acrylic_best_percenatge;
  String? emul_paints_acrylic_best_brand;
  int? emul_paints_acrylic_mid_percenatge;
  String? emul_paints_acrylic_mid_brand;
  int? emul_paints_acrylic_eco_percenatge;
  String? emul_paints_acrylic_eco_brand;
  int? emul_paints_deco_putty_percentage;
  int? emul_paints_deco_putty_best_percenatge;
  String? emul_paints_deco_putty_best_brand;
  int? emul_paints_deco_putty_mid_percenatge;
  String? emul_paints_deco_putty_mid_brand;
  int? emul_paints_deco_putty_eco_percenatge;
  String? emul_paints_deco_putty_eco_brand;
  List<String>? present_brands;
  List<String>? new_brands;
  List<String>? declining_brands;
  String? notes;
  List<int>? company_advantages;
  List<int>? company_disadvantages;
  SalesModel({
    required this.id,
    this.applicant_name,
    this.applicant,
    this.customer_name,
    this.shop_name,
    this.region_name,
    this.customer,
    this.date,
    this.healthy_percentage,
    this.paints_percentage,
    this.hardware_percentage,
    this.electrical_percentage,
    this.building_materials_percentage,
    this.rating_current_year,
    this.rating_last_year,
    this.rating_two_years_ago,
    this.rating_three_years_ago,
    this.rating_four_years_ago,
    this.oil_paints_sold_precentage,
    this.oil_paints_slow_percentage,
    this.oil_paints_slow_best_percenatge,
    this.oil_paints_slow_best_brand,
    this.oil_paints_slow_mid_percenatge,
    this.oil_paints_slow_mid_brand,
    this.oil_paints_slow_eco_percenatge,
    this.oil_paints_slow_eco_brand,
    this.oil_paints_fast_percentage,
    this.oil_paints_fast_best_percenatge,
    this.oil_paints_fast_best_brand,
    this.oil_paints_fast_mid_percenatge,
    this.oil_paints_fast_mid_brand,
    this.oil_paints_fast_eco_percenatge,
    this.oil_paints_fast_eco_brand,
    this.oil_paints_ind_percentage,
    this.oil_paints_ind_best_percenatge,
    this.oil_paints_ind_best_brand,
    this.oil_paints_ind_mid_percenatge,
    this.oil_paints_ind_mid_brand,
    this.oil_paints_ind_eco_percenatge,
    this.oil_paints_ind_eco_brand,
    this.emul_paints_sold_precentage,
    this.emul_paints_water_percentage,
    this.emul_paints_water_best_percenatge,
    this.emul_paints_water_best_brand,
    this.emul_paints_water_mid_percenatge,
    this.emul_paints_water_mid_brand,
    this.emul_paints_water_eco_percenatge,
    this.emul_paints_water_eco_brand,
    this.emul_paints_acrylic_percentage,
    this.emul_paints_acrylic_best_percenatge,
    this.emul_paints_acrylic_best_brand,
    this.emul_paints_acrylic_mid_percenatge,
    this.emul_paints_acrylic_mid_brand,
    this.emul_paints_acrylic_eco_percenatge,
    this.emul_paints_acrylic_eco_brand,
    this.emul_paints_deco_putty_percentage,
    this.emul_paints_deco_putty_best_percenatge,
    this.emul_paints_deco_putty_best_brand,
    this.emul_paints_deco_putty_mid_percenatge,
    this.emul_paints_deco_putty_mid_brand,
    this.emul_paints_deco_putty_eco_percenatge,
    this.emul_paints_deco_putty_eco_brand,
    this.present_brands,
    this.new_brands,
    this.declining_brands,
    this.notes,
    this.company_advantages,
    this.company_disadvantages,
  });

  SalesModel copyWith({
    int? id,
    String? applicant_name,
    int? applicant,
    String? customer_name,
    String? shop_name,
    String? region_name,
    int? customer,
    String? date,
    int? healthy_percentage,
    int? paints_percentage,
    int? hardware_percentage,
    int? electrical_percentage,
    int? building_materials_percentage,
    int? rating_current_year,
    int? rating_last_year,
    int? rating_two_years_ago,
    int? rating_three_years_ago,
    int? rating_four_years_ago,
    int? oil_paints_sold_precentage,
    int? oil_paints_slow_percentage,
    int? oil_paints_slow_best_percenatge,
    String? oil_paints_slow_best_brand,
    int? oil_paints_slow_mid_percenatge,
    String? oil_paints_slow_mid_brand,
    int? oil_paints_slow_eco_percenatge,
    String? oil_paints_slow_eco_brand,
    int? oil_paints_fast_percentage,
    int? oil_paints_fast_best_percenatge,
    String? oil_paints_fast_best_brand,
    int? oil_paints_fast_mid_percenatge,
    String? oil_paints_fast_mid_brand,
    int? oil_paints_fast_eco_percenatge,
    String? oil_paints_fast_eco_brand,
    int? oil_paints_ind_percentage,
    int? oil_paints_ind_best_percenatge,
    String? oil_paints_ind_best_brand,
    int? oil_paints_ind_mid_percenatge,
    String? oil_paints_ind_mid_brand,
    int? oil_paints_ind_eco_percenatge,
    String? oil_paints_ind_eco_brand,
    int? emul_paints_sold_precentage,
    int? emul_paints_water_percentage,
    int? emul_paints_water_best_percenatge,
    String? emul_paints_water_best_brand,
    int? emul_paints_water_mid_percenatge,
    String? emul_paints_water_mid_brand,
    int? emul_paints_water_eco_percenatge,
    String? emul_paints_water_eco_brand,
    int? emul_paints_acrylic_percentage,
    int? emul_paints_acrylic_best_percenatge,
    String? emul_paints_acrylic_best_brand,
    int? emul_paints_acrylic_mid_percenatge,
    String? emul_paints_acrylic_mid_brand,
    int? emul_paints_acrylic_eco_percenatge,
    String? emul_paints_acrylic_eco_brand,
    int? emul_paints_deco_putty_percentage,
    int? emul_paints_deco_putty_best_percenatge,
    String? emul_paints_deco_putty_best_brand,
    int? emul_paints_deco_putty_mid_percenatge,
    String? emul_paints_deco_putty_mid_brand,
    int? emul_paints_deco_putty_eco_percenatge,
    String? emul_paints_deco_putty_eco_brand,
    List<String>? present_brands,
    List<String>? new_brands,
    List<String>? declining_brands,
    String? notes,
    List<int>? company_advantages,
    List<int>? company_disadvantages,
  }) {
    return SalesModel(
      id: id ?? this.id,
      applicant_name: applicant_name ?? this.applicant_name,
      applicant: applicant ?? this.applicant,
      customer_name: customer_name ?? this.customer_name,
      shop_name: shop_name ?? this.shop_name,
      region_name: region_name ?? this.region_name,
      customer: customer ?? this.customer,
      date: date ?? this.date,
      healthy_percentage: healthy_percentage ?? this.healthy_percentage,
      paints_percentage: paints_percentage ?? this.paints_percentage,
      hardware_percentage: hardware_percentage ?? this.hardware_percentage,
      electrical_percentage:
          electrical_percentage ?? this.electrical_percentage,
      building_materials_percentage:
          building_materials_percentage ?? this.building_materials_percentage,
      rating_current_year: rating_current_year ?? this.rating_current_year,
      rating_last_year: rating_last_year ?? this.rating_last_year,
      rating_two_years_ago: rating_two_years_ago ?? this.rating_two_years_ago,
      rating_three_years_ago:
          rating_three_years_ago ?? this.rating_three_years_ago,
      rating_four_years_ago:
          rating_four_years_ago ?? this.rating_four_years_ago,
      oil_paints_sold_precentage:
          oil_paints_sold_precentage ?? this.oil_paints_sold_precentage,
      oil_paints_slow_percentage:
          oil_paints_slow_percentage ?? this.oil_paints_slow_percentage,
      oil_paints_slow_best_percenatge: oil_paints_slow_best_percenatge ??
          this.oil_paints_slow_best_percenatge,
      oil_paints_slow_best_brand:
          oil_paints_slow_best_brand ?? this.oil_paints_slow_best_brand,
      oil_paints_slow_mid_percenatge:
          oil_paints_slow_mid_percenatge ?? this.oil_paints_slow_mid_percenatge,
      oil_paints_slow_mid_brand:
          oil_paints_slow_mid_brand ?? this.oil_paints_slow_mid_brand,
      oil_paints_slow_eco_percenatge:
          oil_paints_slow_eco_percenatge ?? this.oil_paints_slow_eco_percenatge,
      oil_paints_slow_eco_brand:
          oil_paints_slow_eco_brand ?? this.oil_paints_slow_eco_brand,
      oil_paints_fast_percentage:
          oil_paints_fast_percentage ?? this.oil_paints_fast_percentage,
      oil_paints_fast_best_percenatge: oil_paints_fast_best_percenatge ??
          this.oil_paints_fast_best_percenatge,
      oil_paints_fast_best_brand:
          oil_paints_fast_best_brand ?? this.oil_paints_fast_best_brand,
      oil_paints_fast_mid_percenatge:
          oil_paints_fast_mid_percenatge ?? this.oil_paints_fast_mid_percenatge,
      oil_paints_fast_mid_brand:
          oil_paints_fast_mid_brand ?? this.oil_paints_fast_mid_brand,
      oil_paints_fast_eco_percenatge:
          oil_paints_fast_eco_percenatge ?? this.oil_paints_fast_eco_percenatge,
      oil_paints_fast_eco_brand:
          oil_paints_fast_eco_brand ?? this.oil_paints_fast_eco_brand,
      oil_paints_ind_percentage:
          oil_paints_ind_percentage ?? this.oil_paints_ind_percentage,
      oil_paints_ind_best_percenatge:
          oil_paints_ind_best_percenatge ?? this.oil_paints_ind_best_percenatge,
      oil_paints_ind_best_brand:
          oil_paints_ind_best_brand ?? this.oil_paints_ind_best_brand,
      oil_paints_ind_mid_percenatge:
          oil_paints_ind_mid_percenatge ?? this.oil_paints_ind_mid_percenatge,
      oil_paints_ind_mid_brand:
          oil_paints_ind_mid_brand ?? this.oil_paints_ind_mid_brand,
      oil_paints_ind_eco_percenatge:
          oil_paints_ind_eco_percenatge ?? this.oil_paints_ind_eco_percenatge,
      oil_paints_ind_eco_brand:
          oil_paints_ind_eco_brand ?? this.oil_paints_ind_eco_brand,
      emul_paints_sold_precentage:
          emul_paints_sold_precentage ?? this.emul_paints_sold_precentage,
      emul_paints_water_percentage:
          emul_paints_water_percentage ?? this.emul_paints_water_percentage,
      emul_paints_water_best_percenatge: emul_paints_water_best_percenatge ??
          this.emul_paints_water_best_percenatge,
      emul_paints_water_best_brand:
          emul_paints_water_best_brand ?? this.emul_paints_water_best_brand,
      emul_paints_water_mid_percenatge: emul_paints_water_mid_percenatge ??
          this.emul_paints_water_mid_percenatge,
      emul_paints_water_mid_brand:
          emul_paints_water_mid_brand ?? this.emul_paints_water_mid_brand,
      emul_paints_water_eco_percenatge: emul_paints_water_eco_percenatge ??
          this.emul_paints_water_eco_percenatge,
      emul_paints_water_eco_brand:
          emul_paints_water_eco_brand ?? this.emul_paints_water_eco_brand,
      emul_paints_acrylic_percentage:
          emul_paints_acrylic_percentage ?? this.emul_paints_acrylic_percentage,
      emul_paints_acrylic_best_percenatge:
          emul_paints_acrylic_best_percenatge ??
              this.emul_paints_acrylic_best_percenatge,
      emul_paints_acrylic_best_brand:
          emul_paints_acrylic_best_brand ?? this.emul_paints_acrylic_best_brand,
      emul_paints_acrylic_mid_percenatge: emul_paints_acrylic_mid_percenatge ??
          this.emul_paints_acrylic_mid_percenatge,
      emul_paints_acrylic_mid_brand:
          emul_paints_acrylic_mid_brand ?? this.emul_paints_acrylic_mid_brand,
      emul_paints_acrylic_eco_percenatge: emul_paints_acrylic_eco_percenatge ??
          this.emul_paints_acrylic_eco_percenatge,
      emul_paints_acrylic_eco_brand:
          emul_paints_acrylic_eco_brand ?? this.emul_paints_acrylic_eco_brand,
      emul_paints_deco_putty_percentage: emul_paints_deco_putty_percentage ??
          this.emul_paints_deco_putty_percentage,
      emul_paints_deco_putty_best_percenatge:
          emul_paints_deco_putty_best_percenatge ??
              this.emul_paints_deco_putty_best_percenatge,
      emul_paints_deco_putty_best_brand: emul_paints_deco_putty_best_brand ??
          this.emul_paints_deco_putty_best_brand,
      emul_paints_deco_putty_mid_percenatge:
          emul_paints_deco_putty_mid_percenatge ??
              this.emul_paints_deco_putty_mid_percenatge,
      emul_paints_deco_putty_mid_brand: emul_paints_deco_putty_mid_brand ??
          this.emul_paints_deco_putty_mid_brand,
      emul_paints_deco_putty_eco_percenatge:
          emul_paints_deco_putty_eco_percenatge ??
              this.emul_paints_deco_putty_eco_percenatge,
      emul_paints_deco_putty_eco_brand: emul_paints_deco_putty_eco_brand ??
          this.emul_paints_deco_putty_eco_brand,
      present_brands: present_brands ?? this.present_brands,
      new_brands: new_brands ?? this.new_brands,
      declining_brands: declining_brands ?? this.declining_brands,
      notes: notes ?? this.notes,
      company_advantages: company_advantages ?? this.company_advantages,
      company_disadvantages:
          company_disadvantages ?? this.company_disadvantages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'applicant_name': applicant_name,
      'customer': customer,
      'date': date,
      'healthy_percentage': healthy_percentage,
      'paints_percentage': paints_percentage,
      'hardware_percentage': hardware_percentage,
      'electrical_percentage': electrical_percentage,
      'building_materials_percentage': building_materials_percentage,
      'rating_current_year': rating_current_year,
      'rating_last_year': rating_last_year,
      'rating_two_years_ago': rating_two_years_ago,
      'rating_three_years_ago': rating_three_years_ago,
      'rating_four_years_ago': rating_four_years_ago,
      'oil_paints_sold_precentage': oil_paints_sold_precentage,
      'oil_paints_slow_percentage': oil_paints_slow_percentage,
      'oil_paints_slow_best_percenatge': oil_paints_slow_best_percenatge,
      'oil_paints_slow_best_brand': oil_paints_slow_best_brand,
      'oil_paints_slow_mid_percenatge': oil_paints_slow_mid_percenatge,
      'oil_paints_slow_mid_brand': oil_paints_slow_mid_brand,
      'oil_paints_slow_eco_percenatge': oil_paints_slow_eco_percenatge,
      'oil_paints_slow_eco_brand': oil_paints_slow_eco_brand,
      'oil_paints_fast_percentage': oil_paints_fast_percentage,
      'oil_paints_fast_best_percenatge': oil_paints_fast_best_percenatge,
      'oil_paints_fast_best_brand': oil_paints_fast_best_brand,
      'oil_paints_fast_mid_percenatge': oil_paints_fast_mid_percenatge,
      'oil_paints_fast_mid_brand': oil_paints_fast_mid_brand,
      'oil_paints_fast_eco_percenatge': oil_paints_fast_eco_percenatge,
      'oil_paints_fast_eco_brand': oil_paints_fast_eco_brand,
      'oil_paints_ind_percentage': oil_paints_ind_percentage,
      'oil_paints_ind_best_percenatge': oil_paints_ind_best_percenatge,
      'oil_paints_ind_best_brand': oil_paints_ind_best_brand,
      'oil_paints_ind_mid_percenatge': oil_paints_ind_mid_percenatge,
      'oil_paints_ind_mid_brand': oil_paints_ind_mid_brand,
      'oil_paints_ind_eco_percenatge': oil_paints_ind_eco_percenatge,
      'oil_paints_ind_eco_brand': oil_paints_ind_eco_brand,
      'emul_paints_sold_precentage': emul_paints_sold_precentage,
      'emul_paints_water_percentage': emul_paints_water_percentage,
      'emul_paints_water_best_percenatge': emul_paints_water_best_percenatge,
      'emul_paints_water_best_brand': emul_paints_water_best_brand,
      'emul_paints_water_mid_percenatge': emul_paints_water_mid_percenatge,
      'emul_paints_water_mid_brand': emul_paints_water_mid_brand,
      'emul_paints_water_eco_percenatge': emul_paints_water_eco_percenatge,
      'emul_paints_water_eco_brand': emul_paints_water_eco_brand,
      'emul_paints_acrylic_percentage': emul_paints_acrylic_percentage,
      'emul_paints_acrylic_best_percenatge':
          emul_paints_acrylic_best_percenatge,
      'emul_paints_acrylic_best_brand': emul_paints_acrylic_best_brand,
      'emul_paints_acrylic_mid_percenatge': emul_paints_acrylic_mid_percenatge,
      'emul_paints_acrylic_mid_brand': emul_paints_acrylic_mid_brand,
      'emul_paints_acrylic_eco_percenatge': emul_paints_acrylic_eco_percenatge,
      'emul_paints_acrylic_eco_brand': emul_paints_acrylic_eco_brand,
      'emul_paints_deco_putty_percentage': emul_paints_deco_putty_percentage,
      'emul_paints_deco_putty_best_percenatge':
          emul_paints_deco_putty_best_percenatge,
      'emul_paints_deco_putty_best_brand': emul_paints_deco_putty_best_brand,
      'emul_paints_deco_putty_mid_percenatge':
          emul_paints_deco_putty_mid_percenatge,
      'emul_paints_deco_putty_mid_brand': emul_paints_deco_putty_mid_brand,
      'emul_paints_deco_putty_eco_percenatge':
          emul_paints_deco_putty_eco_percenatge,
      'emul_paints_deco_putty_eco_brand': emul_paints_deco_putty_eco_brand,
      'present_brands': present_brands,
      'new_brands': new_brands,
      'declining_brands': declining_brands,
      'notes': notes,
      'company_advantages': company_advantages,
      'company_disadvantages': company_disadvantages,
    };
  }

  factory SalesModel.fromMap(Map<String, dynamic> map) {
    return SalesModel(
      id: map['id'] as int,
      applicant_name: map['applicant_name'] != null
          ? map['applicant_name'] as String
          : null,
      applicant: map['applicant'] != null ? map['applicant'] as int : null,
      customer_name:
          map['customer_name'] != null ? map['customer_name'] as String : null,
      shop_name: map['shop_name'] != null ? map['shop_name'] as String : null,
      region_name:
          map['region_name'] != null ? map['region_name'] as String : null,
      customer: map['customer'] != null ? map['customer'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
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
      rating_current_year: map['rating_current_year'] != null
          ? map['rating_current_year'] as int
          : null,
      rating_last_year: map['rating_last_year'] != null
          ? map['rating_last_year'] as int
          : null,
      rating_two_years_ago: map['rating_two_years_ago'] != null
          ? map['rating_two_years_ago'] as int
          : null,
      rating_three_years_ago: map['rating_three_years_ago'] != null
          ? map['rating_three_years_ago'] as int
          : null,
      rating_four_years_ago: map['rating_four_years_ago'] != null
          ? map['rating_four_years_ago'] as int
          : null,
      oil_paints_sold_precentage: map['oil_paints_sold_precentage'] != null
          ? map['oil_paints_sold_precentage'] as int
          : null,
      oil_paints_slow_percentage: map['oil_paints_slow_percentage'] != null
          ? map['oil_paints_slow_percentage'] as int
          : null,
      oil_paints_slow_best_percenatge:
          map['oil_paints_slow_best_percenatge'] != null
              ? map['oil_paints_slow_best_percenatge'] as int
              : null,
      oil_paints_slow_best_brand: map['oil_paints_slow_best_brand'] != null
          ? map['oil_paints_slow_best_brand'] as String
          : null,
      oil_paints_slow_mid_percenatge:
          map['oil_paints_slow_mid_percenatge'] != null
              ? map['oil_paints_slow_mid_percenatge'] as int
              : null,
      oil_paints_slow_mid_brand: map['oil_paints_slow_mid_brand'] != null
          ? map['oil_paints_slow_mid_brand'] as String
          : null,
      oil_paints_slow_eco_percenatge:
          map['oil_paints_slow_eco_percenatge'] != null
              ? map['oil_paints_slow_eco_percenatge'] as int
              : null,
      oil_paints_slow_eco_brand: map['oil_paints_slow_eco_brand'] != null
          ? map['oil_paints_slow_eco_brand'] as String
          : null,
      oil_paints_fast_percentage: map['oil_paints_fast_percentage'] != null
          ? map['oil_paints_fast_percentage'] as int
          : null,
      oil_paints_fast_best_percenatge:
          map['oil_paints_fast_best_percenatge'] != null
              ? map['oil_paints_fast_best_percenatge'] as int
              : null,
      oil_paints_fast_best_brand: map['oil_paints_fast_best_brand'] != null
          ? map['oil_paints_fast_best_brand'] as String
          : null,
      oil_paints_fast_mid_percenatge:
          map['oil_paints_fast_mid_percenatge'] != null
              ? map['oil_paints_fast_mid_percenatge'] as int
              : null,
      oil_paints_fast_mid_brand: map['oil_paints_fast_mid_brand'] != null
          ? map['oil_paints_fast_mid_brand'] as String
          : null,
      oil_paints_fast_eco_percenatge:
          map['oil_paints_fast_eco_percenatge'] != null
              ? map['oil_paints_fast_eco_percenatge'] as int
              : null,
      oil_paints_fast_eco_brand: map['oil_paints_fast_eco_brand'] != null
          ? map['oil_paints_fast_eco_brand'] as String
          : null,
      oil_paints_ind_percentage: map['oil_paints_ind_percentage'] != null
          ? map['oil_paints_ind_percentage'] as int
          : null,
      oil_paints_ind_best_percenatge:
          map['oil_paints_ind_best_percenatge'] != null
              ? map['oil_paints_ind_best_percenatge'] as int
              : null,
      oil_paints_ind_best_brand: map['oil_paints_ind_best_brand'] != null
          ? map['oil_paints_ind_best_brand'] as String
          : null,
      oil_paints_ind_mid_percenatge:
          map['oil_paints_ind_mid_percenatge'] != null
              ? map['oil_paints_ind_mid_percenatge'] as int
              : null,
      oil_paints_ind_mid_brand: map['oil_paints_ind_mid_brand'] != null
          ? map['oil_paints_ind_mid_brand'] as String
          : null,
      oil_paints_ind_eco_percenatge:
          map['oil_paints_ind_eco_percenatge'] != null
              ? map['oil_paints_ind_eco_percenatge'] as int
              : null,
      oil_paints_ind_eco_brand: map['oil_paints_ind_eco_brand'] != null
          ? map['oil_paints_ind_eco_brand'] as String
          : null,
      emul_paints_sold_precentage: map['emul_paints_sold_precentage'] != null
          ? map['emul_paints_sold_precentage'] as int
          : null,
      emul_paints_water_percentage: map['emul_paints_water_percentage'] != null
          ? map['emul_paints_water_percentage'] as int
          : null,
      emul_paints_water_best_percenatge:
          map['emul_paints_water_best_percenatge'] != null
              ? map['emul_paints_water_best_percenatge'] as int
              : null,
      emul_paints_water_best_brand: map['emul_paints_water_best_brand'] != null
          ? map['emul_paints_water_best_brand'] as String
          : null,
      emul_paints_water_mid_percenatge:
          map['emul_paints_water_mid_percenatge'] != null
              ? map['emul_paints_water_mid_percenatge'] as int
              : null,
      emul_paints_water_mid_brand: map['emul_paints_water_mid_brand'] != null
          ? map['emul_paints_water_mid_brand'] as String
          : null,
      emul_paints_water_eco_percenatge:
          map['emul_paints_water_eco_percenatge'] != null
              ? map['emul_paints_water_eco_percenatge'] as int
              : null,
      emul_paints_water_eco_brand: map['emul_paints_water_eco_brand'] != null
          ? map['emul_paints_water_eco_brand'] as String
          : null,
      emul_paints_acrylic_percentage:
          map['emul_paints_acrylic_percentage'] != null
              ? map['emul_paints_acrylic_percentage'] as int
              : null,
      emul_paints_acrylic_best_percenatge:
          map['emul_paints_acrylic_best_percenatge'] != null
              ? map['emul_paints_acrylic_best_percenatge'] as int
              : null,
      emul_paints_acrylic_best_brand:
          map['emul_paints_acrylic_best_brand'] != null
              ? map['emul_paints_acrylic_best_brand'] as String
              : null,
      emul_paints_acrylic_mid_percenatge:
          map['emul_paints_acrylic_mid_percenatge'] != null
              ? map['emul_paints_acrylic_mid_percenatge'] as int
              : null,
      emul_paints_acrylic_mid_brand:
          map['emul_paints_acrylic_mid_brand'] != null
              ? map['emul_paints_acrylic_mid_brand'] as String
              : null,
      emul_paints_acrylic_eco_percenatge:
          map['emul_paints_acrylic_eco_percenatge'] != null
              ? map['emul_paints_acrylic_eco_percenatge'] as int
              : null,
      emul_paints_acrylic_eco_brand:
          map['emul_paints_acrylic_eco_brand'] != null
              ? map['emul_paints_acrylic_eco_brand'] as String
              : null,
      emul_paints_deco_putty_percentage:
          map['emul_paints_deco_putty_percentage'] != null
              ? map['emul_paints_deco_putty_percentage'] as int
              : null,
      emul_paints_deco_putty_best_percenatge:
          map['emul_paints_deco_putty_best_percenatge'] != null
              ? map['emul_paints_deco_putty_best_percenatge'] as int
              : null,
      emul_paints_deco_putty_best_brand:
          map['emul_paints_deco_putty_best_brand'] != null
              ? map['emul_paints_deco_putty_best_brand'] as String
              : null,
      emul_paints_deco_putty_mid_percenatge:
          map['emul_paints_deco_putty_mid_percenatge'] != null
              ? map['emul_paints_deco_putty_mid_percenatge'] as int
              : null,
      emul_paints_deco_putty_mid_brand:
          map['emul_paints_deco_putty_mid_brand'] != null
              ? map['emul_paints_deco_putty_mid_brand'] as String
              : null,
      emul_paints_deco_putty_eco_percenatge:
          map['emul_paints_deco_putty_eco_percenatge'] != null
              ? map['emul_paints_deco_putty_eco_percenatge'] as int
              : null,
      emul_paints_deco_putty_eco_brand:
          map['emul_paints_deco_putty_eco_brand'] != null
              ? map['emul_paints_deco_putty_eco_brand'] as String
              : null,
      present_brands: map['present_brands'] != null
          ? List<String>.from(map['present_brands'] as List)
          : null,
      new_brands: map['new_brands'] != null
          ? List<String>.from(map['new_brands'] as List)
          : null,
      declining_brands: map['declining_brands'] != null
          ? List<String>.from(map['declining_brands'] as List)
          : null,
      notes: map['notes'] != null ? map['notes'] as String : null,
      company_advantages: map['company_advantages'] != null
          ? List<int>.from(map['company_advantages'] as List)
          : null,
      company_disadvantages: map['company_disadvantages'] != null
          ? List<int>.from(map['company_disadvantages'] as List)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesModel.fromJson(String source) =>
      SalesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SalesModel(id: $id, applicant_name: $applicant_name, applicant: $applicant, customer_name: $customer_name, shop_name: $shop_name, region_name: $region_name, customer: $customer, date: $date, healthy_percentage: $healthy_percentage, paints_percentage: $paints_percentage, hardware_percentage: $hardware_percentage, electrical_percentage: $electrical_percentage, building_materials_percentage: $building_materials_percentage, rating_current_year: $rating_current_year, rating_last_year: $rating_last_year, rating_two_years_ago: $rating_two_years_ago, rating_three_years_ago: $rating_three_years_ago, rating_four_years_ago: $rating_four_years_ago, oil_paints_sold_precentage: $oil_paints_sold_precentage, oil_paints_slow_percentage: $oil_paints_slow_percentage, oil_paints_slow_best_percenatge: $oil_paints_slow_best_percenatge, oil_paints_slow_best_brand: $oil_paints_slow_best_brand, oil_paints_slow_mid_percenatge: $oil_paints_slow_mid_percenatge, oil_paints_slow_mid_brand: $oil_paints_slow_mid_brand, oil_paints_slow_eco_percenatge: $oil_paints_slow_eco_percenatge, oil_paints_slow_eco_brand: $oil_paints_slow_eco_brand, oil_paints_fast_percentage: $oil_paints_fast_percentage, oil_paints_fast_best_percenatge: $oil_paints_fast_best_percenatge, oil_paints_fast_best_brand: $oil_paints_fast_best_brand, oil_paints_fast_mid_percenatge: $oil_paints_fast_mid_percenatge, oil_paints_fast_mid_brand: $oil_paints_fast_mid_brand, oil_paints_fast_eco_percenatge: $oil_paints_fast_eco_percenatge, oil_paints_fast_eco_brand: $oil_paints_fast_eco_brand, oil_paints_ind_percentage: $oil_paints_ind_percentage, oil_paints_ind_best_percenatge: $oil_paints_ind_best_percenatge, oil_paints_ind_best_brand: $oil_paints_ind_best_brand, oil_paints_ind_mid_percenatge: $oil_paints_ind_mid_percenatge, oil_paints_ind_mid_brand: $oil_paints_ind_mid_brand, oil_paints_ind_eco_percenatge: $oil_paints_ind_eco_percenatge, oil_paints_ind_eco_brand: $oil_paints_ind_eco_brand, emul_paints_sold_precentage: $emul_paints_sold_precentage, emul_paints_water_percentage: $emul_paints_water_percentage, emul_paints_water_best_percenatge: $emul_paints_water_best_percenatge, emul_paints_water_best_brand: $emul_paints_water_best_brand, emul_paints_water_mid_percenatge: $emul_paints_water_mid_percenatge, emul_paints_water_mid_brand: $emul_paints_water_mid_brand, emul_paints_water_eco_percenatge: $emul_paints_water_eco_percenatge, emul_paints_water_eco_brand: $emul_paints_water_eco_brand, emul_paints_acrylic_percentage: $emul_paints_acrylic_percentage, emul_paints_acrylic_best_percenatge: $emul_paints_acrylic_best_percenatge, emul_paints_acrylic_best_brand: $emul_paints_acrylic_best_brand, emul_paints_acrylic_mid_percenatge: $emul_paints_acrylic_mid_percenatge, emul_paints_acrylic_mid_brand: $emul_paints_acrylic_mid_brand, emul_paints_acrylic_eco_percenatge: $emul_paints_acrylic_eco_percenatge, emul_paints_acrylic_eco_brand: $emul_paints_acrylic_eco_brand, emul_paints_deco_putty_percentage: $emul_paints_deco_putty_percentage, emul_paints_deco_putty_best_percenatge: $emul_paints_deco_putty_best_percenatge, emul_paints_deco_putty_best_brand: $emul_paints_deco_putty_best_brand, emul_paints_deco_putty_mid_percenatge: $emul_paints_deco_putty_mid_percenatge, emul_paints_deco_putty_mid_brand: $emul_paints_deco_putty_mid_brand, emul_paints_deco_putty_eco_percenatge: $emul_paints_deco_putty_eco_percenatge, emul_paints_deco_putty_eco_brand: $emul_paints_deco_putty_eco_brand, present_brands: $present_brands, new_brands: $new_brands, declining_brands: $declining_brands, notes: $notes, company_advantages: $company_advantages, company_disadvantages: $company_disadvantages)';
  }

  @override
  bool operator ==(covariant SalesModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.applicant_name == applicant_name &&
        other.applicant == applicant &&
        other.customer_name == customer_name &&
        other.shop_name == shop_name &&
        other.region_name == region_name &&
        other.customer == customer &&
        other.date == date &&
        other.healthy_percentage == healthy_percentage &&
        other.paints_percentage == paints_percentage &&
        other.hardware_percentage == hardware_percentage &&
        other.electrical_percentage == electrical_percentage &&
        other.building_materials_percentage == building_materials_percentage &&
        other.rating_current_year == rating_current_year &&
        other.rating_last_year == rating_last_year &&
        other.rating_two_years_ago == rating_two_years_ago &&
        other.rating_three_years_ago == rating_three_years_ago &&
        other.rating_four_years_ago == rating_four_years_ago &&
        other.oil_paints_sold_precentage == oil_paints_sold_precentage &&
        other.oil_paints_slow_percentage == oil_paints_slow_percentage &&
        other.oil_paints_slow_best_percenatge ==
            oil_paints_slow_best_percenatge &&
        other.oil_paints_slow_best_brand == oil_paints_slow_best_brand &&
        other.oil_paints_slow_mid_percenatge ==
            oil_paints_slow_mid_percenatge &&
        other.oil_paints_slow_mid_brand == oil_paints_slow_mid_brand &&
        other.oil_paints_slow_eco_percenatge ==
            oil_paints_slow_eco_percenatge &&
        other.oil_paints_slow_eco_brand == oil_paints_slow_eco_brand &&
        other.oil_paints_fast_percentage == oil_paints_fast_percentage &&
        other.oil_paints_fast_best_percenatge ==
            oil_paints_fast_best_percenatge &&
        other.oil_paints_fast_best_brand == oil_paints_fast_best_brand &&
        other.oil_paints_fast_mid_percenatge ==
            oil_paints_fast_mid_percenatge &&
        other.oil_paints_fast_mid_brand == oil_paints_fast_mid_brand &&
        other.oil_paints_fast_eco_percenatge ==
            oil_paints_fast_eco_percenatge &&
        other.oil_paints_fast_eco_brand == oil_paints_fast_eco_brand &&
        other.oil_paints_ind_percentage == oil_paints_ind_percentage &&
        other.oil_paints_ind_best_percenatge ==
            oil_paints_ind_best_percenatge &&
        other.oil_paints_ind_best_brand == oil_paints_ind_best_brand &&
        other.oil_paints_ind_mid_percenatge == oil_paints_ind_mid_percenatge &&
        other.oil_paints_ind_mid_brand == oil_paints_ind_mid_brand &&
        other.oil_paints_ind_eco_percenatge == oil_paints_ind_eco_percenatge &&
        other.oil_paints_ind_eco_brand == oil_paints_ind_eco_brand &&
        other.emul_paints_sold_precentage == emul_paints_sold_precentage &&
        other.emul_paints_water_percentage == emul_paints_water_percentage &&
        other.emul_paints_water_best_percenatge ==
            emul_paints_water_best_percenatge &&
        other.emul_paints_water_best_brand == emul_paints_water_best_brand &&
        other.emul_paints_water_mid_percenatge ==
            emul_paints_water_mid_percenatge &&
        other.emul_paints_water_mid_brand == emul_paints_water_mid_brand &&
        other.emul_paints_water_eco_percenatge ==
            emul_paints_water_eco_percenatge &&
        other.emul_paints_water_eco_brand == emul_paints_water_eco_brand &&
        other.emul_paints_acrylic_percentage ==
            emul_paints_acrylic_percentage &&
        other.emul_paints_acrylic_best_percenatge ==
            emul_paints_acrylic_best_percenatge &&
        other.emul_paints_acrylic_best_brand ==
            emul_paints_acrylic_best_brand &&
        other.emul_paints_acrylic_mid_percenatge ==
            emul_paints_acrylic_mid_percenatge &&
        other.emul_paints_acrylic_mid_brand == emul_paints_acrylic_mid_brand &&
        other.emul_paints_acrylic_eco_percenatge ==
            emul_paints_acrylic_eco_percenatge &&
        other.emul_paints_acrylic_eco_brand == emul_paints_acrylic_eco_brand &&
        other.emul_paints_deco_putty_percentage ==
            emul_paints_deco_putty_percentage &&
        other.emul_paints_deco_putty_best_percenatge ==
            emul_paints_deco_putty_best_percenatge &&
        other.emul_paints_deco_putty_best_brand ==
            emul_paints_deco_putty_best_brand &&
        other.emul_paints_deco_putty_mid_percenatge ==
            emul_paints_deco_putty_mid_percenatge &&
        other.emul_paints_deco_putty_mid_brand ==
            emul_paints_deco_putty_mid_brand &&
        other.emul_paints_deco_putty_eco_percenatge ==
            emul_paints_deco_putty_eco_percenatge &&
        other.emul_paints_deco_putty_eco_brand ==
            emul_paints_deco_putty_eco_brand &&
        listEquals(other.present_brands, present_brands) &&
        listEquals(other.new_brands, new_brands) &&
        listEquals(other.declining_brands, declining_brands) &&
        other.notes == notes &&
        listEquals(other.company_advantages, company_advantages) &&
        listEquals(other.company_disadvantages, company_disadvantages);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        applicant_name.hashCode ^
        applicant.hashCode ^
        customer_name.hashCode ^
        shop_name.hashCode ^
        region_name.hashCode ^
        customer.hashCode ^
        date.hashCode ^
        healthy_percentage.hashCode ^
        paints_percentage.hashCode ^
        hardware_percentage.hashCode ^
        electrical_percentage.hashCode ^
        building_materials_percentage.hashCode ^
        rating_current_year.hashCode ^
        rating_last_year.hashCode ^
        rating_two_years_ago.hashCode ^
        rating_three_years_ago.hashCode ^
        rating_four_years_ago.hashCode ^
        oil_paints_sold_precentage.hashCode ^
        oil_paints_slow_percentage.hashCode ^
        oil_paints_slow_best_percenatge.hashCode ^
        oil_paints_slow_best_brand.hashCode ^
        oil_paints_slow_mid_percenatge.hashCode ^
        oil_paints_slow_mid_brand.hashCode ^
        oil_paints_slow_eco_percenatge.hashCode ^
        oil_paints_slow_eco_brand.hashCode ^
        oil_paints_fast_percentage.hashCode ^
        oil_paints_fast_best_percenatge.hashCode ^
        oil_paints_fast_best_brand.hashCode ^
        oil_paints_fast_mid_percenatge.hashCode ^
        oil_paints_fast_mid_brand.hashCode ^
        oil_paints_fast_eco_percenatge.hashCode ^
        oil_paints_fast_eco_brand.hashCode ^
        oil_paints_ind_percentage.hashCode ^
        oil_paints_ind_best_percenatge.hashCode ^
        oil_paints_ind_best_brand.hashCode ^
        oil_paints_ind_mid_percenatge.hashCode ^
        oil_paints_ind_mid_brand.hashCode ^
        oil_paints_ind_eco_percenatge.hashCode ^
        oil_paints_ind_eco_brand.hashCode ^
        emul_paints_sold_precentage.hashCode ^
        emul_paints_water_percentage.hashCode ^
        emul_paints_water_best_percenatge.hashCode ^
        emul_paints_water_best_brand.hashCode ^
        emul_paints_water_mid_percenatge.hashCode ^
        emul_paints_water_mid_brand.hashCode ^
        emul_paints_water_eco_percenatge.hashCode ^
        emul_paints_water_eco_brand.hashCode ^
        emul_paints_acrylic_percentage.hashCode ^
        emul_paints_acrylic_best_percenatge.hashCode ^
        emul_paints_acrylic_best_brand.hashCode ^
        emul_paints_acrylic_mid_percenatge.hashCode ^
        emul_paints_acrylic_mid_brand.hashCode ^
        emul_paints_acrylic_eco_percenatge.hashCode ^
        emul_paints_acrylic_eco_brand.hashCode ^
        emul_paints_deco_putty_percentage.hashCode ^
        emul_paints_deco_putty_best_percenatge.hashCode ^
        emul_paints_deco_putty_best_brand.hashCode ^
        emul_paints_deco_putty_mid_percenatge.hashCode ^
        emul_paints_deco_putty_mid_brand.hashCode ^
        emul_paints_deco_putty_eco_percenatge.hashCode ^
        emul_paints_deco_putty_eco_brand.hashCode ^
        present_brands.hashCode ^
        new_brands.hashCode ^
        declining_brands.hashCode ^
        notes.hashCode ^
        company_advantages.hashCode ^
        company_disadvantages.hashCode;
  }
}
