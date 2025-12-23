// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/circular_percentage.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/common/widgets/percentage_slider.dart';
import 'package:gmcappclean/core/common/widgets/searchable_dropdown.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/navigate_with_animate.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/surveys/bloc/surveys_bloc.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/homeowner_model.dart';
import 'package:gmcappclean/features/surveys/services/surveys_services.dart';
import 'package:gmcappclean/features/surveys/ui/lists/brands.dart';
import 'package:gmcappclean/features/surveys/ui/homeowner/list_homeowner_survey_page.dart';
import 'package:gmcappclean/features/surveys/ui/lists/locations.dart';
import 'package:gmcappclean/features/surveys/ui/widgets/store_items_pie_chart.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class HomeownerSurveyPage extends StatelessWidget {
  HomeownerModel? homeownerModel;
  HomeownerSurveyPage({
    super.key,
    this.homeownerModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveysBloc(SurveysServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(
        builder: (context) {
          return HomeownerSurveyPageChild(homeownerModel: homeownerModel);
        },
      ),
    );
  }
}

class HomeownerSurveyPageChild extends StatefulWidget {
  HomeownerModel? homeownerModel;
  HomeownerSurveyPageChild({
    super.key,
    this.homeownerModel,
  });

  @override
  State<HomeownerSurveyPageChild> createState() =>
      _HomeownerSurveyPageChildState();
}

class _HomeownerSurveyPageChildState extends State<HomeownerSurveyPageChild> {
  final _visitDateController = TextEditingController();
  final _visitTimeController = TextEditingController();
  final _visitorController = TextEditingController();
  final _visitDurationMinutesController = TextEditingController();
  final _regionController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _detailedAddressController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _storeVisibilityPercentageController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _paintCultureController = TextEditingController();
  final _customerDescriptionController = TextEditingController();
  final _storeSizeController = TextEditingController();
  final _paintApprovalInStoreController = TextEditingController();
  final _salesActivityDuringVisitController = TextEditingController();
  final _recommendedBrand1Controller = TextEditingController();
  final _recommendedBrand2Controller = TextEditingController();
  final _recommendedBrand3Controller = TextEditingController();
  final _recommendedBrand4Controller = TextEditingController();
  final _recommendedBrand5Controller = TextEditingController();
  final _gmcProductDisplayMethodController = TextEditingController();
  final _customerInteractionNatureController = TextEditingController();
  final _healthyPercentageController = TextEditingController();
  final _paintsPercentageController = TextEditingController();
  final _hardwarePercentageController = TextEditingController();
  final _electricalPercentageController = TextEditingController();
  final _buildingMaterialsPercentageController = TextEditingController();
  final _recommendedPaintQualityController = TextEditingController();
  final _paintsAndInsulatorsController = TextEditingController();
  final _colorantsTypeController = TextEditingController();
  final _puttySellingMethodController = TextEditingController();
  final _notesController = TextEditingController();
  final _shopCoordinatesController = TextEditingController();

  Position? _currentPosition;
  bool _isGettingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.homeownerModel != null) {
      _visitDateController.text = widget.homeownerModel!.visit_date ?? '';
      _visitTimeController.text = widget.homeownerModel!.visit_time ?? '';
      _visitorController.text = widget.homeownerModel!.visitor ?? '';
      _visitDurationMinutesController.text =
          widget.homeownerModel?.visit_duration_minutes.toString() ?? "";
      _regionController.text = widget.homeownerModel!.region ?? '';
      _storeNameController.text = widget.homeownerModel!.store_name ?? '';
      _customerNameController.text = widget.homeownerModel!.customer_name ?? '';
      _detailedAddressController.text =
          widget.homeownerModel!.detailed_address ?? '';
      _phoneNumberController.text = widget.homeownerModel!.phone_number ?? '';
      _mobileNumberController.text = widget.homeownerModel!.mobile_number ?? '';
      _storeVisibilityPercentageController.text =
          widget.homeownerModel?.store_visibility_percentage?.toString() ?? "";
      _businessTypeController.text = widget.homeownerModel!.business_type ?? '';
      _paintCultureController.text = widget.homeownerModel!.paint_culture ?? '';
      _customerDescriptionController.text =
          widget.homeownerModel!.customer_description ?? '';
      _storeSizeController.text = widget.homeownerModel!.store_size ?? '';
      _paintApprovalInStoreController.text =
          widget.homeownerModel!.paint_approval_in_store ?? '';
      _salesActivityDuringVisitController.text =
          widget.homeownerModel!.sales_activity_during_visit ?? '';
      _recommendedBrand1Controller.text =
          widget.homeownerModel!.recommended_brand_1 ?? '';
      _recommendedBrand2Controller.text =
          widget.homeownerModel!.recommended_brand_2 ?? '';
      _recommendedBrand3Controller.text =
          widget.homeownerModel!.recommended_brand_3 ?? '';
      _recommendedBrand4Controller.text =
          widget.homeownerModel!.recommended_brand_4 ?? '';
      _recommendedBrand5Controller.text =
          widget.homeownerModel!.recommended_brand_5 ?? '';
      _gmcProductDisplayMethodController.text =
          widget.homeownerModel!.gmc_product_display_method ?? '';
      _customerInteractionNatureController.text =
          widget.homeownerModel!.customer_interaction_nature ?? '';
      _healthyPercentageController.text =
          widget.homeownerModel?.healthy_percentage?.toString() ?? "";
      _paintsPercentageController.text =
          widget.homeownerModel?.paints_percentage?.toString() ?? "";
      _hardwarePercentageController.text =
          widget.homeownerModel?.hardware_percentage?.toString() ?? "";
      _electricalPercentageController.text =
          widget.homeownerModel?.electrical_percentage?.toString() ?? "";
      _buildingMaterialsPercentageController.text =
          widget.homeownerModel?.building_materials_percentage?.toString() ??
              "";
      _recommendedPaintQualityController.text =
          widget.homeownerModel!.recommended_paint_quality ?? '';
      _paintsAndInsulatorsController.text =
          widget.homeownerModel!.paints_and_insulators ?? '';
      _colorantsTypeController.text =
          widget.homeownerModel!.colorants_type ?? '';
      _puttySellingMethodController.text =
          widget.homeownerModel!.putty_selling_method ?? '';
      _notesController.text = widget.homeownerModel!.notes ?? '';
      _shopCoordinatesController.text =
          widget.homeownerModel!.shop_coordinates ?? '';
    }
    businessType = [
      'مفرق',
      'نصف جملة',
      'جملة',
    ];
    paintCulture = [
      'فني',
      'ملم',
      'بائع',
    ];
    customerDescription = [
      'صاحب محل',
      'شغيل',
    ];
    storeSize = [
      'صغير',
      'متوسط',
      'كبير',
    ];
    paintApprovalInStore = [
      'رئيسي',
      'ثانوي',
      'على الطلب',
      'غير متعامل',
    ];
    salesActivityDuringVisit = [
      'قوية',
      'متوسطة',
      'ضعيفة',
      'لا يوجد حركة',
    ];
    gmcProductDisplayMethod = [
      'واجهة',
      'في الداخل بشكل واضح',
      'موجود ولكن غير مرئي',
      'الجمس غير متوفر',
    ];
    customerInteractionNature = [
      'متعاون',
      'عملي',
      'غير متعاون',
    ];
    recommendedPaintQuality = [
      'نخب أول',
      'متوسط',
      'اقتصادي',
      'غير محدد',
    ];
    paintsAndInsulators = [
      'دهانات فقط',
      'عوازل فقط',
      'دهانات وعوازل',
    ];
    colorantsType = [
      'رهونجي',
      'روائع',
      'جمس',
      'أخرى',
      'لا يوجد',
    ];
    puttySellingMethod = [
      'جاهزة',
      'تجميعي',
      'لا يوجد',
    ];
    storeSize = [
      'صغير',
      'متوسط',
      'كبير',
    ];
    regions = Locations.regions;
    paintsItems = Brands.brands;
  }

  @override
  void dispose() {
    _visitDateController.dispose();
    _visitTimeController.dispose();
    _visitorController.dispose();
    _visitDurationMinutesController.dispose();
    _regionController.dispose();
    _storeNameController.dispose();
    _customerNameController.dispose();
    _detailedAddressController.dispose();
    _phoneNumberController.dispose();
    _mobileNumberController.dispose();
    _storeVisibilityPercentageController.dispose();
    _businessTypeController.dispose();
    _paintCultureController.dispose();
    _customerDescriptionController.dispose();
    _storeSizeController.dispose();
    _paintApprovalInStoreController.dispose();
    _salesActivityDuringVisitController.dispose();
    _recommendedBrand1Controller.dispose();
    _recommendedBrand2Controller.dispose();
    _recommendedBrand3Controller.dispose();
    _recommendedBrand4Controller.dispose();
    _recommendedBrand5Controller.dispose();
    _gmcProductDisplayMethodController.dispose();
    _customerInteractionNatureController.dispose();
    _healthyPercentageController.dispose();
    _paintsPercentageController.dispose();
    _hardwarePercentageController.dispose();
    _electricalPercentageController.dispose();
    _buildingMaterialsPercentageController.dispose();
    _recommendedPaintQualityController.dispose();
    _paintsAndInsulatorsController.dispose();
    _colorantsTypeController.dispose();
    _puttySellingMethodController.dispose();
    _notesController.dispose();
    _shopCoordinatesController.dispose();

    super.dispose();
  }

  // Location Methods
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showSnackBar(
            context: context,
            content: 'تم رفض إذن الموقع',
            failure: true,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showSnackBar(
          context: context,
          content:
              'تم رفض إذن الموقع بشكل دائم. يرجى تمكينه من إعدادات التطبيق',
          failure: true,
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _shopCoordinatesController.text =
            "${position.latitude},${position.longitude}";
      });

      showSnackBar(
        context: context,
        content: 'تم الحصول على الإحداثيات بنجاح',
        failure: false,
      );
    } catch (e) {
      print("Error getting location: $e");
      showSnackBar(
        context: context,
        content: 'حدث خطأ أثناء الحصول على الموقع: $e',
        failure: true,
      );
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  Future<void> _openCoordinatesInMap() async {
    final coordinates = _shopCoordinatesController.text.trim();

    if (coordinates.isEmpty) {
      showSnackBar(
        context: context,
        content: 'لا توجد إحداثيات مضافة',
        failure: true,
      );
      return;
    }

    final url = 'https://www.google.com/maps/search/?api=1&query=$coordinates';

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      showSnackBar(
        context: context,
        content: 'تعذر فتح خرائط جوجل: $e',
        failure: true,
      );
    }
  }

  void _deleteCoordinates() {
    setState(() {
      _shopCoordinatesController.clear();
      _currentPosition = null;
    });
    showSnackBar(
      context: context,
      content: 'تم حذف الإحداثيات',
      failure: false,
    );
  }

  late List<String> regions;
  late List<String> paintsItems;
  late List<String> businessType;
  List<DropdownMenuItem<String>> dropdownBusinessTypeItems() {
    return businessType.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> paintCulture;
  List<DropdownMenuItem<String>> dropdownPaintCultureItems() {
    return paintCulture.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> customerDescription;
  List<DropdownMenuItem<String>> dropdownCustomerDescriptionItems() {
    return customerDescription.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> storeSize;
  List<DropdownMenuItem<String>> dropdownStoreSizeItems() {
    return storeSize.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> paintApprovalInStore;
  List<DropdownMenuItem<String>> dropdownPaintApprovalInStoreItems() {
    return paintApprovalInStore.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> salesActivityDuringVisit;
  List<DropdownMenuItem<String>> dropdownSalesActivityDuringVisitItems() {
    return salesActivityDuringVisit.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> gmcProductDisplayMethod;
  List<DropdownMenuItem<String>> dropdownGmcProductDisplayMethodItems() {
    return gmcProductDisplayMethod.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> customerInteractionNature;
  List<DropdownMenuItem<String>> dropdownCustomerInteractionNatureItems() {
    return customerInteractionNature.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> recommendedPaintQuality;
  List<DropdownMenuItem<String>> dropdownRecommendedPaintQualityItems() {
    return recommendedPaintQuality.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> paintsAndInsulators;
  List<DropdownMenuItem<String>> dropdownPaintsAndInsulatorsItems() {
    return paintsAndInsulators.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> colorantsType;
  List<DropdownMenuItem<String>> dropdownColorantsTypeItems() {
    return colorantsType.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  late List<String> puttySellingMethod;
  List<DropdownMenuItem<String>> dropdownPuttySellingMethodItems() {
    return puttySellingMethod.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  // Helper method to create a section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  // Helper method to wrap form fields for responsive layout
  List<Widget> _buildFormFields(
      List<Widget> fields, BuildContext context, bool isDesktop) {
    if (isDesktop) {
      // For desktop, arrange in a two-column grid using Wrap
      return fields
          .map((field) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width / 2 - 40, // Two columns
                  child: field,
                ),
              ))
          .toList();
    } else {
      // For mobile, keep the single column
      return fields
          .map((field) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: field,
              ))
          .toList();
    }
  }

  Widget _buildVisitInformationFields(BuildContext context, bool isDesktop) {
    final fields = [
      MyTextField(
        controller: _visitorController,
        labelText: 'القائم بالزيارة',
      ),
      MyTextField(
        readOnly: true,
        controller: _visitDateController,
        labelText: 'تاريخ الزيارة',
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            setState(() {
              _visitDateController.text =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
            });
          }
        },
      ),
      MyTextField(
        controller: _visitTimeController,
        labelText: 'وقت الزيارة',
        readOnly: true,
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            final now = DateTime.now();
            final formattedTime = DateFormat('HH:mm').format(
              DateTime(now.year, now.month, now.day, pickedTime.hour,
                  pickedTime.minute),
            );
            _visitTimeController.text = formattedTime;
          }
        },
      ),
      MyTextField(
        controller: _visitDurationMinutesController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        labelText: 'مدة الزيارة بالدقائق',
      ),
    ];
    return isDesktop
        ? Wrap(
            spacing: 16.0,
            runSpacing: 0.0,
            children: _buildFormFields(fields, context, isDesktop),
          )
        : Column(children: _buildFormFields(fields, context, isDesktop));
  }

  Widget _buildCustomerAndStoreDetails(BuildContext context, bool isDesktop) {
    final fields = [
      SearchableDropdown(
        controller: _regionController,
        labelText: 'المنطقة',
        items: regions,
      ),
      MyTextField(
        controller: _customerNameController,
        labelText: 'اسم الزبون',
      ),
      MyTextField(
        controller: _storeNameController,
        labelText: 'اسم المحل',
      ),
      MyTextField(
        controller: _detailedAddressController,
        labelText: 'عنوان المحل بالتفصيل',
      ),
      MyTextField(
        controller: _phoneNumberController,
        labelText: 'رقم الهاتف',
      ),
      MyTextField(
        controller: _mobileNumberController,
        labelText: 'رقم الموبايل',
      ),
      PercentageSlider(
        label: "نسبة ظهور المحل",
        controller: _storeVisibilityPercentageController,
        onChanged: (value) {
          setState(() {
            _storeVisibilityPercentageController.text =
                value.round().toString();
          });
        },
      ),
      MyDropdownButton(
        value: _businessTypeController.text,
        items: dropdownBusinessTypeItems(),
        onChanged: (String? newValue) {
          setState(() {
            _businessTypeController.text = newValue ?? '';
          });
        },
        labelText: 'نوع تجارة العميل',
      ),
      MyDropdownButton(
        value: _paintCultureController.text,
        items: dropdownPaintCultureItems(),
        onChanged: (String? newValue) {
          setState(() {
            _paintCultureController.text = newValue ?? '';
          });
        },
        labelText: 'ثقافة العميل بالدهانات',
      ),
      MyDropdownButton(
        value: _customerDescriptionController.text,
        items: dropdownCustomerDescriptionItems(),
        onChanged: (String? newValue) {
          setState(() {
            _customerDescriptionController.text = newValue ?? '';
          });
        },
        labelText: 'توصيف الزبون',
      ),
      MyDropdownButton(
        value: _storeSizeController.text,
        items: dropdownStoreSizeItems(),
        onChanged: (String? newValue) {
          setState(() {
            _storeSizeController.text = newValue ?? '';
          });
        },
        labelText: 'مساحة المحل',
      ),
      MyDropdownButton(
        value: _paintApprovalInStoreController.text,
        items: dropdownPaintApprovalInStoreItems(),
        onChanged: (String? newValue) {
          setState(() {
            _paintApprovalInStoreController.text = newValue ?? '';
          });
        },
        labelText: 'اعتماد الدهانات في المحل',
      ),
      MyDropdownButton(
        value: _salesActivityDuringVisitController.text,
        items: dropdownSalesActivityDuringVisitItems(),
        onChanged: (String? newValue) {
          setState(() {
            _salesActivityDuringVisitController.text = newValue ?? '';
          });
        },
        labelText: 'حركة البيع أثناء الجولة',
      ),
      MyDropdownButton(
        value: _gmcProductDisplayMethodController.text,
        items: dropdownGmcProductDisplayMethodItems(),
        onChanged: (String? newValue) {
          setState(() {
            _gmcProductDisplayMethodController.text = newValue ?? '';
          });
        },
        labelText: 'طريقة عرض ال GMC',
      ),
      MyDropdownButton(
        value: _customerInteractionNatureController.text,
        items: dropdownCustomerInteractionNatureItems(),
        onChanged: (String? newValue) {
          setState(() {
            _customerInteractionNatureController.text = newValue ?? '';
          });
        },
        labelText: 'طبيعة التعامل مع الزبون',
      ),
    ];
    return isDesktop
        ? Wrap(
            spacing: 16.0,
            runSpacing: 0.0,
            children: _buildFormFields(fields, context, isDesktop),
          )
        : Column(children: _buildFormFields(fields, context, isDesktop));
  }

  Widget _buildCoordinatesSection(BuildContext context, bool isDesktop) {
    final coordinates = _shopCoordinatesController.text.trim();
    final hasCoordinates = coordinates.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('إحداثيات الموقع'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: MyTextField(
                controller: _shopCoordinatesController,
                labelText: 'إحداثيات المحل',
                readOnly: true,
                suffixIcon: hasCoordinates
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.map, color: Colors.green),
                            onPressed: _openCoordinatesInMap,
                            tooltip: 'فتح في خرائط جوجل',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: _deleteCoordinates,
                            tooltip: 'حذف الإحداثيات',
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            if (!hasCoordinates) ...[
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _isGettingLocation ? null : _getCurrentLocation,
                icon: _isGettingLocation
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.location_on),
                label: const Text('الحصول على الموقع'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ],
        ),
        if (hasCoordinates)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 16),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    'تم تحديد موقع المحل',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (!hasCoordinates)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
            child: Text(
              'انقر على زر "الحصول على الموقع" لتحديد إحداثيات المحل',
              style: TextStyle(
                fontSize: 12,
                color: Colors.orange.shade700,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecommendedBrands(BuildContext context, bool isDesktop) {
    final fields = [
      SearchableDropdown(
        controller: _recommendedBrand1Controller,
        labelText: 'الماركة النصيحة 1',
        items: paintsItems,
      ),
      SearchableDropdown(
        controller: _recommendedBrand2Controller,
        labelText: 'الماركة النصيحة 2',
        items: paintsItems,
      ),
      SearchableDropdown(
        controller: _recommendedBrand3Controller,
        labelText: 'الماركة النصيحة 3',
        items: paintsItems,
      ),
      SearchableDropdown(
        controller: _recommendedBrand4Controller,
        labelText: 'الماركة النصيحة 4',
        items: paintsItems,
      ),
      SearchableDropdown(
        controller: _recommendedBrand5Controller,
        labelText: 'الماركة النصيحة 5',
        items: paintsItems,
      ),
    ];

    return Column(children: _buildFormFields(fields, context, false));
  }

  Widget _buildProductMixSection() {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('توزيع بضائع المحل (نسب مئوية)'),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true, // Important
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isLandscape ? 6 : 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.79,
          children: [
            CircularPercentage(
              label: "دهانات",
              value: double.tryParse(_paintsPercentageController.text) ?? 0,
              onChanged: (v) =>
                  updatePercentage(_paintsPercentageController, v),
              color: Colors.red,
            ),
            CircularPercentage(
              label: "صحية",
              value: double.tryParse(_healthyPercentageController.text) ?? 0,
              onChanged: (v) =>
                  updatePercentage(_healthyPercentageController, v),
              color: Colors.green,
            ),
            CircularPercentage(
              label: "خرداوات",
              value: double.tryParse(_hardwarePercentageController.text) ?? 0,
              onChanged: (v) =>
                  updatePercentage(_hardwarePercentageController, v),
              color: Colors.blue,
            ),
            CircularPercentage(
              label: "كهربائيات",
              value: double.tryParse(_electricalPercentageController.text) ?? 0,
              onChanged: (v) =>
                  updatePercentage(_electricalPercentageController, v),
              color: Colors.orange,
            ),
            CircularPercentage(
              label: "مواد البناء",
              value: double.tryParse(
                      _buildingMaterialsPercentageController.text) ??
                  0,
              onChanged: (v) =>
                  updatePercentage(_buildingMaterialsPercentageController, v),
              color: Colors.purple,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StoreItemsPieChart(
                  paints:
                      double.tryParse(_paintsPercentageController.text) ?? 0,
                  healthy:
                      double.tryParse(_healthyPercentageController.text) ?? 0,
                  hardware:
                      double.tryParse(_hardwarePercentageController.text) ?? 0,
                  electrical:
                      double.tryParse(_electricalPercentageController.text) ??
                          0,
                  buildingMaterials: double.tryParse(
                          _buildingMaterialsPercentageController.text) ??
                      0,
                ),
                const SizedBox(height: 8),
                const Text(
                  'المحصلة النهائية',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalDetails(BuildContext context, bool isDesktop) {
    final fields = [
      MyDropdownButton(
        value: _recommendedPaintQualityController.text,
        items: dropdownRecommendedPaintQualityItems(),
        onChanged: (String? newValue) {
          setState(() {
            _recommendedPaintQualityController.text = newValue ?? '';
          });
        },
        labelText: 'جودة الدهانات المنصوح بها',
      ),
      MyDropdownButton(
        value: _paintsAndInsulatorsController.text,
        items: dropdownPaintsAndInsulatorsItems(),
        onChanged: (String? newValue) {
          setState(() {
            _paintsAndInsulatorsController.text = newValue ?? '';
          });
        },
        labelText: 'دهانات وعوازل',
      ),
      MyDropdownButton(
        value: _colorantsTypeController.text,
        items: dropdownColorantsTypeItems(),
        onChanged: (String? newValue) {
          setState(() {
            _colorantsTypeController.text = newValue ?? '';
          });
        },
        labelText: 'نوع الملونات',
      ),
      MyDropdownButton(
        value: _puttySellingMethodController.text,
        items: dropdownPuttySellingMethodItems(),
        onChanged: (String? newValue) {
          setState(() {
            _puttySellingMethodController.text = newValue ?? '';
          });
        },
        labelText: 'طريقة بيع المعاجين',
      ),
      MyTextField(
        controller: _notesController,
        labelText: 'ملاحظات',
        maxLines: 3, // Allow for multi-line notes
      ),
    ];
    return isDesktop
        ? Wrap(
            spacing: 16.0,
            runSpacing: 0.0,
            children: _buildFormFields(fields, context, isDesktop),
          )
        : Column(children: _buildFormFields(fields, context, isDesktop));
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Text(
            widget.homeownerModel == null ? 'إضافة استبيان' : 'تعديل استبيان',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: BlocConsumer<SurveysBloc, SurveysState>(
          listener: (context, state) {
            if (state is SurveysSuccess<HomeownerModel>) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.homeownerModel == null ? 'الإضافة' : 'التعديل'}',
                failure: false,
              );
              Navigator.pop(context);
              navigateWithAnimateReplace(
                  context, const ListHomeownerSurveyPage());
            } else if (state is SurveysError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
            } else if (state is SurveysSuccess<bool>) {
              showSnackBar(
                context: context,
                content: 'تم الحذف بنجاح',
                failure: false,
              );
              Navigator.pop(context);
              navigateWithAnimateReplace(
                  context, const ListHomeownerSurveyPage());
            }
          },
          builder: (context, state) {
            if (state is SurveysLoading) {
              return const Center(child: Loader());
            }

            // Determine if it's a desktop-sized screen (e.g., width > 800)
            final bool isDesktop = MediaQuery.of(context).size.width > 800;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('معلومات الزيارة'),
                    _buildVisitInformationFields(context, isDesktop),
                    const Divider(height: 30, thickness: 1),
                    _buildSectionTitle('تفاصيل الزبون والمحل'),
                    _buildCustomerAndStoreDetails(context, isDesktop),
                    const SizedBox(height: 16),
                    _buildCoordinatesSection(context, isDesktop),
                    const Divider(height: 30, thickness: 1),
                    _buildSectionTitle('الماركات النصيحة'),
                    _buildRecommendedBrands(context, isDesktop),
                    const Divider(height: 30, thickness: 1),
                    _buildProductMixSection(),
                    const Divider(thickness: 1),
                    _buildSectionTitle('معلومات إضافية'),
                    _buildAdditionalDetails(context, isDesktop),
                    const Divider(height: 30, thickness: 1),
                    Center(
                      child: Mybutton(
                        text: widget.homeownerModel == null ? 'إضافة' : 'تعديل',
                        onPressed: _submitForm,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (widget.homeownerModel != null)
                      Center(
                        child: IconButton(
                          icon: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withOpacity(0.2),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.5), width: 1),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const FaIcon(
                              FontAwesomeIcons.trash,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          tooltip: 'حذف',
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Wrap(
                                    children: [
                                      const ListTile(
                                        title: Text('تأكيد الحذف',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text('هل انت متأكد؟'),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('إلغاء'),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                side: BorderSide(
                                                    color: Colors.red
                                                        .withOpacity(0.3)),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              context.read<SurveysBloc>().add(
                                                    DeleteOneHomeownerSurvey(
                                                      id: widget
                                                          .homeownerModel!.id,
                                                    ),
                                                  );
                                            },
                                            child: const Text('حذف',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm() {
    double parseController(TextEditingController controller) {
      final text = controller.text.trim();
      return text.isNotEmpty ? double.tryParse(text) ?? 0 : 0;
    }

    // Validate required fields
    final List<String> missingFields = [];

    if (_visitDateController.text.trim().isEmpty) {
      missingFields.add('تاريخ الزيارة');
    }
    if (_visitTimeController.text.trim().isEmpty) {
      missingFields.add('وقت الزيارة');
    }
    if (_visitorController.text.trim().isEmpty) {
      missingFields.add('اسم الزائر');
    }
    if (_visitDurationMinutesController.text.trim().isEmpty) {
      missingFields.add('مدة الزيارة');
    }
    if (_regionController.text.trim().isEmpty) {
      missingFields.add('المنطقة');
    }

    // Optional: Add coordinates validation if you want to make it required
    // if (_shopCoordinatesController.text.trim().isEmpty) {
    //   missingFields.add('إحداثيات المحل');
    // }

    if (missingFields.isNotEmpty) {
      showSnackBar(
        context: context,
        content:
            'يرجى تعبئة الحقول المطلوبة التالية:\n${missingFields.join('، ')}',
        failure: true,
      );
      return;
    }

    // Calculate total percentage
    final totalPercentage = parseController(_paintsPercentageController) +
        parseController(_healthyPercentageController) +
        parseController(_hardwarePercentageController) +
        parseController(_electricalPercentageController) +
        parseController(_buildingMaterialsPercentageController);

    if ((totalPercentage - 100).abs() > 0.01) {
      showSnackBar(
        context: context,
        content:
            'يجب أن يكون إجمالي النسب المئوية لتوزيع البضائع بالمحل 100%. الإجمالي الحالي: ${totalPercentage.toStringAsFixed(2)}%',
        failure: true,
      );
      return;
    }

    final model = _fillModelFromForm();
    print(model);
    if (widget.homeownerModel == null) {
      context.read<SurveysBloc>().add(
            AddNewHomeownerSurvey(homeownerModel: model),
          );
    } else {
      context.read<SurveysBloc>().add(
            EditHomeownerSurvey(
              homeownerModel: model,
              id: widget.homeownerModel!.id,
            ),
          );
    }
  }

  HomeownerModel _fillModelFromForm() {
    return HomeownerModel(
      id: widget.homeownerModel?.id ?? 0,
      visit_date: _visitDateController.text,
      visit_time: _visitTimeController.text,
      visitor: _visitorController.text,
      visit_duration_minutes:
          int.tryParse(_visitDurationMinutesController.text) ?? 0,
      region: _regionController.text,
      store_name: _storeNameController.text,
      customer_name: _customerNameController.text,
      detailed_address: _detailedAddressController.text,
      phone_number: _phoneNumberController.text,
      mobile_number: _mobileNumberController.text,
      store_visibility_percentage:
          int.tryParse(_storeVisibilityPercentageController.text) ?? 0,
      business_type: _businessTypeController.text,
      paint_culture: _paintCultureController.text,
      customer_description: _customerDescriptionController.text,
      store_size:
          _storeSizeController.text.isEmpty ? null : _storeSizeController.text,
      paint_approval_in_store: _paintApprovalInStoreController.text,
      sales_activity_during_visit: _salesActivityDuringVisitController.text,
      recommended_brand_1: _recommendedBrand1Controller.text,
      recommended_brand_2: _recommendedBrand2Controller.text,
      recommended_brand_3: _recommendedBrand3Controller.text,
      recommended_brand_4: _recommendedBrand4Controller.text,
      recommended_brand_5: _recommendedBrand5Controller.text,
      gmc_product_display_method: _gmcProductDisplayMethodController.text,
      customer_interaction_nature: _customerInteractionNatureController.text,
      healthy_percentage: int.tryParse(_healthyPercentageController.text) ?? 0,
      paints_percentage: int.tryParse(_paintsPercentageController.text) ?? 0,
      hardware_percentage:
          int.tryParse(_hardwarePercentageController.text) ?? 0,
      electrical_percentage:
          int.tryParse(_electricalPercentageController.text) ?? 0,
      building_materials_percentage:
          int.tryParse(_buildingMaterialsPercentageController.text) ?? 0,
      recommended_paint_quality: _recommendedPaintQualityController.text,
      paints_and_insulators: _paintsAndInsulatorsController.text,
      colorants_type: _colorantsTypeController.text,
      putty_selling_method: _puttySellingMethodController.text,
      notes: _notesController.text,
      shop_coordinates: _shopCoordinatesController.text.trim().isEmpty
          ? null
          : _shopCoordinatesController.text.trim(),
    );
  }

  void updatePercentage(TextEditingController controller, double newValue) {
    double total = (double.tryParse(_paintsPercentageController.text) ?? 0) +
        (double.tryParse(_healthyPercentageController.text) ?? 0) +
        (double.tryParse(_hardwarePercentageController.text) ?? 0) +
        (double.tryParse(_electricalPercentageController.text) ?? 0) +
        (double.tryParse(_buildingMaterialsPercentageController.text) ?? 0);

    // Calculate available space left
    double oldValue = double.tryParse(controller.text) ?? 0;
    double delta = newValue - oldValue;
    if (total + delta > 100) {
      newValue = oldValue + (100 - total); // cap it so total <= 100
    }

    setState(() {
      controller.text = newValue.round().toString();
    });
  }
}
