import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/surveys/bloc/surveys_bloc.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/statistics/market_survey_summary_model.dart';
import 'package:gmcappclean/features/surveys/services/surveys_services.dart';
import 'package:gmcappclean/features/surveys/ui/lists/locations.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class HomeownerStatisticsPage extends StatelessWidget {
  const HomeownerStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveysBloc(
        SurveysServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      ),
      child: Builder(builder: (context) {
        return const HomeownerStatisticsPageChild();
      }),
    );
  }
}

class HomeownerStatisticsPageChild extends StatefulWidget {
  const HomeownerStatisticsPageChild({super.key});

  @override
  State<HomeownerStatisticsPageChild> createState() =>
      _HomeownerStatisticsPageChildState();
}

class _HomeownerStatisticsPageChildState
    extends State<HomeownerStatisticsPageChild> {
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  late List<String> regions;
  List<String> selectedRegions = [];

  @override
  void initState() {
    super.initState();
    regions = Locations.regions;
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: const Text(
            'إحصائيات صاحب منزل',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: OrientationBuilder(
            builder: (context, orientation) {
              final isLandscape = orientation == Orientation.landscape;

              return Column(
                children: [
                  // --- Filter Section (Dates & Regions) ---
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: isLandscape
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: MyTextField(
                                          readOnly: true,
                                          controller: _fromDateController,
                                          labelText: 'من تاريخ',
                                          onTap: () => _selectDate(
                                              context, _fromDateController),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: MyTextField(
                                          readOnly: true,
                                          controller: _toDateController,
                                          labelText: 'إلى تاريخ',
                                          onTap: () => _selectDate(
                                              context, _toDateController),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 3,
                                  child: _buildRegionPicker(
                                    'المناطق:',
                                    selectedRegions,
                                    () => _openRegionsSelection(
                                      'اختر المناطق',
                                      selectedRegions,
                                      (updatedList) {
                                        setState(() {
                                          selectedRegions = updatedList;
                                        });
                                        runBloc();
                                      },
                                    ),
                                    isLandscape: true,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyTextField(
                                        readOnly: true,
                                        controller: _fromDateController,
                                        labelText: 'من تاريخ',
                                        onTap: () => _selectDate(
                                            context, _fromDateController),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: MyTextField(
                                        readOnly: true,
                                        controller: _toDateController,
                                        labelText: 'إلى تاريخ',
                                        onTap: () => _selectDate(
                                            context, _toDateController),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _buildRegionPicker(
                                  'المناطق',
                                  selectedRegions,
                                  () => _openRegionsSelection(
                                    'اختر المناطق',
                                    selectedRegions,
                                    (updatedList) {
                                      setState(() {
                                        selectedRegions = updatedList;
                                      });
                                      runBloc();
                                    },
                                  ),
                                  isLandscape: false,
                                ),
                              ],
                            ),
                    ),
                  ),

                  // --- Statistics Content ---
                  Expanded(
                    child: BlocConsumer<SurveysBloc, SurveysState>(
                      listener: (context, state) {
                        if (state is SurveysError) {
                          showSnackBar(
                            context: context,
                            content: 'حدث خطأ ما: ${state.errorMessage}',
                            failure: true,
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is SurveysLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is SurveysSuccess &&
                            state.result != null) {
                          return _buildStatisticsView(
                              state.result!, orientation);
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.analytics_outlined,
                                    size: 80, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  'حدد التواريخ لعرض الإحصائيات',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Region Picker Helper (Label next to container in Landscape)
  Widget _buildRegionPicker(
      String label, List<String> selectedRegions, VoidCallback onTap,
      {required bool isLandscape}) {
    final pickerBox = InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.add_business, color: Colors.blue, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedRegions.isEmpty
                    ? 'اضغط للاختيار'
                    : selectedRegions.join(' - '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );

    if (isLandscape) {
      return Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: pickerBox),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        pickerBox,
        if (selectedRegions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '${selectedRegions.length} منطقة مختارة',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
      ],
    );
  }

  // Logic to open selection modal
  void _openRegionsSelection(
      String title, List<String> currentList, Function(List<String>) onUpdate) {
    List<String> tempSelected = List.from(currentList);
    final TextEditingController modalSearchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredRegions = Locations.regions
                .where((region) => region
                    .toLowerCase()
                    .contains(modalSearchController.text.toLowerCase()))
                .toList();

            return Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: modalSearchController,
                      decoration: InputDecoration(
                        hintText: 'بحث عن منطقة...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: modalSearchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  modalSearchController.clear();
                                  setModalState(() {});
                                },
                              )
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (val) => setModalState(() {}),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setModalState(() {
                            tempSelected.clear();
                          });
                        },
                        icon: const Icon(Icons.delete_sweep, color: Colors.red),
                        label: const Text('مسح الكل',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredRegions.length,
                        itemBuilder: (context, index) {
                          final brand = filteredRegions[index];
                          return CheckboxListTile(
                            title: Text(brand),
                            value: tempSelected.contains(brand),
                            onChanged: (bool? checked) {
                              setModalState(() {
                                checked!
                                    ? tempSelected.add(brand)
                                    : tempSelected.remove(brand);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Mybutton(
                      text: 'حفظ الاختيارات',
                      onPressed: () {
                        onUpdate(tempSelected);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Helper to trigger API call
  void runBloc() {
    if (_fromDateController.text.isNotEmpty &&
        _toDateController.text.isNotEmpty) {
      context.read<SurveysBloc>().add(
            GetHomeownerStatistics(
              date1: _fromDateController.text,
              date2: _toDateController.text,
              regions:
                  selectedRegions.isEmpty ? null : selectedRegions.join(','),
            ),
          );
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
      runBloc();
    }
  }

  Widget _buildStatisticsView(
      MarketSurveySummaryModel data, Orientation orientation) {
    return orientation == Orientation.portrait
        ? _buildPortraitView(data)
        : _buildLandscapeView(data);
  }

  Widget _buildPortraitView(MarketSurveySummaryModel data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: Column(
        children: [
          _buildSingleValueSection(
            title: 'وجود GMC في السوق',
            value: data.gmc_market_presence_percentage ?? 0,
          ),
          _buildMultiValueSection(
            title: 'حركة البيع أثناء الزيارة',
            items: [
              _buildItemRow('قوية', data.salesActivityDuringVisitModel?.strong),
              _buildItemRow('متوسطة', data.salesActivityDuringVisitModel?.mid),
              _buildItemRow('ضعيفة', data.salesActivityDuringVisitModel?.weak),
              _buildItemRow('لا يوجد حركة',
                  data.salesActivityDuringVisitModel?.no_activity),
            ],
          ),
          _buildMultiValueSection(
            title: 'اعتماد الدهان في المتجر',
            items: [
              _buildItemRow('رئيسي', data.paintApprovalInStoreModel?.primary),
              _buildItemRow('ثانوي', data.paintApprovalInStoreModel?.secondary),
              _buildItemRow(
                  'عند الطلب', data.paintApprovalInStoreModel?.on_demand),
              _buildItemRow(
                  'غير متعامل', data.paintApprovalInStoreModel?.not_dealing),
            ],
          ),
          _buildMultiValueSection(
            title: 'طريقة عرض منتجات GMC',
            items: [
              _buildItemRow(
                  'في الواجهة', data.gmcProductDisplayMethodModel?.front),
              _buildItemRow('داخل المتجر - بشكل واضح',
                  data.gmcProductDisplayMethodModel?.inside_clear),
              _buildItemRow('داخل المتجر - غير واضح',
                  data.gmcProductDisplayMethodModel?.inside_unclear),
              _buildItemRow('موجود - غير مرئي',
                  data.gmcProductDisplayMethodModel?.exists_not_visible),
              _buildItemRow('غير متوفر',
                  data.gmcProductDisplayMethodModel?.not_available),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildMultiValueSection(
                      title: 'وصف العميل',
                      items: [
                        _buildItemRow('مالك المتجر',
                            data.customerDescriptionModel?.store_owner),
                        _buildItemRow(
                            'عامل', data.customerDescriptionModel?.worker),
                      ],
                    ),
                    _buildMultiValueSection(
                      title: 'طريقة بيع المعجون',
                      items: [
                        _buildItemRow(
                            'جاهز', data.puttySellingMethodModel?.ready),
                        _buildItemRow(
                            'تجميعي', data.puttySellingMethodModel?.assembled),
                        _buildItemRow(
                            'لا يوجد', data.puttySellingMethodModel?.none),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _buildMultiValueSection(
                      title: 'طبيعة التعامل مع الزبون',
                      items: [
                        _buildItemRow('متعاون',
                            data.customerInteractionNatureModel?.cooperative),
                        _buildItemRow('عملي',
                            data.customerInteractionNatureModel?.practical),
                        _buildItemRow('غير متعاون',
                            data.customerInteractionNatureModel?.uncooperative),
                      ],
                    ),
                    _buildMultiValueSection(
                      title: 'نوع العمل',
                      items: [
                        _buildItemRow('مفرق', data.businessTypeModel?.retail),
                        _buildItemRow(
                            'نص جملة', data.businessTypeModel?.semi_wholesale),
                        _buildItemRow(
                            'جملة', data.businessTypeModel?.wholesale),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          _buildMultiValueSection(
            title: 'متوسط نسب المنتجات',
            items: [
              _buildItemRow('دهانات',
                  data.productPercentagesAverageModel?.paints_percentage),
              _buildItemRow('خرداوات',
                  data.productPercentagesAverageModel?.hardware_percentage),
              _buildItemRow('كهربائيات',
                  data.productPercentagesAverageModel?.electrical_percentage),
              _buildItemRow(
                  'مواد بناء',
                  data.productPercentagesAverageModel
                      ?.building_materials_percentage),
              _buildItemRow('صحية',
                  data.productPercentagesAverageModel?.healthy_percentage),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeView(MarketSurveySummaryModel data) {
    // Determine the text to display for selected regions
    String regionsText =
        selectedRegions.isEmpty ? 'جميع المناطق' : selectedRegions.join(' - ');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: Column(
        children: [
          _buildSingleValueSection(
            title: 'وجود GMC في السوق',
            value: data.gmc_market_presence_percentage ?? 0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... [First Column: Sales Activity, Paint Approval, GMC Display]
              Expanded(
                child: Column(
                  children: [
                    _buildMultiValueSection(
                      title: 'حركة البيع أثناء الزيارة',
                      items: [
                        _buildItemRow(
                            'قوية', data.salesActivityDuringVisitModel?.strong),
                        _buildItemRow(
                            'متوسطة', data.salesActivityDuringVisitModel?.mid),
                        _buildItemRow(
                            'ضعيفة', data.salesActivityDuringVisitModel?.weak),
                        _buildItemRow('لا يوجد حركة',
                            data.salesActivityDuringVisitModel?.no_activity),
                      ],
                    ),
                    _buildMultiValueSection(
                      title: 'اعتماد الدهان في المتجر',
                      items: [
                        _buildItemRow(
                            'رئيسي', data.paintApprovalInStoreModel?.primary),
                        _buildItemRow(
                            'ثانوي', data.paintApprovalInStoreModel?.secondary),
                        _buildItemRow('عند الطلب',
                            data.paintApprovalInStoreModel?.on_demand),
                        _buildItemRow('غير متعامل',
                            data.paintApprovalInStoreModel?.not_dealing),
                      ],
                    ),
                    _buildMultiValueSection(
                      title: 'طريقة عرض منتجات GMC',
                      items: [
                        _buildItemRow('في الواجهة',
                            data.gmcProductDisplayMethodModel?.front),
                        _buildItemRow('داخل المتجر - بشكل واضح',
                            data.gmcProductDisplayMethodModel?.inside_clear),
                        _buildItemRow('داخل المتجر - غير واضح',
                            data.gmcProductDisplayMethodModel?.inside_unclear),
                        _buildItemRow(
                            'موجود - غير مرئي',
                            data.gmcProductDisplayMethodModel
                                ?.exists_not_visible),
                        _buildItemRow('غير متوفر',
                            data.gmcProductDisplayMethodModel?.not_available),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // ... [Second Column: Customer Description, Putty Method, Interaction, Business Type]
              Expanded(
                child: Column(
                  children: [
                    _buildMultiValueSection(
                      title: 'وصف العميل',
                      items: [
                        _buildItemRow('مالك المتجر',
                            data.customerDescriptionModel?.store_owner),
                        _buildItemRow(
                            'عامل', data.customerDescriptionModel?.worker),
                      ],
                    ),
                    _buildMultiValueSection(
                      title: 'طريقة بيع المعجون',
                      items: [
                        _buildItemRow(
                            'جاهز', data.puttySellingMethodModel?.ready),
                        _buildItemRow(
                            'تجميعي', data.puttySellingMethodModel?.assembled),
                        _buildItemRow(
                            'لا يوجد', data.puttySellingMethodModel?.none),
                      ],
                    ),
                    _buildMultiValueSection(
                      title: 'طبيعة التعامل مع الزبون',
                      items: [
                        _buildItemRow('متعاون',
                            data.customerInteractionNatureModel?.cooperative),
                        _buildItemRow('عملي',
                            data.customerInteractionNatureModel?.practical),
                        _buildItemRow('غير متعاون',
                            data.customerInteractionNatureModel?.uncooperative),
                      ],
                    ),
                    _buildMultiValueSection(
                      title: 'نوع العمل',
                      items: [
                        _buildItemRow('مفرق', data.businessTypeModel?.retail),
                        _buildItemRow(
                            'نص جملة', data.businessTypeModel?.semi_wholesale),
                        _buildItemRow(
                            'جملة', data.businessTypeModel?.wholesale),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // --- Third Column: Product Percentages & Additional Info ---
              Expanded(
                child: Column(
                  children: [
                    _buildMultiValueSection(
                      title: 'متوسط نسب المنتجات',
                      items: [
                        _buildItemRow(
                            'دهانات',
                            data.productPercentagesAverageModel
                                ?.paints_percentage),
                        _buildItemRow(
                            'خرداوات',
                            data.productPercentagesAverageModel
                                ?.hardware_percentage),
                        _buildItemRow(
                            'كهربائيات',
                            data.productPercentagesAverageModel
                                ?.electrical_percentage),
                        _buildItemRow(
                            'مواد بناء',
                            data.productPercentagesAverageModel
                                ?.building_materials_percentage),
                        _buildItemRow(
                            'صحية',
                            data.productPercentagesAverageModel
                                ?.healthy_percentage),
                      ],
                    ),

                    // --- Updated Additional Statistics Card ---
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey.withOpacity(0.15)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('إحصائيات إضافية',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            const Divider(height: 24),
                            Text(
                              'فترة التقرير: ${_fromDateController.text} - ${_toDateController.text}',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'المناطق المختارة:',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              regionsText,
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedRegions.isEmpty
                                    ? Colors.grey
                                    : Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSingleValueSection({required String title, required int value}) {
    final color = _getPercentageColor(value);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('النسبة'),
                Text(
                  '$value%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 8,
                backgroundColor: color.withOpacity(0.15),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiValueSection(
      {required String title, required List<Widget> items}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const Divider(height: 24),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(String label, int? value) {
    final int val = value ?? 0;
    final Color color = _getPercentageColor(val);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13)),
              Text('$val%',
                  style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: val / 100,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPercentageColor(int percentage) {
    if (percentage >= 60) return Colors.green;
    if (percentage >= 30) return Colors.orange;
    if (percentage > 0) return Colors.blueAccent;
    return Colors.grey;
  }
}
