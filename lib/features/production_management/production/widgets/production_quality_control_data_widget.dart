import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/quality_control_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_list.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ProductionQualityControlDataWidget extends StatefulWidget {
  final String type;
  final FullProductionModel fullProductionModel;
  const ProductionQualityControlDataWidget({
    super.key,
    required this.type,
    required this.fullProductionModel,
  });

  @override
  State<ProductionQualityControlDataWidget> createState() =>
      _ProductionQualityControlDataWidgetState();
}

class _ProductionQualityControlDataWidgetState
    extends State<ProductionQualityControlDataWidget> {
  List<String>? groups;

  // Boolean check values
  bool? qcRawCheck = false;
  bool? qcManufacturingCheck = false;
  bool? qcLabCheck = false;
  bool? qcEmptyCheck = false;
  bool? qcPackagingCheck = false;
  bool? qcFinishedCheck = false;
  bool? qcArchiveCheck = false;

  // Text controllers for notes
  final qcRawNotesController = TextEditingController();
  final qcManufacturingController = TextEditingController();
  final qcLabController = TextEditingController();
  final qcEmptyController = TextEditingController();
  final qcPackagingController = TextEditingController();
  final qcFinishedController = TextEditingController();

  // Mark controllers for each section
  final List<TextEditingController> rawMarkControllers =
      List.generate(6, (index) => TextEditingController());
  final List<TextEditingController> manufacturingMarkControllers =
      List.generate(6, (index) => TextEditingController());
  final List<TextEditingController> labMarkControllers =
      List.generate(6, (index) => TextEditingController());
  final List<TextEditingController> emptyPackagingMarkControllers =
      List.generate(6, (index) => TextEditingController());
  final List<TextEditingController> packagingMarkControllers =
      List.generate(6, (index) => TextEditingController());
  final List<TextEditingController> finishedGoodsMarkControllers =
      List.generate(6, (index) => TextEditingController());

  final QualityControlModel _qualityControlModel = QualityControlModel();

  // Map to store calculated percentage for each section title (now storing double)
  Map<String, double> _sectionRawPercentages = {};

  // Mark labels for each criterion
  final List<String> markLabels = [
    'مطابقة المواد',
    'سلامة وجودة العبوات',
    'الدقة في الوزن',
    'هدر في المواد',
    'استلام وتسليم',
    'طريقة العمل',
  ];

  // Map linking section titles to their controller lists
  late final Map<String, List<TextEditingController>> _sectionControllers;

  @override
  void initState() {
    super.initState();
    _sectionControllers = {
      'قسم الأولية': rawMarkControllers,
      'قسم التصنيع': manufacturingMarkControllers,
      'قسم المخبر': labMarkControllers,
      'قسم الفوارغ': emptyPackagingMarkControllers,
      'قسم التعبئة': packagingMarkControllers,
      'قسم الجاهزة': finishedGoodsMarkControllers,
    };
    _initializeDataFromQualityControl();
    // Calculate initial percentages
    _calculateSectionPercentages();
  }

  // New utility function to map 0-100% to Red-to-Green color
  Color _getPercentageColor(double percentage) {
    // Clamp the percentage between 0 and 100
    final clampedPercentage = percentage.clamp(0.0, 100.0);

    // Hue ranges from Red (0) to Green (120) in HSV/HSL space.
    // We map 0% (Red) to 0 and 100% (Green) to 120.
    final hue = clampedPercentage * 1.2; // 100 * 1.2 = 120

    // Create the color using HSV (Hue, Saturation=1.0, Value=0.8)
    return HSLColor.fromAHSL(1.0, hue, 1.0, 0.45)
        .toColor(); // Darkened color slightly for better visibility
  }

  void _calculateSectionPercentages() {
    Map<String, double> newPercentages = {};
    const maxMarkPerCriterion = 10;
    const criteriaCount = 6; // Mark labels count
    const maxPossibleScore = maxMarkPerCriterion * criteriaCount;

    _sectionControllers.forEach((title, controllers) {
      int totalScore = 0;
      int filledCriteriaCount = 0;

      for (var controller in controllers) {
        final value = int.tryParse(controller.text.trim());
        if (value != null) {
          // Total score is calculated based on clamped values
          totalScore += value.clamp(0, maxMarkPerCriterion);
          filledCriteriaCount++;
        }
      }

      double percentage = 0.0;
      if (filledCriteriaCount > 0) {
        // Calculate percentage based on actual filled criteria
        percentage =
            (totalScore / (filledCriteriaCount * maxMarkPerCriterion)) * 100;
      }

      newPercentages[title] = percentage;
    });

    // Only update state if the widget is mounted
    if (mounted) {
      setState(() {
        _sectionRawPercentages = newPercentages;
      });
    }
  }

  // Calculate overall average percentage of all sections
  double _calculateOverallAverage() {
    if (_sectionRawPercentages.isEmpty) return 0.0;

    double totalPercentage = 0.0;
    int sectionsWithData = 0;

    _sectionRawPercentages.forEach((section, percentage) {
      if (percentage > 0) {
        // Only count sections that have data
        totalPercentage += percentage;
        sectionsWithData++;
      }
    });

    return sectionsWithData > 0 ? totalPercentage / sectionsWithData : 0.0;
  }

  void _initializeDataFromQualityControl() {
    final qualityControl = widget.fullProductionModel.qualityControl;

    // Initialize boolean values
    qcRawCheck = qualityControl.qc_raw_check ?? false;
    qcManufacturingCheck = qualityControl.qc_manufacturing_check ?? false;
    qcLabCheck = qualityControl.qc_lab_check ?? false;
    qcEmptyCheck = qualityControl.qc_empty_check ?? false;
    qcPackagingCheck = qualityControl.qc_packaging_check ?? false;
    qcFinishedCheck = qualityControl.qc_finished_check ?? false;
    qcArchiveCheck = qualityControl.qc_archive_ready ?? false;

    // Initialize text controllers for notes
    qcRawNotesController.text = qualityControl.qc_raw_notes ?? '';
    qcManufacturingController.text =
        qualityControl.qc_manufacturing_notes ?? '';
    qcLabController.text = qualityControl.qc_lab_notes ?? '';
    qcEmptyController.text = qualityControl.qc_empty_notes ?? '';
    qcPackagingController.text = qualityControl.qc_packaging_notes ?? '';
    qcFinishedController.text = qualityControl.qc_finished_notes ?? '';

    // Initialize mark controllers
    _initializeMarkControllers(rawMarkControllers, [
      qualityControl.raw_mark_1,
      qualityControl.raw_mark_2,
      qualityControl.raw_mark_3,
      qualityControl.raw_mark_4,
      qualityControl.raw_mark_5,
      qualityControl.raw_mark_6,
    ]);

    _initializeMarkControllers(manufacturingMarkControllers, [
      qualityControl.manufacturing_mark_1,
      qualityControl.manufacturing_mark_2,
      qualityControl.manufacturing_mark_3,
      qualityControl.manufacturing_mark_4,
      qualityControl.manufacturing_mark_5,
      qualityControl.manufacturing_mark_6,
    ]);

    _initializeMarkControllers(labMarkControllers, [
      qualityControl.lab_mark_1,
      qualityControl.lab_mark_2,
      qualityControl.lab_mark_3,
      qualityControl.lab_mark_4,
      qualityControl.lab_mark_5,
      qualityControl.lab_mark_6,
    ]);

    _initializeMarkControllers(emptyPackagingMarkControllers, [
      qualityControl.empty_packaging_mark_1,
      qualityControl.empty_packaging_mark_2,
      qualityControl.empty_packaging_mark_3,
      qualityControl.empty_packaging_mark_4,
      qualityControl.empty_packaging_mark_5,
      qualityControl.empty_packaging_mark_6,
    ]);

    _initializeMarkControllers(packagingMarkControllers, [
      qualityControl.packaging_mark_1,
      qualityControl.packaging_mark_2,
      qualityControl.packaging_mark_3,
      qualityControl.packaging_mark_4,
      qualityControl.packaging_mark_5,
      qualityControl.packaging_mark_6,
    ]);

    _initializeMarkControllers(finishedGoodsMarkControllers, [
      qualityControl.finished_goods_mark_1,
      qualityControl.finished_goods_mark_2,
      qualityControl.finished_goods_mark_3,
      qualityControl.finished_goods_mark_4,
      qualityControl.finished_goods_mark_5,
      qualityControl.finished_goods_mark_6,
    ]);
  }

  void _initializeMarkControllers(
      List<TextEditingController> controllers, List<int?> marks) {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].text = marks[i]?.toString() ?? '';
      // Add listener to recalculate percentage whenever a mark changes
      // This is crucial for real-time percentage update
      controllers[i].addListener(_calculateSectionPercentages);
    }
  }

  bool _validateMarks() {
    for (var entry in _sectionControllers.entries) {
      for (var controller in entry.value) {
        final text = controller.text.trim();
        if (text.isNotEmpty) {
          final value = int.tryParse(text);
          if (value == null || value < 0 || value > 10) {
            showSnackBar(
              context: context,
              content:
                  'يجب أن تكون علامات ${entry.key} بين 0 و 10 أو أن تكون فارغة.',
              failure: true,
            );
            return false;
          }
        }
      }
    }
    return true;
  }

  void _fillModelFromForm() {
    _qualityControlModel.id = widget.fullProductionModel.qualityControl.id;
    _qualityControlModel.qc_raw_check = qcRawCheck;
    _qualityControlModel.qc_manufacturing_check = qcManufacturingCheck;
    _qualityControlModel.qc_lab_check = qcLabCheck;
    _qualityControlModel.qc_empty_check = qcEmptyCheck;
    _qualityControlModel.qc_packaging_check = qcPackagingCheck;
    _qualityControlModel.qc_finished_check = qcFinishedCheck;
    _qualityControlModel.qc_archive_ready = qcArchiveCheck;
    _qualityControlModel.qc_raw_notes = qcRawNotesController.text;
    _qualityControlModel.qc_manufacturing_notes =
        qcManufacturingController.text;
    _qualityControlModel.qc_lab_notes = qcLabController.text;
    _qualityControlModel.qc_empty_notes = qcEmptyController.text;
    _qualityControlModel.qc_packaging_notes = qcPackagingController.text;
    _qualityControlModel.qc_finished_notes = qcFinishedController.text;

    // Fill marks from controllers
    _fillMarksFromControllers(rawMarkControllers, [
      (value) => _qualityControlModel.raw_mark_1 = value,
      (value) => _qualityControlModel.raw_mark_2 = value,
      (value) => _qualityControlModel.raw_mark_3 = value,
      (value) => _qualityControlModel.raw_mark_4 = value,
      (value) => _qualityControlModel.raw_mark_5 = value,
      (value) => _qualityControlModel.raw_mark_6 = value,
    ]);

    _fillMarksFromControllers(manufacturingMarkControllers, [
      (value) => _qualityControlModel.manufacturing_mark_1 = value,
      (value) => _qualityControlModel.manufacturing_mark_2 = value,
      (value) => _qualityControlModel.manufacturing_mark_3 = value,
      (value) => _qualityControlModel.manufacturing_mark_4 = value,
      (value) => _qualityControlModel.manufacturing_mark_5 = value,
      (value) => _qualityControlModel.manufacturing_mark_6 = value,
    ]);

    _fillMarksFromControllers(labMarkControllers, [
      (value) => _qualityControlModel.lab_mark_1 = value,
      (value) => _qualityControlModel.lab_mark_2 = value,
      (value) => _qualityControlModel.lab_mark_3 = value,
      (value) => _qualityControlModel.lab_mark_4 = value,
      (value) => _qualityControlModel.lab_mark_5 = value,
      (value) => _qualityControlModel.lab_mark_6 = value,
    ]);

    _fillMarksFromControllers(emptyPackagingMarkControllers, [
      (value) => _qualityControlModel.empty_packaging_mark_1 = value,
      (value) => _qualityControlModel.empty_packaging_mark_2 = value,
      (value) => _qualityControlModel.empty_packaging_mark_3 = value,
      (value) => _qualityControlModel.empty_packaging_mark_4 = value,
      (value) => _qualityControlModel.empty_packaging_mark_5 = value,
      (value) => _qualityControlModel.empty_packaging_mark_6 = value,
    ]);

    _fillMarksFromControllers(packagingMarkControllers, [
      (value) => _qualityControlModel.packaging_mark_1 = value,
      (value) => _qualityControlModel.packaging_mark_2 = value,
      (value) => _qualityControlModel.packaging_mark_3 = value,
      (value) => _qualityControlModel.packaging_mark_4 = value,
      (value) => _qualityControlModel.packaging_mark_5 = value,
      (value) => _qualityControlModel.packaging_mark_6 = value,
    ]);

    _fillMarksFromControllers(finishedGoodsMarkControllers, [
      (value) => _qualityControlModel.finished_goods_mark_1 = value,
      (value) => _qualityControlModel.finished_goods_mark_2 = value,
      (value) => _qualityControlModel.finished_goods_mark_3 = value,
      (value) => _qualityControlModel.finished_goods_mark_4 = value,
      (value) => _qualityControlModel.finished_goods_mark_5 = value,
      (value) => _qualityControlModel.finished_goods_mark_6 = value,
    ]);
  }

  void _fillMarksFromControllers(
    List<TextEditingController> controllers,
    List<Function(int?)> setters,
  ) {
    for (int i = 0; i < controllers.length; i++) {
      final text = controllers[i].text.trim();
      final value = text.isEmpty ? null : int.tryParse(text);
      // Ensure the saved value is clamped between 0 and 10 if it exists
      setters[i](value == null ? null : value.clamp(0, 10));
    }
  }

  @override
  void dispose() {
    // Remove listeners before disposing
    _sectionControllers.values.expand((list) => list).forEach((controller) {
      controller.removeListener(_calculateSectionPercentages);
      controller.dispose();
    });

    // Clean up all notes controllers
    qcRawNotesController.dispose();
    qcManufacturingController.dispose();
    qcLabController.dispose();
    qcEmptyController.dispose();
    qcPackagingController.dispose();
    qcFinishedController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppUserState userState = context.watch<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      groups = userState.userEntity.groups;
    }

    return BlocProvider(
      create: (context) => ProductionBloc(ProductionServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(builder: (context) {
        // Use BlocConsumer to handle both listening (side effects) and building (UI)
        return BlocConsumer<ProductionBloc, ProductionState>(
          listener: (context, state) {
            // This is where you catch emitted states (Success/Error)
            print(
                'ProductionBloc State received: $state'); // Will print for emitted states

            if (state is ProductionSuccess) {
              showSnackBar(
                context: context,
                content: 'تم الحفظ بنجاح',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ProductionList(type: 'Production'),
                ),
              );
            }
            if (state is ProductionError) {
              showSnackBar(
                context: context,
                content:
                    'حدث خطأ ما: ${state.errorMessage}', // Added message for clarity
                failure: true,
              );
            }
          },
          builder: (context, state) {
            // Log the initial state here (when the builder runs the first time)
            if (state is ProductionInitial) {
              print('ProductionBloc Initial State captured: $state');
            }

            // Calculate overall average
            final overallAverage = _calculateOverallAverage();
            final overallAverageColor = _getPercentageColor(overallAverage);

            return Padding(
              padding: const EdgeInsets.all(16.0), // Increased overall padding
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  // Constrain width for desktop
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          '🏭 معلومات قسم ضبط الجودة',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 30),
                        _buildQualityControlForm(context, overallAverage,
                            overallAverageColor), // Pass context for responsiveness
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // --- UI/UX IMPROVED FUNCTIONS ---

  Widget _buildQualityControlForm(
      BuildContext context, double overallAverage, Color overallAverageColor) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900; // Define a breakpoint

    if (isDesktop) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkboxes and Notes on the left/right side
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildCheckboxesSection(),
                    const SizedBox(height: 15),
                    _buildNotesSection(),
                  ],
                ),
              ),
              const SizedBox(width: 20), // Separator
              // Marks Section on the right/left side
              Expanded(
                flex: 2, // Marks section takes more horizontal space
                child: _buildMarksSection(
                    isDesktop: true,
                    overallAverage: overallAverage,
                    overallAverageColor: overallAverageColor),
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Save Button centered
          _buildSaveButton(),
        ],
      );
    } else {
      // Mobile Layout (original structure)
      return Column(
        children: [
          _buildCheckboxesSection(),
          const SizedBox(height: 15),
          _buildMarksSection(
              overallAverage: overallAverage,
              overallAverageColor: overallAverageColor),
          const SizedBox(height: 15),
          _buildNotesSection(),
          const SizedBox(height: 25),
          _buildSaveButton(),
        ],
      );
    }
  }

  Widget _buildCheckboxesSection() {
    if (widget.type != 'Production') return const SizedBox.shrink();

    return Card(
      elevation: 3, // Slightly higher elevation for better separation
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✅ التشييكات والمراحل المنجزة',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent), // Added color/icon
            ),
            const Divider(height: 20),
            // Use Wrap for desktop to save vertical space
            Wrap(
              spacing: 16.0, // horizontal spacing
              runSpacing: 8.0, // vertical spacing
              alignment: WrapAlignment.start,
              children: [
                _buildSwitchTile('تشييك في الأولية', qcRawCheck, (value) {
                  setState(() => qcRawCheck = value);
                }, isListTile: false), // Use compact switch
                _buildSwitchTile('تشييك في التصنيع', qcManufacturingCheck,
                    (value) {
                  setState(() => qcManufacturingCheck = value);
                }, isListTile: false),
                _buildSwitchTile('تشييك في المخبر', qcLabCheck, (value) {
                  setState(() => qcLabCheck = value);
                }, isListTile: false),
                _buildSwitchTile('تشييك في الفوارغ', qcEmptyCheck, (value) {
                  setState(() => qcEmptyCheck = value);
                }, isListTile: false),
                _buildSwitchTile('تشييك في التعبئة', qcPackagingCheck, (value) {
                  setState(() => qcPackagingCheck = value);
                }, isListTile: false),
                _buildSwitchTile('تشييك في الجاهزة', qcFinishedCheck, (value) {
                  setState(() => qcFinishedCheck = value);
                }, isListTile: false),
                _buildSwitchTile('المعلومات جاهزة للأرشفة', qcArchiveCheck,
                    (value) {
                  setState(() => qcArchiveCheck = value);
                }, isListTile: false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool? value, Function(bool) onChanged,
      {bool isListTile = true}) {
    if (isListTile) {
      return SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 15)),
        value: value ?? false,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        dense: true,
        activeColor: Colors.green, // Visual feedback for active state
      );
    } else {
      // Compact version for desktop (Wrap)
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: value ?? false,
            onChanged: onChanged,
            activeColor: Colors.green,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      );
    }
  }

  Widget _buildMarksSection(
      {bool isDesktop = false,
      required double overallAverage,
      required Color overallAverageColor}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and overall average
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '⭐ التقييمات',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
                // Overall Average Display
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: overallAverageColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border:
                        Border.all(color: overallAverageColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.assessment,
                        color: overallAverageColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${overallAverage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: overallAverageColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            // Use _sectionControllers map to build the tiles
            ..._sectionControllers.entries.map((entry) {
              return _buildMarksExpansionTile(
                entry.key, // Title
                entry.value, // Controllers list
                isDesktop: isDesktop,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMarksExpansionTile(
    String title,
    List<TextEditingController> controllers, {
    bool isDesktop = false,
  }) {
    // Get the calculated raw percentage for this specific section
    final rawPercentage = _sectionRawPercentages[title] ?? 0.0;

    // Determine the color based on the percentage
    final percentageColor = _getPercentageColor(rawPercentage);

    // Format the percentage for display
    final percentageDisplay = rawPercentage.toStringAsFixed(2);

    return ExpansionTile(
      iconColor: Colors.blueGrey,
      collapsedIconColor: Colors.grey,
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: percentageColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: percentageColor.withOpacity(0.3)),
                ),
                child: Text(
                  '$percentageDisplay %',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: percentageColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : 2, // 3 columns for desktop
              crossAxisSpacing: 20,
              mainAxisSpacing: 15,
              childAspectRatio: isDesktop ? 2.8 : 2.1,
            ),
            itemCount: markLabels.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    markLabels[index],
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 40, // Reduced height for desktop
                    child: TextField(
                      controller: controllers[index],
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        // Validate and correct input immediately (UI UX)
                        final value = int.tryParse(text);
                        if (value != null) {
                          if (value > 10) {
                            controllers[index].text = '10';
                          } else if (value < 0) {
                            controllers[index].text = '0';
                          }
                          // Keep cursor at the end after changing text
                          controllers[index].selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: controllers[index].text.length));
                        }
                        // Recalculation handled by listener added in initState
                      },
                      decoration: const InputDecoration(
                        hintText: 'الدرجة (0-10)', // Added hint
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.8),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        isDense: true,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📝 الملاحظات والتفاصيل الإضافية',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
            const Divider(height: 20),
            _buildNoteField(qcRawNotesController, 'ملاحظة قسم الأولية'),
            _buildNoteField(qcManufacturingController, 'ملاحظة قسم التصنيع'),
            _buildNoteField(qcLabController, 'ملاحظة قسم المخبر'),
            _buildNoteField(qcEmptyController, 'ملاحظة قسم الفوارغ'),
            _buildNoteField(qcPackagingController, 'ملاحظة قسم التعبئة'),
            _buildNoteField(qcFinishedController, 'ملاحظة قسم الجاهزة'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: MyTextField(
        controller: controller,
        labelText: labelText,
        maxLines: 3,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget _buildSaveButton() {
    if (groups != null &&
        (groups!.contains('admins') ||
            groups!.contains('quality_control_dep')) &&
        widget.type == 'Production') {
      return Builder(
        builder: (context) {
          return Mybutton(
            text: 'حفظ',
            onPressed: () {
              if (!_validateMarks()) {
                return;
              }
              _fillModelFromForm();
              // Now this context has access to the ProductionBloc
              context.read<ProductionBloc>().add(
                    SaveQualityControl(
                        qualityControlModel: _qualityControlModel),
                  );
            },
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}
