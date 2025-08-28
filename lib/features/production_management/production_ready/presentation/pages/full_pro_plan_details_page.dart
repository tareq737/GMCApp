import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/common/widgets/text_field_with_suggestions.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/pages/full_prod_plan_page.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/view_model/prod_planning_viewmodel.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'dart:ui' as ui;

class FullProPlanDetailsPage extends StatefulWidget {
  final ProdPlanViewModel prodPlanViewModel;

  const FullProPlanDetailsPage({
    super.key,
    required this.prodPlanViewModel,
  });

  @override
  State<FullProPlanDetailsPage> createState() => _FullProPlanDetailsPageState();
}

class _FullProPlanDetailsPageState extends State<FullProPlanDetailsPage> {
  String? _selectedType;
  String? _selectedTier;

  String? _selectedColor;

  static const List<String> _types = [
    'زياتي فواتح',
    'مركز زياتي فواتح',
    'مركز زياتي غوامق',
    'زياتي غوامق',
    'أكرليك',
    'معجونة',
    'سواغ',
    'مركز مائي',
    'طرش',
    'نترو',
    'ديكورات + ملونات',
    'تفريغ',
    'صناعي',
  ];

  static const Map<String, List<String>> _typeTiers = {
    'زياتي فواتح': [
      'بروفيشنال لميع',
      'بروفيشنال نص لمعة',
      'بروفيشنال ربع لمعة',
      'بروفيشنال مت',
      'جمس لميع',
      'جمس نص لمعة',
      'جمس ربع لمعة',
      'جمس مت',
      'كلاسيك لميع',
      'كلاسيك نص لمعة',
      'كلاسيك ربع لمعة',
      'كلاسيك مت',
      '202 لميع',
      '202 نص لمعة',
      '202 مت',
      '101 لميع',
      '101 نص لمعة',
      '101 مت',
      'ايكو لميع',
      'ايكو نص لمعة',
      'ايكو مت',
      'لكر جمس',
      'لكر جمس نص لمعة',
      'لكر جمس مت',
      'لكر 202',
      'لكر 202 نص لمعة',
      'لكر 202 مت',
      'كلاسيك اندركوت',
      'جمس مميز',
      'زياتي 202 مميز ',
      'جمس ممدد',
      'زياتي 202 ممدد'
    ],
    'صناعي': [
      'جمس ألمنيوم',
      '202 ألمنيوم',
    ],
    'نترو': [
      'همروك',
      'جمس',
    ],
    'طرش': [
      'جمس',
      'كلاسيك',
      'سلر مائي ',
      '202',
      '101',
      'ايكو',
      'اقتصادي',
    ],
    'أكرليك': [
      'كلاسيك لميع',
      'كلاسيك نص لمعة',
      'كلاسيك ربع لمعة',
      'كلاسيك مت',
      'كلاسيك اندركوت',
      'كلاسيك ابتك',
      'جمس لميع',
      'جمس نص لمعة',
      'جمس ربع لمعة',
      'جمس مت',
      'جمس اندركوت',
      'كلاسيك ',
      'غراء',
      'أندركوت اقتصادي',
      'أندركوت لميع',
    ],
    'معجونة': [
      'كلاسيك ',
      'سماكات ',
    ],
    'ديكورات + ملونات': [
      'فيلفيت',
      'كنزي',
      'روعة',
      'فلور',
      'ديكو هوم',
      'غروب الشمس',
      'تكسير',
      'ستوكو',
      'جليز',
      'ديكو ميتال',
      'مائي',
      'منشف',
    ],
    'سواغ': [
      'زياتي ايكو',
      'محلول فيسكوجيل',
      'محلول فيسكوجيل أهرة',
      'محلول الكول ',
      'منشف',
      'زياتي ايكو بالكيد 90-638% ',
      'زياتي بالكيد 90-638% ',
    ],
    'مركز زياتي فواتح': [
      'بألكيد طويل',
      'بألكيد متوسط',
    ],
    'مركز زياتي غوامق': [
      'بألكيد طويل',
    ],
    'زياتي غوامق': [
      'جمس لميع',
      'جمس نص لمعة',
      'جمس ربع لمعة',
      'جمس مت',
      'كلاسيك لميع',
      'كلاسيك نص لمعة',
      'كلاسيك ربع لمعة',
      'كلاسيك مت',
      '202 لميع',
      '202 نص لمعة',
      '202 مت',
      '101 لميع',
      '101 نص لمعة',
      '101 مت',
      'ايكو لميع',
      'ايكو نص لمعة',
      'ايكو مت',
    ],
    'مركز مائي': [
      'جمس',
      'كلاسيك',
      '202',
      '101',
      'ايكو',
      'اكرليك جمس',
      'اكرليك كلاسيك',
    ],
    'تفريغ': ['جمس'],
  };

  static const List<String> colorSuggestions = [
    'أبيض',
    'نصف لمعة',
    'مت',
    'ربع لمعة',
    'أسود',
    'بني غامق',
    'بني فاتح',
    'بني غامق مت',
    'بني فاتح مت',
    'أخضر',
    'أخضر مت',
    'أصفر ل',
    'أصفر م',
    'أحمر',
    'أهرة',
    'عسلي',
    'كحلي',
    'كريم',
    'سيرقون أحمر',
    'سيرقون رمادي',
    'سيرقون أصفر',
    'سيرقون أسود',
    'سيرقون برتقالي',
    'ألماسي',
    'مارون',
    'أسود مت',
    'عسلي مت',
    'سلر',
    'لكر',
    'برونز',
    'ذهبي',
    'أزرق',
    '330',
    'بنفسجي',
    '210',
    'فضي',
    'المنيوم',
  ];
  final _preparedByNotesController = TextEditingController();
  final _densityController = TextEditingController();
  final _rawMaterialNoteController = TextEditingController();
  final _manufacturingNoteController = TextEditingController();
  final _labNoteController = TextEditingController();
  final _emptyPackagingNoteController = TextEditingController();
  final _packagingNoteController = TextEditingController();
  final _finishedGoodsNoteController = TextEditingController();

  bool? _rawMaterialCheck = false;
  bool? _manufacturingCheck = false;
  bool? _labCheck = false;
  bool? _emptyPackagingCheck = false;
  bool? _packagingCheck = false;
  bool? _finishedGoodsCheck = false;

  List<Map<String, TextEditingController>> rows = [];

  double _totalWeight = 0.0;
  double _totalSize = 0.0;

  ProdPlanViewModel? _prodPlan;

  @override
  void initState() {
    super.initState();
    _prodPlan = widget.prodPlanViewModel;
    _selectedType = widget.prodPlanViewModel.type;
    _selectedTier = widget.prodPlanViewModel.tier;
    _selectedColor = widget.prodPlanViewModel.color;
    _densityController.text = widget.prodPlanViewModel.density != null
        ? widget.prodPlanViewModel.density.toString()
        : "";
    _preparedByNotesController.text =
        widget.prodPlanViewModel.preparedByNotes ?? '';
    _rawMaterialNoteController.text =
        widget.prodPlanViewModel.depNotes['rawMaterial'] ?? '';
    _manufacturingNoteController.text =
        widget.prodPlanViewModel.depNotes['manufacturing'] ?? '';
    _labNoteController.text = widget.prodPlanViewModel.depNotes['lab'] ?? '';
    _emptyPackagingNoteController.text =
        widget.prodPlanViewModel.depNotes['emptyPackaging'] ?? '';
    _packagingNoteController.text =
        widget.prodPlanViewModel.depNotes['packaging'] ?? '';
    _finishedGoodsNoteController.text =
        widget.prodPlanViewModel.depNotes['finishedGoods'] ?? '';
    _rawMaterialCheck = widget.prodPlanViewModel.depChecks['rawMaterial'];
    _manufacturingCheck = widget.prodPlanViewModel.depChecks['manufacturing'];
    _labCheck = widget.prodPlanViewModel.depChecks['lab'];
    _emptyPackagingCheck = widget.prodPlanViewModel.depChecks['emptyPackaging'];
    _packagingCheck = widget.prodPlanViewModel.depChecks['packaging'];
    _finishedGoodsCheck = widget.prodPlanViewModel.depChecks['finishedGoods'];

    // Initialize packaging breakdown rows
    for (var breakdown in widget.prodPlanViewModel.packagingBreakdown!) {
      rows.add({
        "الصنف": TextEditingController(text: breakdown.brand),
        "العبوة": TextEditingController(text: breakdown.packageType),
        "الوزن":
            TextEditingController(text: breakdown.packageWeight.toString()),
        "الحجم":
            TextEditingController(text: breakdown.packageVolume.toString()),
        "العدد": TextEditingController(text: breakdown.quantity.toString()),
      });
    }

    // Calculate the totals based on initial data
    _calculateTotals();
  }

  void _addNewCard() {
    setState(() {
      rows.add({
        "الصنف": TextEditingController(),
        "العبوة": TextEditingController(),
        "الوزن": TextEditingController(),
        "الحجم": TextEditingController(),
        "العدد": TextEditingController(),
      });
    });
  }

  void _fillProdPlanfromFormProductionManagers() {
    _prodPlan!.id = widget.prodPlanViewModel.id;
    _prodPlan!.type = _selectedType ?? '';
    _prodPlan!.tier = _selectedTier ?? '';
    _prodPlan!.color = _selectedColor ?? '';
    _prodPlan!.preparedByNotes = _preparedByNotesController.text;
    _prodPlan!.packagingBreakdown =
        List<PackageBreakdownViewModel>.generate(rows.length, (index) {
      return PackageBreakdownViewModel(
        brand: rows[index]['الصنف']!.text,
        packageType: rows[index]['العبوة']!.text,
        packageWeight: double.tryParse(rows[index]['الوزن']!.text) ?? 0.0,
        packageVolume: double.tryParse(rows[index]['الحجم']!.text) ?? 0.0,
        quantity: int.tryParse(rows[index]['العدد']!.text) ?? 0,
      );
    });
    _prodPlan!.totalVolume = _totalSize;
    _prodPlan!.totalWeight = _totalWeight;
  }

  void _fillRawDepartment() {
    _prodPlan!.id = widget.prodPlanViewModel.id;
    _prodPlan!.depChecks = {
      'rawMaterial': _rawMaterialCheck,
    };
    _prodPlan!.depNotes = {
      'rawMaterial': _rawMaterialNoteController.text,
    };
  }

  void _fillManufacturingDepartment() {
    _prodPlan!.id = widget.prodPlanViewModel.id;
    _prodPlan!.depChecks = {'manufacturing': _manufacturingCheck};
    _prodPlan!.depNotes = {'manufacturing': _manufacturingNoteController.text};
  }

  void _fillLabDepartment() {
    _prodPlan = ProdPlanViewModel(
      id: widget.prodPlanViewModel.id,
      type: widget.prodPlanViewModel.type,
      tier: widget.prodPlanViewModel.tier,
      color: widget.prodPlanViewModel.color,
      depChecks: {'lab': _labCheck},
      depNotes: {'lab': _labNoteController.text},
      density: double.tryParse(_densityController.text) ?? 0,
    );
  }

  void _fillPackingDepartment() {
    _prodPlan!.id = widget.prodPlanViewModel.id;
    _prodPlan!.depChecks = {
      'emptyPackaging': _emptyPackagingCheck,
      'packaging': _packagingCheck,
    };
    _prodPlan!.depNotes = {
      'emptyPackaging': _emptyPackagingNoteController.text,
      'packaging': _packagingNoteController.text,
    };
  }

  void _fillFinishDepartment() {
    _prodPlan!.id = widget.prodPlanViewModel.id;
    _prodPlan!.depChecks = {'finishedGoods': _finishedGoodsCheck};
    _prodPlan!.depNotes = {'finishedGoods': _finishedGoodsNoteController.text};
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(List<String> items) {
    return items.map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
  }

  void _removeCard(int index) {
    setState(() {
      rows.removeAt(index);
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    double totalWeight = 0.0;
    double totalSize = 0.0;

    final density = double.tryParse(_densityController.text);

    for (var row in rows) {
      // Parse current values
      final weightText = row["الوزن"]!.text;
      final sizeText = row["الحجم"]!.text;
      final countText = row["العدد"]!.text;

      double weight = double.tryParse(weightText) ?? 0.0;
      double size = double.tryParse(sizeText) ?? 0.0;
      int count = int.tryParse(countText) ?? 0;

      // Only perform conversions if density is valid and > 0
      if (density != null && density > 0.0) {
        // If weight is provided but size is empty/zero, calculate size
        if (weightText.isNotEmpty &&
            weight > 0 &&
            (sizeText.isEmpty || size == 0)) {
          size = weight / density;
          row["الحجم"]!.text = size.toStringAsFixed(2);
        }
        // If size is provided but weight is empty/zero, calculate weight
        else if (sizeText.isNotEmpty &&
            size > 0 &&
            (weightText.isEmpty || weight == 0)) {
          weight = size * density;
          row["الوزن"]!.text = weight.toStringAsFixed(2);
        }
      }

      // Calculate totals
      totalWeight += weight * count;
      totalSize += size * count;
    }

    setState(() {
      _totalWeight = totalWeight;
      _totalSize = totalSize;
    });
  }

  List<String>? groups;
  @override
  Widget build(BuildContext context) {
    AppUserState state = context.watch<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BlocProvider(
        create: (context) => getIt<ProdPlanBloc>(),
        child: Builder(
          builder: (context) {
            return BlocConsumer<ProdPlanBloc, ProdState>(
              listener: (context, state) {
                if (state is ProdOpSuccess<ProdPlanViewModel>) {
                  showSnackBar(
                    context: context,
                    content: 'تم التعديل بنجاح',
                    failure: false,
                  );
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (
                        context,
                      ) {
                        return const FullProdPlanPage();
                      },
                    ),
                  );
                } else if (state is ProdOpFailure) {
                  showSnackBar(
                    context: context,
                    content: 'حدث خطأ ما',
                    failure: true,
                  );
                } else if (state is ProdOpSuccess<String>) {
                  showSnackBar(
                    context: context,
                    content: 'تم نقل الطبخة من الجهوزية إلى الإنتاج ',
                    failure: false,
                  );
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (
                        context,
                      ) {
                        return const FullProdPlanPage();
                      },
                    ),
                  );
                }
              },
              builder: (BuildContext context, ProdState state) {
                if (state is ProdOpLoading) {
                  return const Center(child: Scaffold(body: Loader()));
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      title: const Text(
                        'صفحة الجهوزية',
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Directionality(
                          textDirection: ui.TextDirection.rtl,
                          child: Column(
                            spacing: 10,
                            children: [
                              Text(
                                'تاريخ الإدراج: ${widget.prodPlanViewModel.insertDate ?? ''}',
                              ),

                              Wrap(
                                spacing: 10,
                                runSpacing: 20,
                                children: [
                                  MyDropdownButton(
                                    items: _buildDropdownItems(_types),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedType = value;
                                        _selectedTier = null;
                                      });
                                    },
                                    value: _selectedType,
                                    labelText: 'نوع الدهان',
                                  ),
                                  MyDropdownButton(
                                    items: _buildDropdownItems(
                                      _selectedType != null
                                          ? _typeTiers[_selectedType] ?? []
                                          : [],
                                    ),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _selectedTier = value;
                                      });
                                    },
                                    value: _selectedTier,
                                    labelText: 'المستوى',
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: MyDropdownButton(
                                          items: _buildDropdownItems(
                                              colorSuggestions),
                                          onChanged: (String? value) {
                                            setState(() {
                                              _selectedColor = value;
                                            });
                                          },
                                          value: _selectedColor,
                                          labelText: 'اللون',
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: MyTextField(
                                          onChanged: (value) {},
                                          controller: _densityController,
                                          textAlign: TextAlign.center,
                                          labelText: "الكثافة",
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*')),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Cards
                              Column(
                                children: rows.asMap().entries.map(
                                  (entry) {
                                    int index = entry.key;
                                    Map<String, TextEditingController> row =
                                        entry.value;
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: _buildTextField(
                                                    row["الصنف"]!,
                                                    "الصنف",
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: _buildTextField(
                                                    row["العبوة"]!,
                                                    "العبوة",
                                                    options: [
                                                      'برميل',
                                                      'غالون',
                                                      'كيلو',
                                                      'نص كيلو',
                                                      'ربع كيلو',
                                                      'كرتونة',
                                                      'كيس',
                                                      'عبوة',
                                                      'فرط',
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: _buildTextField(
                                                    row["العدد"]!,
                                                    "العدد",
                                                    onChanged: _calculateTotals,
                                                    isNumeric:
                                                        true, // Ensure this field is numeric
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: _buildTextField(
                                                    row["الوزن"]!,
                                                    "الوزن",
                                                    onChanged: _calculateTotals,
                                                    isDecimal: true,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: _buildTextField(
                                                    row["الحجم"]!,
                                                    "الحجم",
                                                    onChanged: _calculateTotals,
                                                    isDecimal: true,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                        'مجموع الوزن',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                      Builder(
                                                        builder: (context) {
                                                          // Convert text values to numbers
                                                          final weight = double
                                                                  .tryParse(row[
                                                                          "الوزن"]!
                                                                      .text) ??
                                                              0;
                                                          final count = double
                                                                  .tryParse(row[
                                                                          "العدد"]!
                                                                      .text) ??
                                                              0;
                                                          final weightTotal =
                                                              weight * count;

                                                          return Text(
                                                            ' ${weightTotal.toStringAsFixed(2)}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                      const Text(
                                                        'مجموع الحجم',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                      Builder(
                                                        builder: (context) {
                                                          // Convert text values to numbers
                                                          final volume = double
                                                                  .tryParse(row[
                                                                          "الحجم"]!
                                                                      .text) ??
                                                              0;
                                                          final count = double
                                                                  .tryParse(row[
                                                                          "العدد"]!
                                                                      .text) ??
                                                              0;
                                                          final volumeTotal =
                                                              volume * count;

                                                          return Text(
                                                            volumeTotal
                                                                .toStringAsFixed(
                                                                    2),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      _removeCard(index);
                                                    },
                                                    icon: const Icon(
                                                      size: 20,
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                              if ((groups!.contains('admins') ||
                                  groups!.contains('production_managers')))
                                ElevatedButton(
                                  onPressed: _addNewCard,
                                  child: const Text('+ تعبئة جديدة'),
                                ),
                              Text(
                                  'إجمالي الوزن: ${_totalWeight.toStringAsFixed(2)}'),
                              Text(
                                  'إجمالي الحجم: ${_totalSize.toStringAsFixed(2)}'),

                              const SizedBox(height: 10),
                              MyTextField(
                                  maxLines: 10,
                                  controller: _preparedByNotesController,
                                  labelText: 'ملاحظة معد البرنامج'),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _rawMaterialCheck,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _rawMaterialCheck = value ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                        maxLines: 10,
                                        controller: _rawMaterialNoteController,
                                        labelText: 'ملاحظات الأولية'),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if ((groups!.contains('admins') ||
                                      groups!.contains('raw_material_dep')))
                                    IconButton(
                                      onPressed: () {
                                        _fillRawDepartment();
                                        context.read<ProdPlanBloc>().add(
                                              ProdUpdate<ProdPlanViewModel>(
                                                  item: _prodPlan!),
                                            );
                                      },
                                      color: Colors.grey,
                                      icon: const Icon(Icons.save),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _manufacturingCheck,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _manufacturingCheck = value ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                        maxLines: 10,
                                        controller:
                                            _manufacturingNoteController,
                                        labelText: 'ملاحظات التصنيع'),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if ((groups!.contains('admins') ||
                                      groups!.contains('manufacturing_dep')))
                                    IconButton(
                                      onPressed: () {
                                        _fillManufacturingDepartment();
                                        context.read<ProdPlanBloc>().add(
                                              ProdUpdate<ProdPlanViewModel>(
                                                  item: _prodPlan!),
                                            );
                                      },
                                      color: Colors.grey,
                                      icon: const Icon(Icons.save),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _labCheck,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _labCheck = value ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                        maxLines: 10,
                                        controller: _labNoteController,
                                        labelText: 'ملاحظات المخبر'),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if ((groups!.contains('admins') ||
                                      groups!.contains('lab_dep')))
                                    IconButton(
                                      onPressed: () {
                                        _fillLabDepartment();
                                        _calculateTotals();
                                        context.read<ProdPlanBloc>().add(
                                              ProdUpdate<ProdPlanViewModel>(
                                                  item: _prodPlan!),
                                            );
                                        print(_densityController.text);
                                      },
                                      color: Colors.grey,
                                      icon: const Icon(Icons.save),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _emptyPackagingCheck,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _emptyPackagingCheck = value ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                        maxLines: 10,
                                        controller:
                                            _emptyPackagingNoteController,
                                        labelText: 'ملاحظات الفوارغ'),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if ((groups!.contains('admins') ||
                                      groups!.contains('emptyPackaging_dep')))
                                    IconButton(
                                      onPressed: () {
                                        _fillPackingDepartment();
                                        context.read<ProdPlanBloc>().add(
                                              ProdUpdate<ProdPlanViewModel>(
                                                  item: _prodPlan!),
                                            );
                                      },
                                      color: Colors.grey,
                                      icon: const Icon(Icons.save),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _packagingCheck,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _packagingCheck = value ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                        maxLines: 10,
                                        controller: _packagingNoteController,
                                        labelText: 'ملاحظات التعبئة'),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if ((groups!.contains('admins') ||
                                      groups!.contains('packaging_dep')))
                                    IconButton(
                                      onPressed: () {
                                        _fillPackingDepartment();
                                        context.read<ProdPlanBloc>().add(
                                              ProdUpdate<ProdPlanViewModel>(
                                                  item: _prodPlan!),
                                            );
                                      },
                                      color: Colors.grey,
                                      icon: const Icon(Icons.save),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    activeColor: Colors.green,
                                    checkColor: Colors.white,
                                    value: _finishedGoodsCheck,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _finishedGoodsCheck = value ?? false;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                        maxLines: 10,
                                        controller:
                                            _finishedGoodsNoteController,
                                        labelText: 'ملاحظات الجاهزة'),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  if ((groups!.contains('admins') ||
                                      groups!.contains('finishedGoods_dep')))
                                    IconButton(
                                      onPressed: () {
                                        _fillFinishDepartment();
                                        context.read<ProdPlanBloc>().add(
                                              ProdUpdate<ProdPlanViewModel>(
                                                  item: _prodPlan!),
                                            );
                                      },
                                      color: Colors.grey,
                                      icon: const Icon(Icons.save),
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                ],
                              ),
                              if ((groups!.contains('admins') ||
                                  groups!.contains('production_managers')))
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Mybutton(
                                      text: 'تعديل',
                                      onPressed: () {
                                        _fillProdPlanfromFormProductionManagers();
                                        context.read<ProdPlanBloc>().add(
                                              ProdUpdate<ProdPlanViewModel>(
                                                  item: _prodPlan!),
                                            );
                                      },
                                    ),
                                    Mybutton(
                                      text: 'ترحيل',
                                      onPressed: () {
                                        if (widget.prodPlanViewModel.depChecks[
                                                    'rawMaterial'] ==
                                                true &&
                                            widget.prodPlanViewModel.depChecks[
                                                    'manufacturing'] ==
                                                true &&
                                            widget.prodPlanViewModel.depChecks[
                                                    'lab'] ==
                                                true &&
                                            widget.prodPlanViewModel.depChecks[
                                                    'emptyPackaging'] ==
                                                true &&
                                            widget.prodPlanViewModel
                                                    .depChecks['packaging'] ==
                                                true &&
                                            widget.prodPlanViewModel.depChecks[
                                                    'finishedGoods'] ==
                                                true) {
                                          context.read<ProdPlanBloc>().add(
                                                ProdPlanTransfer(
                                                    id: widget
                                                        .prodPlanViewModel.id),
                                              );
                                        } else {
                                          showSnackBar(
                                              context: context,
                                              content:
                                                  'يجب أن تكون جميع الأقسام جاهزة',
                                              failure: true);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    VoidCallback? onChanged,
    double labelTextSize = 10.0,
    double textSize = 10.0,
    bool isNumeric = false, // Indicates if the field should be numeric
    bool isDecimal =
        false, // Indicates if the field should support decimal numbers
    List<String>? options, // List of selectable options
  }) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return options != null
        ? DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                  fontSize: labelTextSize,
                  color: isDark ? Colors.white : Colors.black),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              border: const OutlineInputBorder(),
            ),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    style: TextStyle(
                        fontSize: textSize,
                        color: isDark ? Colors.white : Colors.black)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.text = newValue; // Update the controller's value
                if (onChanged != null) {
                  onChanged();
                }
              }
            },
          )
        : TextField(
            controller: controller,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: labelTextSize),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              border: const OutlineInputBorder(),
            ),
            style: TextStyle(
                fontSize: 12, color: isDark ? Colors.white : Colors.black),
            keyboardType: isDecimal
                ? const TextInputType.numberWithOptions(
                    decimal: true) // Numeric keyboard with decimal point
                : isNumeric
                    ? TextInputType.number // Numeric keyboard
                    : TextInputType.text, // Default keyboard
            inputFormatters: isDecimal
                ? [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ] // Allow decimal input
                : isNumeric
                    ? [
                        FilteringTextInputFormatter.digitsOnly
                      ] // Allow only digits
                    : [],
            maxLines: null,
            minLines: 1,
            onChanged: (_) {
              if (onChanged != null) {
                onChanged();
              }
            },
          );
  }
}
