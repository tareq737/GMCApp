import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/counter_row_widget.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';
import 'package:gmcappclean/features/sales_management/operations/bloc/operations_bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/models/operations_model.dart';
import 'package:gmcappclean/features/sales_management/operations/models/visit_mode.dart';
import 'package:gmcappclean/features/sales_management/operations/services/operations_services.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'dart:ui' as ui;

import 'package:intl/intl.dart';

class NewVisitPage extends StatefulWidget {
  final OperationsModel? operationsModel;

  const NewVisitPage({
    super.key,
    this.operationsModel,
  });

  @override
  State<NewVisitPage> createState() => _NewVisitPageState();
}

class _NewVisitPageState extends State<NewVisitPage> {
  final _searchController = TextEditingController();
  final _visitDateController = TextEditingController();
  final _summaryController = TextEditingController();
  CustomerBriefViewModel? _selectedCustomer;
  int visitDuration = 0;
  String? salesRep1 = "";
  String? salesRep2 = "";
  String? processKind = "";
  String? reception = "";
  String? discussion = "";
  bool? socialTalk = false;
  bool? businessTalk = false;
  bool? bill = false;
  bool? complaints = false;
  bool? payedMoney = false;
  bool? changesOfShop = false;
  String? sellingPaints = "";
  String? sellingOthers = "";

  List responsible = [
    'محمد العمر',
    'أحمد الناصري',
    'عبد الله عويد',
    'عبد الله دياب',
    'غيث الشيخ',
  ];
  List processKindList = [
    'دورية',
    'طارئة',
    'ودية',
    'أول زيارة',
  ];
  List receptionList = [
    'ممتازة',
    'جيدة',
    'عادية',
    'سيئة',
    'غير موجود',
    'مغلق',
  ];
  List discussionList = [
    'حوار',
    'حادة',
    'ودية',
    'عملية',
  ];
  List sellingPaintsList = [
    'قوية',
    'متوسطة',
    'ضعيفة',
    'لا يوجد حركة',
  ];
  List sellingOthersList = [
    'قوية',
    'متوسطة',
    'ضعيفة',
    'لا يوجد حركة',
  ];
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _visitDateController.dispose();
    _summaryController.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.operationsModel != null) {
      _visitDateController.text = widget.operationsModel?.date ?? '';
      visitDuration = widget.operationsModel?.duration != null
          ? int.tryParse(widget.operationsModel!.duration!) ?? 0
          : 0;
      processKind = widget.operationsModel?.process_kind ?? '';
      discussion = widget.operationsModel?.discussion ?? '';
      socialTalk = widget.operationsModel?.social_talk ?? false;
      bill = widget.operationsModel?.bill ?? false;
      complaints = widget.operationsModel?.complaints ?? false;
      _summaryController.text = widget.operationsModel?.summary ?? '';
      salesRep1 = widget.operationsModel?.sales_rep_1 ?? '';
      salesRep2 = widget.operationsModel?.sales_rep_2 ?? '';
      reception = widget.operationsModel?.reception ?? '';
      businessTalk = widget.operationsModel?.business_talk ?? false;
      payedMoney = widget.operationsModel?.paid_money ?? false;
      changesOfShop = widget.operationsModel?.changes_of_shop ?? false;
      sellingPaints = widget.operationsModel?.selling_paints ?? '';
      sellingOthers = widget.operationsModel?.selling_others ?? '';
    }
    if (widget.operationsModel == null) {
      _visitDateController.text =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  final VisitModel _visitModel = VisitModel(
    id: 0,
    customer: 0,
    duration: 0,
    date: '',
    process_kind: '',
    discussion: '',
    social_talk: false,
    business_talk: false,
    bill: false,
    complaints: false,
    paid_money: false,
    changes_of_shop: false,
    selling_paints: '',
    selling_others: '',
    summary: '',
    sales_rep_1: '',
    sales_rep_2: '',
  );

  void _fillOperationModelfromForm() {
    _visitModel.id = 0;
    if (_selectedCustomer != null) {
      _visitModel.customer = _selectedCustomer!.id;
    }
    if (widget.operationsModel != null) {
      _visitModel.customer = widget.operationsModel!.customer;
    }
    _visitModel.duration = visitDuration;
    _visitModel.date = _visitDateController.text;
    _visitModel.process_kind = processKind;
    _visitModel.discussion = discussion;
    _visitModel.social_talk = socialTalk;
    _visitModel.business_talk = businessTalk;
    _visitModel.bill = bill;
    _visitModel.complaints = complaints;
    _visitModel.paid_money = payedMoney;
    _visitModel.changes_of_shop = changesOfShop;
    _visitModel.selling_paints = sellingPaints;
    _visitModel.selling_others = sellingOthers;
    _visitModel.summary = _summaryController.text;
    _visitModel.sales_rep_1 = salesRep1;
    _visitModel.sales_rep_2 = salesRep2;
    _visitModel.reception = reception;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SalesBloc>(),
        ),
        BlocProvider(
          create: (context) => OperationsBloc(OperationsServices(
              apiClient: getIt<ApiClient>(),
              checkUserSessionStatus: getIt<CheckUserSessionStatus>())),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: widget.operationsModel == null
                    ? const Row(
                        children: [
                          Text('زيارة جديدة'),
                          SizedBox(width: 10),
                          Icon(Icons.add),
                        ],
                      )
                    : const Row(
                        children: [
                          Text('معلومات الزيارة'),
                          SizedBox(width: 10),
                          Icon(Icons.info_outline),
                        ],
                      ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocConsumer<OperationsBloc, OperationsState>(
                    listener: (context, state) {
                      if (state is OperationsSuccess) {
                        if (widget.operationsModel == null) {
                          showSnackBar(
                            context: context,
                            content: 'تمت الإضافة بنجاح',
                            failure: false,
                          );
                        }
                        if (widget.operationsModel != null) {
                          showSnackBar(
                            context: context,
                            content: 'تمت التعديل بنجاح',
                            failure: false,
                          );
                        }

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (
                              context,
                            ) {
                              return const NewVisitPage();
                            },
                          ),
                        );
                      } else if (state is OperationsError) {
                        showSnackBar(
                          context: context,
                          content: 'حدث خطأ ما',
                          failure: true,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is OperationsLoading) {
                        return const Center(child: Loader());
                      } else {
                        return Column(
                          children: [
                            (_selectedCustomer?.id == null &&
                                    widget.operationsModel == null)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('يرجى اختيار زبون'),
                                      SearchRow(
                                        textEditingController:
                                            _searchController,
                                        onSearch: () {
                                          _searchCustomer(context);
                                        },
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade500,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('اسم الزبون:'),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  radius: 12,
                                                  child: Text(
                                                    _selectedCustomer == null
                                                        ? widget
                                                            .operationsModel!
                                                            .customer
                                                            .toString()
                                                        : _selectedCustomer!.id
                                                            .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 8),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      _selectedCustomer == null
                                                          ? widget.operationsModel!
                                                                  .customer_name ??
                                                              ''
                                                          : _selectedCustomer
                                                                  ?.customerName ??
                                                              '',
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      _selectedCustomer == null
                                                          ? widget.operationsModel!
                                                                  .shop_name ??
                                                              ''
                                                          : _selectedCustomer
                                                                  ?.shopName ??
                                                              '',
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                (widget.operationsModel == null)
                                                    ? IconButton(
                                                        icon: const Icon(
                                                          Icons.clear,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            _visitDateController
                                                                .clear();
                                                            _searchController
                                                                .clear();
                                                            _summaryController
                                                                .clear();
                                                            visitDuration = 0;
                                                            salesRep1 = "";
                                                            salesRep2 = "";
                                                            processKind = "";
                                                            reception = "";
                                                            discussion = "";
                                                            socialTalk = false;
                                                            businessTalk =
                                                                false;
                                                            bill = false;
                                                            complaints = false;
                                                            payedMoney = false;
                                                            changesOfShop =
                                                                false;
                                                            sellingPaints = "";
                                                            sellingOthers = "";

                                                            _selectedCustomer =
                                                                null;
                                                          });
                                                        },
                                                      )
                                                    : const SizedBox()
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        spacing: 5,
                                        children: [
                                          Expanded(
                                            child: MyTextField(
                                              readOnly: true,
                                              controller: _visitDateController,
                                              labelText: 'تاريخ الزيارة',
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  lastDate: DateTime(2100),
                                                );

                                                if (pickedDate != null) {
                                                  setState(() {
                                                    _visitDateController.text =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(pickedDate);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            child: CounterRow(
                                              label: 'مدة الزيارة بالدقائق',
                                              value: visitDuration,
                                              onIncrement: () {
                                                setState(() {
                                                  visitDuration += 5;
                                                });
                                              },
                                              onDecrement: () {
                                                if (visitDuration > 0) {
                                                  setState(() {
                                                    visitDuration -= 5;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: MyDropdownButton(
                                              value: salesRep1,
                                              items: responsible.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(type),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  salesRep1 = newValue;
                                                });
                                              },
                                              labelText: 'القائم بالزيارة 1',
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: MyDropdownButton(
                                              value: salesRep2,
                                              items: responsible.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(type),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  salesRep2 = newValue;
                                                });
                                              },
                                              labelText: 'القائم بالزيارة 2',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: MyDropdownButton(
                                              value: processKind,
                                              items:
                                                  processKindList.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(type),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  processKind = newValue;
                                                });
                                              },
                                              labelText: 'طبيعة الزيارة',
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: MyDropdownButton(
                                              value: reception,
                                              items: receptionList.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(type),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  reception = newValue;
                                                });
                                              },
                                              labelText: 'طريقة الاستقبال',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Visibility(
                                        visible: reception != 'مغلق',
                                        child: Column(
                                          children: [
                                            MyDropdownButton(
                                              value: discussion,
                                              items: discussionList.map((type) {
                                                return DropdownMenuItem<String>(
                                                  value: type,
                                                  child: Text(type),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  discussion = newValue;
                                                });
                                              },
                                              labelText: 'طريقة النقاش',
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.shade500,
                                                  width: 2.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Visibility(
                                                        visible: processKind !=
                                                            'طارئة',
                                                        child: Expanded(
                                                          child:
                                                              CheckboxListTile(
                                                            title: const Text(
                                                              'حديث اجتماعي',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            value: socialTalk,
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                socialTalk =
                                                                    value ??
                                                                        false;
                                                              });
                                                            },
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: processKind !=
                                                                'ودية' &&
                                                            processKind !=
                                                                'أول زيارة',
                                                        child: Expanded(
                                                          child:
                                                              CheckboxListTile(
                                                            title: const Text(
                                                              'حديث عمل',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            value: businessTalk,
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                businessTalk =
                                                                    value ??
                                                                        false;
                                                              });
                                                            },
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Visibility(
                                                    visible: processKind !=
                                                        'أول زيارة',
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              CheckboxListTile(
                                                            title: const Text(
                                                              'تسجيل فاتورة',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            value: bill,
                                                            onChanged:
                                                                (bool? value) {
                                                              setState(() {
                                                                bill = value ??
                                                                    false;
                                                              });
                                                            },
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                          ),
                                                        ),
                                                        Visibility(
                                                          visible:
                                                              processKind !=
                                                                  'ودية',
                                                          child: Expanded(
                                                            child:
                                                                CheckboxListTile(
                                                              title: const Text(
                                                                'تسجيل شكوى',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                              value: complaints,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  complaints =
                                                                      value ??
                                                                          false;
                                                                });
                                                              },
                                                              controlAffinity:
                                                                  ListTileControlAffinity
                                                                      .leading,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: CheckboxListTile(
                                                          title: const Text(
                                                            'جلب مبلغ',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          value: payedMoney,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              payedMoney =
                                                                  value ??
                                                                      false;
                                                            });
                                                          },
                                                          controlAffinity:
                                                              ListTileControlAffinity
                                                                  .leading,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: CheckboxListTile(
                                                          title: const Text(
                                                            'تغيير بالمحل',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          ),
                                                          value: changesOfShop,
                                                          onChanged:
                                                              (bool? value) {
                                                            setState(() {
                                                              changesOfShop =
                                                                  value ??
                                                                      false;
                                                            });
                                                          },
                                                          controlAffinity:
                                                              ListTileControlAffinity
                                                                  .leading,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Visibility(
                                              visible: processKind != 'ودية' &&
                                                  processKind != 'أول زيارة',
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: MyDropdownButton(
                                                      value: sellingPaints,
                                                      items: sellingPaintsList
                                                          .map((type) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: type,
                                                          child: Text(type),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          sellingPaints =
                                                              newValue;
                                                        });
                                                      },
                                                      labelText:
                                                          'حركة بيع الدهانات',
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: MyDropdownButton(
                                                      value: sellingOthers,
                                                      items: sellingOthersList
                                                          .map((type) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: type,
                                                          child: Text(type),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          sellingOthers =
                                                              newValue;
                                                        });
                                                      },
                                                      labelText:
                                                          'حركة مواد أخرى',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            MyTextField(
                                                maxLines: 10,
                                                controller: _summaryController,
                                                labelText: 'الملخص'),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(Icons.arrow_back,
                                                color: Colors.white),
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (processKind == null ||
                                                  processKind == "") {
                                                showSnackBar(
                                                  context: context,
                                                  content:
                                                      'يرجى التأكد من تعبئة طبيعة الزيارة',
                                                  failure: true,
                                                );
                                                return;
                                              }
                                              if (reception == null ||
                                                  reception == "") {
                                                showSnackBar(
                                                  context: context,
                                                  content:
                                                      'يرجى التأكد من تعبئة طريقة الاستقبال',
                                                  failure: true,
                                                );
                                                return;
                                              }

                                              if (widget.operationsModel ==
                                                  null) {
                                                //Add Visit
                                                _fillOperationModelfromForm();
                                                context
                                                    .read<OperationsBloc>()
                                                    .add(AddNewVisit(
                                                        visitModel:
                                                            _visitModel));
                                              } else {
                                                //Edit Visit
                                                _fillOperationModelfromForm();
                                                context
                                                    .read<OperationsBloc>()
                                                    .add(EditVisit(
                                                      visitModel: _visitModel,
                                                      id: widget
                                                          .operationsModel!.id!,
                                                    ));
                                              }
                                            },
                                            icon: Icon(
                                              widget.operationsModel == null
                                                  ? Icons.add
                                                  : Icons.edit,
                                              color: Colors.white,
                                            ),
                                            style: IconButton.styleFrom(
                                              backgroundColor:
                                                  widget.operationsModel == null
                                                      ? Colors.green
                                                      : Colors.blue,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                            BlocConsumer<SalesBloc, SalesState>(
                              listener: (context, state) {
                                if (state is SalesOpFailure) {
                                  showSnackBar(
                                    context: context,
                                    content: 'حدث خطأ ما',
                                    failure: true,
                                  );
                                } else if (state is SalesOpSuccess<
                                    List<CustomerBriefViewModel>>) {
                                  _showCustomerDialog(context, state.opResult);
                                }
                              },
                              builder: (context, state) {
                                if (state is SalesOpLoading) {
                                  return const Center(child: Loader());
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _searchCustomer(BuildContext context) {
    context.read<SalesBloc>().add(
          SalesSearch<CustomerBriefViewModel>(lexum: _searchController.text),
        );
  }

  void _showCustomerDialog(
      BuildContext context, List<CustomerBriefViewModel> customers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'يرجى اختيار زبون',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 10,
                      child: Text(
                        customers[index].id.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 8),
                      ),
                    ),
                    title: Column(
                      children: [
                        Text(customers[index].customerName ?? ''),
                        Text(customers[index].shopName ?? ''),
                      ],
                    ),
                    subtitle: Text(
                      '${customers[index].governate ?? ''} - ${customers[index].region ?? ''}',
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCustomer = customers[index];
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text('إغلاق'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
