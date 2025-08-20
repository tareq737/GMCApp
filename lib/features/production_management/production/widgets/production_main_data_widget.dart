import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_list.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ProductionMainDataWidget extends StatefulWidget {
  final FullProductionModel fullProductionModel;
  final String type;
  final Function(int)? moveToTab;
  const ProductionMainDataWidget(
      {super.key,
      required this.fullProductionModel,
      this.moveToTab,
      required this.type});

  @override
  State<ProductionMainDataWidget> createState() =>
      _ProductionMainDataWidgetState();
}

class _ProductionMainDataWidgetState extends State<ProductionMainDataWidget> {
  Widget _buildDetailsLayout(BuildContext context) {
    final items = [
      _buildDetailCard(
          context, "النوع", widget.fullProductionModel.productions.type!),
      _buildDetailCard(
          context, "المستوى", widget.fullProductionModel.productions.tier!),
      _buildDetailCard(
          context, "اللون", widget.fullProductionModel.productions.color!),
      _buildDetailCard(context, "الكثافة",
          widget.fullProductionModel.productions.density!.toStringAsFixed(3)),
      _buildDetailCard(context, "تاريخ الإدراج",
          widget.fullProductionModel.productions.insert_date!),
    ];

    if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      // On desktop → Row with wrap to prevent overflow
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: items,
      );
    } else {
      // On mobile → Grid
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        children: items,
      );
    }
  }

  List<String>? groups;

  List<Map<String, String>> _generateRows() {
    return List.generate(
      widget.fullProductionModel.packagingBreakdowns.length,
      (index) {
        var breakdown = widget.fullProductionModel.packagingBreakdowns[index];

        // Get density from the main production model, default to 1.0 to avoid division by zero
        final double density =
            widget.fullProductionModel.productions.density ?? 1.0;

        double? packageWeight = breakdown.package_weight;
        double? packageVolume = breakdown.package_volume;
        int quantity = breakdown.quantity ?? 0;

        // Calculate missing value if one is null or zero
        if ((packageVolume == null || packageVolume == 0) &&
            packageWeight != null &&
            packageWeight != 0 &&
            density != 0) {
          packageVolume = packageWeight / density;
        } else if ((packageWeight == null || packageWeight == 0) &&
            packageVolume != null &&
            packageVolume != 0 &&
            density != 0) {
          packageWeight = packageVolume * density;
        }

        // Calculate total weight and total size using the potentially calculated values
        double totalWeight = (packageWeight ?? 0) * quantity;
        double totalSize = (packageVolume ?? 0) * quantity;

        return {
          'الحجم':
              (packageVolume ?? 0).toStringAsFixed(2), // Format for display
          'الوزن':
              (packageWeight ?? 0).toStringAsFixed(2), // Format for display
          'العدد': quantity.toString(),
          'العبوة': breakdown.package_type?.toString() ?? '',
          'الصنف': breakdown.brand?.toString() ?? '',
          'مجموع الوزن': totalWeight.toStringAsFixed(2),
          'مجموع الحجم': totalSize.toStringAsFixed(2),
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> rows = _generateRows();
    double totalWeightSum = rows.fold(
        0, (sum, row) => sum + double.parse(row["مجموع الوزن"] ?? "0"));
    double totalSizeSum = rows.fold(
        0, (sum, row) => sum + double.parse(row["مجموع الحجم"] ?? "0"));

    AppUserState state = context.watch<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }

    return BlocProvider(
      create: (context) => ProductionBloc(ProductionServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(builder: (context) {
        return BlocListener<ProductionBloc, ProductionState>(
          listener: (context, state) {
            if (state is ProductionSuccess<String>) {
              showSnackBar(
                context: context,
                content: 'تم الأرشفة بنجاح',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ProductionList(
                      type: 'Production',
                    );
                  },
                ),
              );
            }
            if (state is ProductionError) {
              showSnackBar(
                context: context,
                content: 'حدث خطأ ما',
                failure: true,
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          _buildDetailsLayout(context),
                          const SizedBox(height: 16),
                          _buildNoteItem(
                              "ملاحظة معد البرنامج",
                              widget.fullProductionModel.productions
                                  .prepared_by_notes!),
                          const SizedBox(
                            height: 10,
                          ),
                          if (widget.type == 'Production') ...[
                            const Text('تشطيب الأقسام'),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    CheckSection(
                                      onTap: () {
                                        widget.moveToTab!(1);
                                      },
                                      title: 'الأولية',
                                      checks: [
                                        widget.fullProductionModel.rawMaterials
                                                .raw_material_check_1 ??
                                            false,
                                        widget.fullProductionModel.rawMaterials
                                                .raw_material_check_2 ??
                                            false,
                                        widget.fullProductionModel.rawMaterials
                                                .raw_material_check_3 ??
                                            false,
                                        widget.fullProductionModel.rawMaterials
                                                .raw_material_check_4 ??
                                            false,
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CheckSection(
                                      onTap: () {
                                        widget.moveToTab!(4);
                                      },
                                      title: 'الفوارغ',
                                      checks: [
                                        widget
                                                .fullProductionModel
                                                .emptyPackaging
                                                .empty_packaging_check_1 ??
                                            false,
                                        widget
                                                .fullProductionModel
                                                .emptyPackaging
                                                .empty_packaging_check_2 ??
                                            false,
                                        widget
                                                .fullProductionModel
                                                .emptyPackaging
                                                .empty_packaging_check_3 ??
                                            false,
                                        widget
                                                .fullProductionModel
                                                .emptyPackaging
                                                .empty_packaging_check_4 ??
                                            false,
                                        widget
                                                .fullProductionModel
                                                .emptyPackaging
                                                .empty_packaging_check_5 ??
                                            false,
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    CheckSection(
                                      onTap: () {
                                        widget.moveToTab!(2);
                                      },
                                      title: 'التصنيع',
                                      checks: [
                                        widget.fullProductionModel.manufacturing
                                                .manufacturing_check_1 ??
                                            false,
                                        widget.fullProductionModel.manufacturing
                                                .manufacturing_check_2 ??
                                            false,
                                        widget.fullProductionModel.manufacturing
                                                .manufacturing_check_3 ??
                                            false,
                                        widget.fullProductionModel.manufacturing
                                                .manufacturing_check_4 ??
                                            false,
                                        widget.fullProductionModel.manufacturing
                                                .manufacturing_check_5 ??
                                            false,
                                        widget.fullProductionModel.manufacturing
                                                .manufacturing_check_6 ??
                                            false,
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CheckSection(
                                      onTap: () {
                                        widget.moveToTab!(5);
                                      },
                                      title: 'التعبئة',
                                      checks: [
                                        widget.fullProductionModel.packaging
                                                .packaging_check_1 ??
                                            false,
                                        widget.fullProductionModel.packaging
                                                .packaging_check_2 ??
                                            false,
                                        widget.fullProductionModel.packaging
                                                .packaging_check_3 ??
                                            false,
                                        widget.fullProductionModel.packaging
                                                .packaging_check_4 ??
                                            false,
                                        widget.fullProductionModel.packaging
                                                .packaging_check_5 ??
                                            false,
                                        widget.fullProductionModel.packaging
                                                .packaging_check_6 ??
                                            false,
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    CheckSection(
                                      onTap: () {
                                        widget.moveToTab!(3);
                                      },
                                      title: 'المخبر',
                                      checks: [
                                        widget.fullProductionModel.lab
                                                .lab_check_1 ??
                                            false,
                                        widget.fullProductionModel.lab
                                                .lab_check_2 ??
                                            false,
                                        widget.fullProductionModel.lab
                                                .lab_check_3 ??
                                            false,
                                        widget.fullProductionModel.lab
                                                .lab_check_4 ??
                                            false,
                                        widget.fullProductionModel.lab
                                                .lab_check_5 ??
                                            false,
                                        widget.fullProductionModel.lab
                                                .lab_check_6 ??
                                            false,
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        CheckSection(
                                          onTap: () {
                                            widget.moveToTab!(6);
                                          },
                                          title: 'الجاهزة',
                                          checks: [
                                            widget
                                                    .fullProductionModel
                                                    .finishedGoods
                                                    .finished_goods_check_1 ??
                                                false,
                                            widget
                                                    .fullProductionModel
                                                    .finishedGoods
                                                    .finished_goods_check_2 ??
                                                false,
                                            widget
                                                    .fullProductionModel
                                                    .finishedGoods
                                                    .finished_goods_check_3 ??
                                                false,
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if ((groups!.contains('admins') ||
                          groups!.contains('production_managers')) &&
                      widget.type == 'Production')
                    Mybutton(
                      text: 'أرشفة',
                      onPressed: () {
                        context.read<ProductionBloc>().add(Archive(
                            id: widget.fullProductionModel.productions.id!));
                      },
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("مجموع الوزن: ${totalWeightSum.toStringAsFixed(2)}"),
                      Text("مجموع الحجم: ${totalSizeSum.toStringAsFixed(2)}"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: rows.asMap().entries.map((entry) {
                      Map<String, String> row = entry.value;
                      final theme = Theme.of(context);
                      final bool isDarkMode =
                          theme.brightness == Brightness.dark;

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 4),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDarkMode
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _thinItemRow(context, "الصنف: ", row["الصنف"]!),
                                const SizedBox(width: 12),
                                _thinItemRow(
                                    context, "العبوة: ", row["العبوة"]!),
                                const SizedBox(width: 12),
                                _thinItemRow(context, "العدد: ", row["العدد"]!),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _thinItemColumn(
                                    context, "الوزن", row["الوزن"]!),
                                _thinItemColumn(
                                    context, "الحجم", row["الحجم"]!),
                                _thinItemColumn(
                                  context,
                                  "مجموع الوزن",
                                  double.parse(row["مجموع الوزن"]!)
                                      .toStringAsFixed(2),
                                  isBold: true,
                                ),
                                _thinItemColumn(
                                  context,
                                  "مجموع الحجم",
                                  double.parse(row["مجموع الحجم"]!)
                                      .toStringAsFixed(2),
                                  isBold: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class CheckIconRow extends StatelessWidget {
  final List<bool> checks;

  const CheckIconRow({required this.checks, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: checks.map((check) {
        return Icon(
          check ? Icons.check : Icons.close,
          color: check ? Colors.green : Colors.red,
          size: 12,
        );
      }).toList(),
    );
  }
}

class CheckSection extends StatelessWidget {
  final String title;
  final List<bool> checks;
  final VoidCallback? onTap;

  const CheckSection(
      {required this.title, required this.checks, super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(height: 5),
          CheckIconRow(checks: checks),
        ],
      ),
    );
  }
}

Widget _buildDetailCard(BuildContext context, String title, String value) {
  return Card(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            textAlign: TextAlign.center,
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildNoteItem(String title, String note) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        note,
      ),
    ],
  );
}

Widget _thinItemRow(
  BuildContext context,
  String label,
  String value, {
  bool isBold = false,
}) {
  final theme = Theme.of(context);
  return Flexible(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

Widget _thinItemColumn(
  BuildContext context,
  String label,
  String value, {
  bool isBold = false,
}) {
  final theme = Theme.of(context);
  return Flexible(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
