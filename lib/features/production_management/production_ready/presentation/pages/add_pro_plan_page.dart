import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/common/widgets/text_field_with_suggestions.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/pages/full_prod_plan_page.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/view_model/prod_planning_viewmodel.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class AddProdPlanPage extends StatefulWidget {
  const AddProdPlanPage({super.key});

  @override
  State<AddProdPlanPage> createState() => _AddProdPlanPageState();
}

class _AddProdPlanPageState extends State<AddProdPlanPage> {
  String? _selectedType;
  String? _selectedTier;
  String? _selectedColor;

  String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

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
      'جمس اقتصادي',
      'زياتي 202 اقتصادي ',
      'جمس ممدد',
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

  final ProdPlanViewModel _prodPlan = ProdPlanViewModel(
    id: 0,
    type: '',
    tier: '',
    color: '',
  );

  final _preparedByNotesController = TextEditingController();

  List<Map<String, TextEditingController>> rows = [];

  double _totalWeight = 0.0;
  double _totalSize = 0.0;

  @override
  void initState() {
    super.initState();
  }

  void _fillProdPlanfromForm() {
    _prodPlan.insertDate = todayDate;
    _prodPlan.type = _selectedType ?? '';
    _prodPlan.tier = _selectedTier ?? '';
    _prodPlan.color = _selectedColor ?? '';
    _prodPlan.preparedByNotes = _preparedByNotesController.text;
    _prodPlan.packagingBreakdown =
        List<PackageBreakdownViewModel>.generate(rows.length, (index) {
      return PackageBreakdownViewModel(
        brand: rows[index]['الصنف']!.text,
        packageType: rows[index]['العبوة']!.text,
        packageWeight: double.tryParse(rows[index]['الوزن']!.text) ?? 0.0,
        packageVolume: double.tryParse(rows[index]['الحجم']!.text) ?? 0.0,
        quantity: int.tryParse(rows[index]['العدد']!.text) ?? 0,
      );
    });
    _prodPlan.totalVolume = _totalSize;
    _prodPlan.totalWeight = _totalWeight;
  }

  List<DropdownMenuItem<String>> _buildDropdownItems(List<String> items) {
    return items.map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList();
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

  void _removeCard(int index) {
    setState(() {
      rows.removeAt(index);
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    double totalWeight = 0.0;
    double totalSize = 0.0;

    for (var row in rows) {
      final weight = double.tryParse(row["الوزن"]!.text) ?? 0.0;
      final size = double.tryParse(row["الحجم"]!.text) ?? 0.0;
      final count = int.tryParse(row["العدد"]!.text) ?? 0;

      totalWeight += weight * count;
      totalSize += size * count;
    }

    setState(() {
      _totalWeight = totalWeight;
      _totalSize = totalSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProdPlanBloc>(),
      child: Builder(builder: (context) {
        return BlocListener<ProdPlanBloc, ProdState>(
          listener: (context, state) {
            if (state is ProdOpSuccess<ProdPlanViewModel>) {
              showSnackBar(
                context: context,
                content: 'تمت الإضافة بنجاح',
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
            }
          },
          child: Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
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
                      children: [
                        const Text(
                          'رقم الطبخة:',
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'التاريخ: $todayDate',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
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
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 16),
                            MyDropdownButton(
                              items: _buildDropdownItems(colorSuggestions),
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedColor = value;
                                });
                              },
                              value: _selectedColor,
                              labelText: 'اللون',
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Cards
                        Column(
                          children: rows.asMap().entries.map(
                            (entry) {
                              int index = entry.key;
                              Map<String, TextEditingController> row =
                                  entry.value;
                              return Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                            MainAxisAlignment.spaceBetween,
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
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  'مجموع الوزن',
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    // Convert text values to numbers
                                                    final weight =
                                                        double.tryParse(
                                                                row["الوزن"]!
                                                                    .text) ??
                                                            0;
                                                    final count =
                                                        double.tryParse(
                                                                row["العدد"]!
                                                                    .text) ??
                                                            0;
                                                    final weightTotal =
                                                        weight * count;

                                                    return Text(
                                                      ' ${weightTotal.toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                const Text(
                                                  'مجموع الحجم',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                                Builder(
                                                  builder: (context) {
                                                    // Convert text values to numbers
                                                    final volume =
                                                        double.tryParse(
                                                                row["الحجم"]!
                                                                    .text) ??
                                                            0;
                                                    final count =
                                                        double.tryParse(
                                                                row["العدد"]!
                                                                    .text) ??
                                                            0;
                                                    final volumeTotal =
                                                        volume * count;

                                                    return Text(
                                                      volumeTotal
                                                          .toStringAsFixed(2),
                                                      style: const TextStyle(
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
                        const SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: _addNewCard,
                          child: const Text('+ تعبئة جديدة'),
                        ),
                        const SizedBox(height: 20),
                        Text('إجمالي الوزن: $_totalWeight'),
                        Text('إجمالي الحجم: $_totalSize'),
                        const SizedBox(height: 20),
                        MyTextField(
                            maxLines: 10,
                            controller: _preparedByNotesController,
                            labelText: 'ملاحظة معد البرنامج'),
                        const SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.all(8.0),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _fillProdPlanfromForm();
                                context.read<ProdPlanBloc>().add(
                                      ProdAdd<ProdPlanViewModel>(
                                          item: _prodPlan),
                                    );
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.all(8.0),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
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
    bool readOnly = false, // New read-only parameter
  }) {
    return options != null
        ? DropdownButtonFormField<String>(
            value: controller.text.isNotEmpty ? controller.text : null,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: labelTextSize),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              border: const OutlineInputBorder(),
            ),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: textSize)),
              );
            }).toList(),
            onChanged: readOnly
                ? null // Disable selection if read-only
                : (String? newValue) {
                    if (newValue != null) {
                      controller.text =
                          newValue; // Update the controller's value
                      if (onChanged != null) {
                        onChanged();
                      }
                    }
                  },
          )
        : TextField(
            controller: controller,
            textAlign: TextAlign.center,
            readOnly: readOnly, // Apply read-only state
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: labelTextSize),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              border: const OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: textSize),
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
