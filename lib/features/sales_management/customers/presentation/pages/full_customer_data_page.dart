import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gmcappclean/core/common/widgets/counter_row_widget.dart';
import 'package:gmcappclean/core/common/widgets/full_data_widget.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/utils/select_year_function.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_view_model.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:url_launcher/url_launcher.dart';

class FullCustomerDataPage extends StatefulWidget {
  final CustomerViewModel? _customerViewModel;
  const FullCustomerDataPage({super.key, customerViewModel})
    : _customerViewModel = customerViewModel;

  @override
  State<FullCustomerDataPage> createState() => _FullCustomerDataPageState();
}

class _FullCustomerDataPageState extends State<FullCustomerDataPage> {
  bool _isLoadingOperation = false;
  late final bool hasCustomerViewModel;
  late final Map<String, TextEditingController> _controllers;
  CustomerViewModel _customerdata = CustomerViewModel(id: 0);

  List responsible = [
    'محمد العمر',
    'أحمد الناصري',
    'عبد الله عويد',
    'عبد الله دياب',
  ];
  List clientTradeType = ['مفرق', 'نصف جملة', 'جملة'];
  List clientSpread = ['ضمن المنطقة', 'ضمن المحافظة', 'خارج المحافظة'];
  List paintProffession = ['بائع', 'ملم', 'فني'];
  List dependenceOnCompany = ['رئيسي', 'ثانوي', 'على الطلب', 'غير متعامل'];
  List<String> isDirectCustomer = ['من الشركة', 'من خارج الشركة'];
  List cred = ['أمين', 'أمين مماطل', 'أمين سلعة', 'غير أمين'];

  String? boolToString(bool? value) {
    if (value == null) return null;
    return value ? 'من الشركة' : 'من خارج الشركة';
  }

  bool? stringToBool(String? value) {
    if (value == 'من الشركة') return true;
    if (value == 'من خارج الشركة') return false;
    return null;
  }

  Map<String, List<String>> regions = {
    "دمشق": [
      "التجارة",
      "العدوي",
      "القصور",
      "باب سريجة",
      "باب مصلى",
      "برامكة",
      "برج الروس",
      "برزة",
      "جمارك",
      "ركن الدين",
      "زاهرة",
      "زقاق الجن",
      "شارع العابد",
      "شارع بغداد",
      "شارع خالد",
      "صناعة",
      "عرنوس",
      "عفيف",
      "عمارة",
      "فحامة",
      "قابون",
      "قدم",
      "كفر سوسة",
      "مزة",
      "مساكن برزة",
      "مهاجرين",
      "ميدان",
      "نهر عيشة",
      "مخيم اليرموك",
      "مخيم فلسطين",
      "الحجر الأسود",
      "بيادر نادر",
      "تضامن",
      "دف الشوك",
      "دويلعة كشكول",
      "دويلعة",
      "اسد الدين",
    ],
    "ريف دمشق": [
      "اشرفية",
      "السيدة زينب",
      "الصبورة",
      "الطيبة",
      "الهامة",
      "باردة",
      "ببيلا",
      "بحدلية",
      "بويضة",
      "جب الصفا",
      "جديدة البلد",
      "جديدة الضهرة",
      "جديدة الفضل",
      "جديدة عرطوز",
      "حجيرة",
      "حرجلة",
      "حسينية",
      "حي الورود",
      "خان الشيح",
      "خربة الورد",
      "خيارة",
      "داريا",
      "دنون",
      "ديابية",
      "دير علي",
      "زاكية",
      "سبينة",
      "صحنايا",
      "ضاحية قدسيا",
      "عادلية",
      "قارة",
      "قدسيا",
      "قرى الأسد",
      "قطنا",
      "كسوة",
      "معربا",
      "معضمية",
      "مقيليبة",
      "منصورة",
      "وادي المشاريع",
      "دمر البلد",
      "دمر الشرقية",
      "مشروع دمر",
      "ضاحية الأسد",
      "يلدا",
      "ضمير",
    ],
    "الغوطة": [
      "النشابية",
      "بيت سحم",
      "جرمانا",
      "حران العواميد",
      "حرستا",
      "حمورية",
      "دوما",
      "دير العصافير",
      "دير سلمان",
      "زملكا",
      "سقبا",
      "عدرا العمالية",
      "عدرا",
      "عربين",
      "عين ترما",
      "غزلانية",
      "كفر بطنا",
      "كفرين",
      "مسرابا",
      "مليحة",
      "العتيبة",
      "جسرين",
      "حتيتة",
      "شبعا",
      "عقربا",
      "جديدة الخاص",
    ],
    "القلمون": [
      "التل",
      "بقين",
      "بلودان",
      "حرنة",
      "دير قانون",
      "رنكوس",
      "زبداني",
      "وادي بردى",
      "صيدنايا",
      "مضايا",
      "معلولا",
      "الرحيبة",
      "النبك",
      "يبرود",
      "جيرود",
      "القطيفة",
      "معضمية القلمون",
      "جديدة يابوس",
      "كفير يابوس",
      "جديدة الشيباني",
    ],
    "اللاذقية": [],
    "السويداء": ["نَمر", "أم ضبيب", "شهباء", "غارية السويداء"],
    "درعا": [
      "جاسم",
      "غباغب",
      "الحارة",
      "جباب",
      "الصنمين",
      "أنخل",
      "نَمر",
      "عقربة",
      "كفر شمس",
      "نوى",
      "الشيخ مسكين",
      "نصيب",
      "خربة غزالة",
      "علما",
      "الحراك",
      "الغارية الشرقية",
      "الغارية الغربية",
      "ازرع",
      "بصرى الشام",
    ],
    "القنيطرة": ["خان أرنبة", "سعسع", "جِبا", "جباتا الخشب"],
    "حمص": ["الخالدية"],
    "حماة": ["محردة", "مصياف", "سلمية"],
    "حلب": [],
    "الجزيرة": ["دير الزور", "الرقة", "الميادين", "الحسكة", "القامشلي"],
    "طرطوس": [
      "صافيتا",
      "دوار الساعة",
      "مشبكة",
      "دوار العنفة",
      "الهنكارات",
      "دوار السعدة",
      "حي الرمل",
      "شارع المينا",
    ],
    "جبلة": ["شارع العمارة", "شارع الميناء", "الكراج القديم"],
  };

  List<DropdownMenuItem<String>> dropdownGovernateItems() {
    return regions.keys.toList().map((item) {
      return DropdownMenuItem<String>(value: item, child: Text(item));
    }).toList();
  }

  List<DropdownMenuItem<String>> getDropdownRegionItems() {
    if (_customerdata.address.governate != null &&
        regions[_customerdata.address.governate] != null) {
      return regions[_customerdata.address.governate]!.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList();
    } else {
      return [];
    }
  }

  void _fillFormWithViewModel() {
    if (widget._customerViewModel is! CustomerViewModel) {
      return;
    }
    _customerdata = CustomerViewModel(
      id: widget._customerViewModel!.id,
      address: widget._customerViewModel!.address,
      basicInfo: widget._customerViewModel!.basicInfo,
      personalInfo: widget._customerViewModel!.personalInfo,
      shopBasicInfo: widget._customerViewModel!.shopBasicInfo,
      discounts: widget._customerViewModel!.discounts,
      marketInfo: widget._customerViewModel!.marketInfo,
      methodsOfDealing: widget._customerViewModel!.methodsOfDealing,
      activity: widget._customerViewModel!.activity,
      specialBrands: widget._customerViewModel!.specialBrands,
      notes: widget._customerViewModel!.notes,
    );
  }

  void _fillCustomerDatafromForm() {
    _customerdata.address.address = _controllers['address']!.text;
    _customerdata.basicInfo.customerName = _controllers['customerName']!.text;
    _customerdata.basicInfo.shopName = _controllers['shopName']!.text;
    _customerdata.basicInfo.telNumber = _controllers['tel']!.text;
    _customerdata.basicInfo.mobileNumber = _controllers['mobile']!.text;
    _customerdata.marketInfo.clientActivityOld =
        _controllers['clientActivityOld']!.text;
    _customerdata.personalInfo.clientPlaceOfBirth =
        _controllers['clientPlaceOfBirth']!.text;
    _customerdata.personalInfo.clientMaritalStatus =
        _controllers['clientMaterialStatus']!.text;
    _customerdata.discounts.giftOnQuantity =
        _controllers['giftOnQuantity']!.text;
    _customerdata.discounts.giftOnValue = _controllers['giftOnValue']!.text;
    _customerdata.specialBrands.specialItemsOil =
        _controllers['specialItemsOil']!.text;
    _customerdata.specialBrands.specialItemsWater =
        _controllers['specialItemsWater']!.text;
    _customerdata.specialBrands.specialItemsAcrylic =
        _controllers['specialItemsAcrylic']!.text;
    _customerdata.notes = _controllers['notes']!.text;
    _customerdata.personalInfo.clientYearOfBirth =
        int.tryParse(_controllers['clientYearOfBirth']!.text) ?? 1900;
    _customerdata.discounts.staticDiscount =
        double.tryParse(_controllers['staticDiscount']!.text) ?? 0.0;
    _customerdata.discounts.monthDiscount =
        double.tryParse(_controllers['monthDiscount']!.text) ?? 0.0;
  }

  @override
  void initState() {
    hasCustomerViewModel = widget._customerViewModel is CustomerViewModel;
    super.initState();
    if (hasCustomerViewModel) {
      _fillFormWithViewModel();
    }
    _controllers = {
      'customerName': TextEditingController(
        text: _customerdata.basicInfo.customerName,
      ),
      'shopName': TextEditingController(text: _customerdata.basicInfo.shopName),
      'address': TextEditingController(text: _customerdata.address.address),
      'tel': TextEditingController(text: _customerdata.basicInfo.telNumber),
      'mobile': TextEditingController(
        text: _customerdata.basicInfo.mobileNumber,
      ),
      'clientActivityOld': TextEditingController(
        text: _customerdata.marketInfo.clientActivityOld,
      ),
      'clientPlaceOfBirth': TextEditingController(
        text: _customerdata.personalInfo.clientPlaceOfBirth,
      ),
      'clientYearOfBirth': TextEditingController(
        text: _customerdata.personalInfo.clientYearOfBirth.toString(),
      ),
      'clientMaterialStatus': TextEditingController(
        text: _customerdata.personalInfo.clientMaritalStatus,
      ),
      'staticDiscount': TextEditingController(
        text: _customerdata.discounts.staticDiscount.toString(),
      ),
      'monthDiscount': TextEditingController(
        text: _customerdata.discounts.monthDiscount.toString(),
      ),
      'yearDiscount': TextEditingController(
        text: _customerdata.discounts.yearDiscount.toString(),
      ),
      'giftOnQuantity': TextEditingController(
        text: _customerdata.discounts.giftOnQuantity,
      ),
      'giftOnValue': TextEditingController(
        text: _customerdata.discounts.giftOnValue,
      ),
      'specialItemsOil': TextEditingController(
        text: _customerdata.specialBrands.specialItemsOil,
      ),
      'specialItemsWater': TextEditingController(
        text: _customerdata.specialBrands.specialItemsWater,
      ),
      'specialItemsAcrylic': TextEditingController(
        text: _customerdata.specialBrands.specialItemsAcrylic,
      ),
      'notes': TextEditingController(text: _customerdata.notes),
    };
  }

  @override
  void dispose() {
    _controllers['customerName']!.dispose();
    _controllers['shopName']!.dispose();
    _controllers['address']!.dispose();
    _controllers['tel']!.dispose();
    _controllers['mobile']!.dispose();
    _controllers['clientActivityOld']!.dispose();
    _controllers['clientPlaceOfBirth']!.dispose();
    _controllers['clientYearOfBirth']!.dispose();
    _controllers['clientMaterialStatus']!.dispose();
    _controllers['staticDiscount']!.dispose();
    _controllers['monthDiscount']!.dispose();
    _controllers['yearDiscount']!.dispose();
    _controllers['giftOnQuantity']!.dispose();
    _controllers['giftOnValue']!.dispose();
    _controllers['specialItemsOil']!.dispose();
    _controllers['specialItemsWater']!.dispose();
    _controllers['specialItemsAcrylic']!.dispose();
    _controllers['notes']!.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _handleState(BuildContext context, SalesState state) {
    if (state is SalesOpFailure) {
      showSnackBar(context: context, content: 'حدث خطأ ما', failure: true);
      _isLoadingOperation = false;
    }
    if (state is SalesOpSuccess<bool>) {
      showSnackBar(context: context, failure: false, content: 'تم حذف الزبون');
      Navigator.pop(context);
      Navigator.pop(context);
    }
    if (state is SalesOpSuccess<CustomerViewModel>) {
      showSnackBar(context: context, content: 'تمت العملية', failure: false);
      _isLoadingOperation = false;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCustomerViewModel =
        widget._customerViewModel is CustomerViewModel;

    return BlocProvider(
      create: (context) => getIt<SalesBloc>(),
      child: Builder(
        builder: (context) {
          return BlocListener<SalesBloc, SalesState>(
            listener: (context, state) {
              _handleState(context, state);
            },
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: FullData(
                appBarText: 'بيانات الزبون',
                listOfData: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _customerdata.shopBasicInfo.shopStatus
                            ? 'يعمل'
                            : 'لا يعمل',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 20),
                      Switch(
                        value: _customerdata.shopBasicInfo.shopStatus,
                        onChanged: (value) {
                          setState(() {
                            _customerdata.shopBasicInfo.shopStatus = value;
                          });
                        },
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: Colors.black,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: MyDropdownButton(
                          value: _customerdata.address.governate,
                          items: dropdownGovernateItems(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _customerdata.address.governate = newValue;
                              _customerdata.address.region = null;
                            });
                          },
                          labelText: 'المحافظة',
                        ),
                      ),
                      Expanded(
                        child: MyDropdownButton(
                          value: _customerdata.address.region,
                          items: getDropdownRegionItems(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _customerdata.address.region = newValue;
                            });
                          },
                          labelText: 'المنطقة',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _controllers['customerName']!,
                          labelText: 'اسم الزبون',
                        ),
                      ),
                      Expanded(
                        child: MyTextField(
                          controller: _controllers['shopName']!,
                          labelText: 'اسم المحل',
                        ),
                      ),
                    ],
                  ),
                  MyTextField(
                    controller: _controllers['address']!,
                    labelText: 'العنوان',
                  ),
                  MyTextField(
                    controller: _controllers['mobile']!,
                    labelText: 'الموبايل',
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _controllers['tel']!,
                          labelText: 'الهاتف',
                        ),
                      ),
                      Expanded(
                        child: MyTextField(
                          controller: _controllers['clientActivityOld']!,
                          labelText: 'قدم العميل',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyDropdownButton(
                          value: _customerdata.marketInfo.responsible,
                          items:
                              responsible.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _customerdata.marketInfo.responsible = newValue;
                            });
                          },
                          labelText: 'المسؤول',
                        ),
                      ),
                      Expanded(
                        child: CounterRow(
                          label: 'حجم العميل',
                          value: _customerdata.marketInfo.customerSize,
                          onIncrement:
                              () => setState(() {
                                if (_customerdata.marketInfo.customerSize <
                                    10) {
                                  _customerdata.marketInfo.customerSize =
                                      _customerdata.marketInfo.customerSize + 1;
                                }
                              }),
                          onDecrement:
                              () => setState(() {
                                if (_customerdata.marketInfo.customerSize > 0) {
                                  _customerdata.marketInfo.customerSize =
                                      _customerdata.marketInfo.customerSize - 1;
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: MyTextField(
                          controller: _controllers['clientPlaceOfBirth']!,
                          labelText: 'مكان ولادة العميل',
                        ),
                      ),
                      Expanded(
                        child: MyTextField(
                          controller: _controllers['clientYearOfBirth']!,
                          labelText: 'سنة ولادة العميل',
                          suffixIcon: const Icon(Icons.date_range_outlined),
                          onSuffixIconTap: () async {
                            int year = await selectYear(context);
                            setState(() {
                              _controllers['clientYearOfBirth']!.text =
                                  year.toString();
                            });
                          },
                          readOnly: true,
                        ),
                      ),
                      Expanded(
                        child: MyTextField(
                          controller: _controllers['clientMaterialStatus']!,
                          labelText: 'الحالة الاجتماعية',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CounterRow(
                          label: 'عدد الأطفال',
                          value:
                              _customerdata.personalInfo.clientNumberOfChildren,
                          onIncrement:
                              () => setState(() {
                                if (_customerdata
                                        .personalInfo
                                        .clientNumberOfChildren <
                                    10) {
                                  _customerdata
                                      .personalInfo
                                      .clientNumberOfChildren = _customerdata
                                          .personalInfo
                                          .clientNumberOfChildren +
                                      1;
                                }
                              }),
                          onDecrement:
                              () => setState(() {
                                if (_customerdata
                                        .personalInfo
                                        .clientNumberOfChildren >
                                    0) {
                                  _customerdata
                                      .personalInfo
                                      .clientNumberOfChildren = _customerdata
                                          .personalInfo
                                          .clientNumberOfChildren -
                                      1;
                                }
                              }),
                        ),
                      ),
                      Expanded(
                        child: CounterRow(
                          label: 'مساحة المحل',
                          value: _customerdata.shopBasicInfo.shopSpace,
                          onIncrement:
                              () => setState(() {
                                if (_customerdata.shopBasicInfo.shopSpace <
                                    500) {
                                  _customerdata.shopBasicInfo.shopSpace =
                                      _customerdata.shopBasicInfo.shopSpace + 5;
                                }
                              }),
                          onDecrement:
                              () => setState(() {
                                if (_customerdata.shopBasicInfo.shopSpace > 0) {
                                  _customerdata.shopBasicInfo.shopSpace =
                                      _customerdata.shopBasicInfo.shopSpace - 5;
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CounterRow(
                          label: 'عدد المستودعات',
                          value: _customerdata.shopBasicInfo.numberOfWarehouses,
                          onIncrement:
                              () => setState(() {
                                if (_customerdata
                                        .shopBasicInfo
                                        .numberOfWarehouses <
                                    10) {
                                  _customerdata
                                      .shopBasicInfo
                                      .numberOfWarehouses = _customerdata
                                          .shopBasicInfo
                                          .numberOfWarehouses +
                                      1;
                                }
                              }),
                          onDecrement:
                              () => setState(() {
                                if (_customerdata
                                        .shopBasicInfo
                                        .numberOfWarehouses >
                                    0) {
                                  _customerdata
                                      .shopBasicInfo
                                      .numberOfWarehouses = _customerdata
                                          .shopBasicInfo
                                          .numberOfWarehouses -
                                      1;
                                }
                              }),
                        ),
                      ),
                      Expanded(
                        child: CounterRow(
                          label: 'عدد العمال',
                          value: _customerdata.shopBasicInfo.numberOfWorkers,
                          onIncrement:
                              () => setState(() {
                                if (_customerdata
                                        .shopBasicInfo
                                        .numberOfWorkers <
                                    10) {
                                  _customerdata.shopBasicInfo.numberOfWorkers =
                                      _customerdata
                                          .shopBasicInfo
                                          .numberOfWorkers +
                                      1;
                                }
                              }),
                          onDecrement:
                              () => setState(() {
                                if (_customerdata
                                        .shopBasicInfo
                                        .numberOfWorkers >
                                    0) {
                                  _customerdata.shopBasicInfo.numberOfWorkers =
                                      _customerdata
                                          .shopBasicInfo
                                          .numberOfWorkers -
                                      1;
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: MyTextField(
                          controller: _controllers['staticDiscount']!,
                          labelText: 'الثابت',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: MyTextField(
                          controller: _controllers['monthDiscount']!,
                          labelText: 'الشهري',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: MyTextField(
                          controller: _controllers['yearDiscount']!,
                          labelText: 'السنوي',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          labelStyle: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  MyTextField(
                    maxLines: 10,
                    controller: _controllers['giftOnQuantity']!,
                    labelText: 'هدية على الكمية',
                  ),
                  MyTextField(
                    maxLines: 10,
                    controller: _controllers['giftOnValue']!,
                    labelText: 'هدية على القيمة',
                  ),
                  MyDropdownButton(
                    value: _customerdata.marketInfo.clientTradeType,
                    items:
                        clientTradeType.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _customerdata.marketInfo.clientTradeType = newValue;
                      });
                    },
                    labelText: 'نوع التجارة',
                  ),
                  MyDropdownButton(
                    value: _customerdata.marketInfo.clientSpread,
                    items:
                        clientSpread.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _customerdata.marketInfo.clientSpread = newValue;
                      });
                    },
                    labelText: 'انتشار العميل',
                  ),
                  MyDropdownButton(
                    value: _customerdata.marketInfo.paintProffesion,
                    items:
                        paintProffession.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _customerdata.marketInfo.paintProffesion = newValue;
                      });
                    },
                    labelText: 'ثقافة الدهان',
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: MyDropdownButton(
                          value: boolToString(
                            _customerdata.marketInfo.isDirectCustomer,
                          ),
                          items:
                              isDirectCustomer.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _customerdata
                                  .marketInfo
                                  .isDirectCustomer = stringToBool(newValue);
                            });
                          },
                          labelText: 'نوع الزبون',
                        ),
                      ),
                      Expanded(
                        child: MyDropdownButton(
                          value: _customerdata.marketInfo.dependenceOnCompany,
                          items:
                              dependenceOnCompany.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _customerdata.marketInfo.dependenceOnCompany =
                                  newValue;
                            });
                          },
                          labelText: 'الاعتماد على الشركة',
                        ),
                      ),
                    ],
                  ),
                  MyDropdownButton(
                    value: _customerdata.marketInfo.credFinance,
                    items:
                        cred.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _customerdata.marketInfo.credFinance = newValue;
                      });
                    },
                    labelText: 'المصداقية المالية',
                  ),
                  MyDropdownButton(
                    value: _customerdata.marketInfo.credDeals,
                    items:
                        cred.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _customerdata.marketInfo.credDeals = newValue;
                      });
                    },
                    labelText: 'مصداقية التعامل',
                  ),
                  MyDropdownButton(
                    value: _customerdata.marketInfo.credComplains,
                    items:
                        cred.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _customerdata.marketInfo.credComplains = newValue;
                      });
                    },
                    labelText: 'مصداقية الشكاوي',
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade800,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('طريقة الدفع'),
                              CheckboxListTile(
                                title: const Text(
                                  'نقدي',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value:
                                    _customerdata.methodsOfDealing.methodCash,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _customerdata.methodsOfDealing.methodCash =
                                        value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  'دفعات',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value:
                                    _customerdata
                                        .methodsOfDealing
                                        .methodPayments,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _customerdata
                                        .methodsOfDealing
                                        .methodPayments = value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  'عروض',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value:
                                    _customerdata.methodsOfDealing.methodOffers,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _customerdata
                                        .methodsOfDealing
                                        .methodOffers = value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  'بالأمانة',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value:
                                    _customerdata
                                        .methodsOfDealing
                                        .methodCustody,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _customerdata
                                        .methodsOfDealing
                                        .methodCustody = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade800,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('نشاط العميل'),
                              CheckboxListTile(
                                title: const Text(
                                  'دهانات',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value: _customerdata.activity.activityPaints,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _customerdata.activity.activityPaints =
                                        value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  'صحية',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value: _customerdata.activity.activityPlumping,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _customerdata.activity.activityPlumping =
                                        value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  'كهربائيات',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value:
                                    _customerdata.activity.activityElectrical,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _customerdata.activity.activityElectrical =
                                        value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text(
                                  'خرداوات',
                                  style: TextStyle(fontSize: 12),
                                ),
                                value:
                                    _customerdata.activity.activityHaberdashery,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _customerdata
                                        .activity
                                        .activityHaberdashery = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade800,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        const Text('أصناف خاصة'),
                        const SizedBox(height: 16.0),
                        MyTextField(
                          maxLines: 10,
                          controller: _controllers['specialItemsOil']!,
                          labelText: 'الزياتي',
                        ),
                        const SizedBox(height: 8.0),
                        MyTextField(
                          maxLines: 10,
                          controller: _controllers['specialItemsWater']!,
                          labelText: 'المائي',
                        ),
                        const SizedBox(height: 8.0),
                        MyTextField(
                          maxLines: 10,
                          controller: _controllers['specialItemsAcrylic']!,
                          labelText: 'اكرليك',
                        ),
                      ],
                    ),
                  ),
                  MyTextField(
                    maxLines: 10,
                    controller: _controllers['notes']!,
                    labelText: 'ملاحظات',
                  ),
                  (_customerdata.address.shopCoordinates == null ||
                          _customerdata.address.shopCoordinates == "")
                      ? _isLoading
                          ? const Loader()
                          : Mybutton(
                            onPressed: () async {
                              setState(() {
                                _isLoading = true; // Start loading
                              });

                              try {
                                Position position = await _determinePosition();
                                setState(() {
                                  _customerdata.address.shopCoordinates =
                                      '${position.latitude},${position.longitude}';
                                });
                              } catch (e) {
                                print('Error: $e');
                              } finally {
                                setState(() {
                                  _isLoading = false; // Stop loading
                                });
                              }
                            },
                            text: 'إضافة موقع',
                          )
                      : Column(
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Mybutton(
                                text: 'عرض الموقع',
                                onPressed: () async {
                                  final Uri _url = Uri.parse(
                                    'https://www.google.com/maps?q=${_customerdata.address.shopCoordinates}',
                                  );

                                  if (!await launchUrl(_url)) {
                                    throw Exception('Could not launch $_url');
                                  }
                                },
                              ),
                              _isLoading
                                  ? const Loader() // Loader while updating location
                                  : Mybutton(
                                    text: 'تعديل الموقع',
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true; // Start loading
                                      });

                                      try {
                                        Position position =
                                            await _determinePosition();
                                        setState(() {
                                          _customerdata
                                                  .address
                                                  .shopCoordinates =
                                              '${position.latitude},${position.longitude}';
                                        });
                                      } catch (e) {
                                        print('Error: $e');
                                      } finally {
                                        setState(() {
                                          _isLoading = false; // Stop loading
                                        });
                                      }
                                    },
                                  ),
                              Mybutton(
                                text: 'إزالة الموقع',
                                onPressed: () {
                                  setState(() {
                                    _customerdata.address.shopCoordinates = '';
                                  });
                                },
                              ),
                            ],
                          ),
                          Text(
                            _customerdata.address.shopCoordinates ?? '',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                ],
                bottomNavigationBarItems:
                    _isLoadingOperation
                        ? [
                          const BottomNavigationBarItem(
                            icon: Loader(), // Use your Loader widget here
                            label: 'جاري المعالجة',
                          ),
                          const BottomNavigationBarItem(
                            icon: SizedBox(),
                            label: '',
                          ),
                        ]
                        : isCustomerViewModel
                        ? const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.edit, color: Colors.grey),
                            label: 'تعديل',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.delete, color: Colors.red),
                            label: 'حذف',
                          ),
                        ]
                        : const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.add_circle, color: Colors.green),
                            label: 'إضافة',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.cancel, color: Colors.red),
                            label: 'رجوع',
                          ),
                        ],
                onTap: (index) async {
                  if (isCustomerViewModel) {
                    if (index == 0) {
                      // Edit action
                      setState(() {
                        _isLoadingOperation = true;
                      });
                      _fillCustomerDatafromForm();
                      context.read<SalesBloc>().add(
                        SalesUpdateCustomer(item: _customerdata),
                      );
                    } else if (index == 1) {
                      showSnackBar(
                        context: context,
                        failure: true,
                        content: 'لا يمكن تنفيذ هذه العملية',
                      );
                    }
                  } else {
                    if (index == 0) {
                      // Add action
                      setState(() {
                        _isLoadingOperation = true;
                      });
                      _fillCustomerDatafromForm();
                      context.read<SalesBloc>().add(
                        SalesAddCustomer(item: _customerdata),
                      );
                    } else if (index == 1) {
                      // Cancel action
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// Function to determine location
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Location services are disabled.');
  }

  // Check location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  // Get current location
  return await Geolocator.getCurrentPosition();
}
