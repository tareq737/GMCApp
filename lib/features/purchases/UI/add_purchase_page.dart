import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'dart:ui' as ui;
import 'package:gmcappclean/features/Purchases/Bloc/purchase_bloc.dart';
import 'package:gmcappclean/features/purchases/Models/purchases_model.dart';
import 'package:gmcappclean/features/purchases/Services/purchase_service.dart';
import 'package:gmcappclean/features/purchases/UI/general%20purchases/purchases_list.dart';
import 'package:gmcappclean/features/purchases/UI/production%20purchases/production_purchases_list.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class AddPurchasePage extends StatefulWidget {
  final String type;
  const AddPurchasePage({super.key, required this.type});

  @override
  State<AddPurchasePage> createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends State<AddPurchasePage> {
  late List<String> departments;

  List<DropdownMenuItem<String>> dropdownDepartmentItems() {
    return departments.toList().map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  PurchasesModel? purchasesModel;
  final _sectionController = TextEditingController();
  final _applicantController = TextEditingController();
  final _insertDateController = TextEditingController();
  final _typeController = TextEditingController();
  final _detailsController = TextEditingController();
  final _heightController = TextEditingController();
  final _widthController = TextEditingController();
  final _lengthController = TextEditingController();
  final _colorController = TextEditingController();
  final _countryController = TextEditingController();
  final _usageController = TextEditingController();
  final _warehouseBalanceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _requiredDateController = TextEditingController();
  final _supplierController = TextEditingController();

  @override
  void initState() {
    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _applicantController.text = userState.userEntity.firstName ?? '';
    }
    super.initState();
    _insertDateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    // Fill departments based on the type
    if (widget.type == 'general') {
      departments = [
        'الصيانة',
        'الزراعة',
        'العهد',
        'الخدمات',
        'المبيعات',
        'أقسام الإنتاج',
        'IT',
        'شركة النور',
      ];
    } else if (widget.type == 'production') {
      departments = ['فوارغ', 'مواد أولية'];
    }
  }

  @override
  void dispose() {
    _sectionController.dispose();
    _applicantController.dispose();
    _insertDateController.dispose();
    _typeController.dispose();
    _detailsController.dispose();
    _heightController.dispose();
    _widthController.dispose();
    _lengthController.dispose();
    _colorController.dispose();
    _countryController.dispose();
    _usageController.dispose();
    _warehouseBalanceController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _requiredDateController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserLoggedIn) {
          _applicantController.text = state.userEntity.firstName ?? '';
        }
      },
      child: BlocProvider(
        create: (context) => PurchaseBloc(
          PurchaseService(
            apiClient: getIt<ApiClient>(),
            authInteractor: getIt<AuthInteractor>(),
          ),
        ),
        child: Builder(builder: (context) {
          return BlocListener<PurchaseBloc, PurchaseState>(
            listener: (context, state) {
              if (state is PurchaseSuccess) {
                showSnackBar(
                  context: context,
                  content: 'تمت الإضافة بنجاح',
                  failure: false,
                );
                Navigator.pop(context);
                if (widget.type == 'general') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PurchasesList(
                        status: 2,
                      ),
                    ),
                  );
                }
                if (widget.type == 'production') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductionPurchasesList(
                        status: 1,
                      ),
                    ),
                  );
                }
              } else if (state is PurchaseError) {
                showSnackBar(
                  context: context,
                  content: 'حدث خطأ ما',
                  failure: true,
                );
              }
            },
            child: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    widget.type == 'general'
                        ? 'طلب شراء جديد - عام'
                        : widget.type == 'production'
                            ? 'طلب شراء جديد - إنتاج'
                            : 'طلب شراء جديد',
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'معلومات الطلب',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        MyDropdownButton(
                          value: _sectionController.text,
                          items: dropdownDepartmentItems(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _sectionController.text = newValue ?? '';
                            });
                          },
                          labelText: 'القسم',
                        ),
                        MyTextField(
                            readOnly: true,
                            controller: _applicantController,
                            labelText: 'مقدم الطلب'),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: MyTextField(
                                  readOnly: true,
                                  controller: _insertDateController,
                                  labelText: 'تاريخ الإدراج'),
                            ),
                            Expanded(
                              child: MyTextField(
                                readOnly: true,
                                controller: _requiredDateController,
                                labelText: 'تاريخ التوريد المطلوب',
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _requiredDateController.text =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        MyTextField(
                            controller: _typeController, labelText: 'الصنف'),
                        MyTextField(
                          controller: _usageController,
                          labelText: 'الاستعمال وتوصيف الحالة',
                          maxLines: 10,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'الأبعاد والمواصفات',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          controller: _detailsController,
                          labelText: 'المواصفات الفنية',
                          maxLines: 10,
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: MyTextField(
                                  controller: _lengthController,
                                  labelText: 'الطول'),
                            ),
                            Expanded(
                              child: MyTextField(
                                  controller: _widthController,
                                  labelText: 'العرض'),
                            ),
                            Expanded(
                              child: MyTextField(
                                  controller: _heightController,
                                  labelText: 'الارتفاع'),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: MyTextField(
                                  controller: _colorController,
                                  labelText: 'اللون'),
                            ),
                            Expanded(
                              child: MyTextField(
                                  controller: _countryController,
                                  labelText: 'بلد المنشأ'),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              flex: 3,
                              child: MyTextField(
                                  controller: _warehouseBalanceController,
                                  labelText: 'رصيد المستودع'),
                            ),
                            Expanded(
                                flex: 2,
                                child: MyTextField(
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*$')),
                                  ],
                                  controller: _quantityController,
                                  labelText: 'الكمية',
                                )),
                            Expanded(
                              flex: 3,
                              child: MyTextField(
                                  controller: _unitController,
                                  labelText: 'الوحدة'),
                            ),
                          ],
                        ),
                        MyTextField(
                            controller: _supplierController,
                            labelText: 'اسم المورد'),
                        const SizedBox(height: 10),
                        BlocBuilder<PurchaseBloc, PurchaseState>(
                          builder: (context, state) {
                            if (state is PurchaseLoading) {
                              return const Center(child: Loader());
                            }
                            return Mybutton(
                              text: 'إدراج',
                              onPressed: () {
                                if (_validateForm(context)) {
                                  _fillRequestModelfromForm();
                                  context.read<PurchaseBloc>().add(
                                        AddPurchases(
                                            purchasesModel: purchasesModel!),
                                      );
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// ✅ Validate required fields
  bool _validateForm(BuildContext context) {
    if (_sectionController.text.isEmpty ||
        _applicantController.text.isEmpty ||
        _insertDateController.text.isEmpty ||
        _typeController.text.isEmpty ||
        _detailsController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _widthController.text.isEmpty ||
        _lengthController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _countryController.text.isEmpty ||
        _usageController.text.isEmpty ||
        _warehouseBalanceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _unitController.text.isEmpty ||
        _requiredDateController.text.isEmpty ||
        _supplierController.text.isEmpty) {
      showSnackBar(
        context: context,
        content: 'يرجى تعبئة جميع الحقول قبل الإدراج',
        failure: true,
      );
      return false;
    }
    return true;
  }

  void _fillRequestModelfromForm() {
    purchasesModel ??= PurchasesModel();

    purchasesModel!.department = _sectionController.text;
    purchasesModel!.applicant = _applicantController.text;
    purchasesModel!.insert_date = _insertDateController.text;
    purchasesModel!.required_date = _requiredDateController.text;
    purchasesModel!.type = _typeController.text;
    purchasesModel!.usage = _usageController.text;
    purchasesModel!.details = _detailsController.text;
    purchasesModel!.width = _widthController.text;
    purchasesModel!.length = _lengthController.text;
    purchasesModel!.height = _heightController.text;
    purchasesModel!.color = _colorController.text;
    purchasesModel!.country = _countryController.text;
    purchasesModel!.warehouse_balance = _warehouseBalanceController.text;
    purchasesModel!.quantity = double.tryParse(_quantityController.text) ?? 0.0;
    purchasesModel!.unit = _unitController.text;
    purchasesModel!.supplier = _supplierController.text;
  }
}
