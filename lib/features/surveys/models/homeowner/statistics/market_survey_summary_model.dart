// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:gmcappclean/features/surveys/models/homeowner/statistics/business_type_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/colorants_type_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/customer_description_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/customer_interaction_nature_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/gmc_product_display_method_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/paint_approval_in_store_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/paint_culture_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/paints_and_insulators_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/product_percentages_average_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/putty_selling_method_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/recommended_paint_quality_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/sales_activity_during_visit_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/store_size_model.dart';

class MarketSurveySummaryModel {
  int? gmc_market_presence_percentage;
  SalesActivityDuringVisitModel? salesActivityDuringVisitModel;
  PaintApprovalInStoreModel? paintApprovalInStoreModel;
  GmcProductDisplayMethodModel? gmcProductDisplayMethodModel;
  CustomerDescriptionModel? customerDescriptionModel;
  PuttySellingMethodModel? puttySellingMethodModel;
  CustomerInteractionNatureModel? customerInteractionNatureModel;
  StoreSizeModel? storeSizeModel;
  BusinessTypeModel? businessTypeModel;
  PaintCultureModel? paintCultureModel;
  ColorantsTypeModel? colorantsTypeModel;
  RecommendedPaintQualityModel? recommendedPaintQualityModel;
  PaintsAndInsulatorsModel? paintsAndInsulatorsModel;
  ProductPercentagesAverageModel? productPercentagesAverageModel;

  // Constructor
  MarketSurveySummaryModel({
    this.gmc_market_presence_percentage,
    this.salesActivityDuringVisitModel,
    this.paintApprovalInStoreModel,
    this.gmcProductDisplayMethodModel,
    this.customerDescriptionModel,
    this.puttySellingMethodModel,
    this.customerInteractionNatureModel,
    this.storeSizeModel,
    this.businessTypeModel,
    this.paintCultureModel,
    this.colorantsTypeModel,
    this.recommendedPaintQualityModel,
    this.paintsAndInsulatorsModel,
    this.productPercentagesAverageModel,
  });

  // Factory constructor to create instance from map
  factory MarketSurveySummaryModel.fromMap(Map<String, dynamic> map) {
    return MarketSurveySummaryModel(
      gmc_market_presence_percentage:
          map['gmc_market_presence_percentage'] as int?,
      salesActivityDuringVisitModel: map['sales_activity_during_visit'] != null
          ? SalesActivityDuringVisitModel.fromMap(
              map['sales_activity_during_visit'] as Map<String, dynamic>)
          : null,
      paintApprovalInStoreModel: map['paint_approval_in_store'] != null
          ? PaintApprovalInStoreModel.fromMap(
              map['paint_approval_in_store'] as Map<String, dynamic>)
          : null,
      gmcProductDisplayMethodModel: map['gmc_product_display_method'] != null
          ? GmcProductDisplayMethodModel.fromMap(
              map['gmc_product_display_method'] as Map<String, dynamic>)
          : null,
      customerDescriptionModel: map['customer_description'] != null
          ? CustomerDescriptionModel.fromMap(
              map['customer_description'] as Map<String, dynamic>)
          : null,
      puttySellingMethodModel: map['putty_selling_method'] != null
          ? PuttySellingMethodModel.fromMap(
              map['putty_selling_method'] as Map<String, dynamic>)
          : null,
      customerInteractionNatureModel: map['customer_interaction_nature'] != null
          ? CustomerInteractionNatureModel.fromMap(
              map['customer_interaction_nature'] as Map<String, dynamic>)
          : null,
      storeSizeModel: map['store_size'] != null
          ? StoreSizeModel.fromMap(map['store_size'] as Map<String, dynamic>)
          : null,
      businessTypeModel: map['business_type'] != null
          ? BusinessTypeModel.fromMap(
              map['business_type'] as Map<String, dynamic>)
          : null,
      paintCultureModel: map['paint_culture'] != null
          ? PaintCultureModel.fromMap(
              map['paint_culture'] as Map<String, dynamic>)
          : null,
      colorantsTypeModel: map['colorants_type'] != null
          ? ColorantsTypeModel.fromMap(
              map['colorants_type'] as Map<String, dynamic>)
          : null,
      recommendedPaintQualityModel: map['recommended_paint_quality'] != null
          ? RecommendedPaintQualityModel.fromMap(
              map['recommended_paint_quality'] as Map<String, dynamic>)
          : null,
      paintsAndInsulatorsModel: map['paints_and_insulators'] != null
          ? PaintsAndInsulatorsModel.fromMap(
              map['paints_and_insulators'] as Map<String, dynamic>)
          : null,
      productPercentagesAverageModel: map['product_percentages_average'] != null
          ? ProductPercentagesAverageModel.fromMap(
              map['product_percentages_average'] as Map<String, dynamic>)
          : null,
    );
  }
}
