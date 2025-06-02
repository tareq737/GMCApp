// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/empty_packaging_model.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_full_data_page.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_list.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class ProductionEmptyPackagingDataWidget extends StatefulWidget {
  final FullProductionModel fullProductionModel;
  final String type;
  const ProductionEmptyPackagingDataWidget(
      {super.key, required this.fullProductionModel, required this.type});

  @override
  State<ProductionEmptyPackagingDataWidget> createState() =>
      _ProductionEmptyPackagingDataWidgetState();
}

class _ProductionEmptyPackagingDataWidgetState
    extends State<ProductionEmptyPackagingDataWidget> {
  List<String>? groups;
  final startTimeController = TextEditingController();
  final finishTimeController = TextEditingController();
  String durationText = '';
  final completionDateController = TextEditingController();
  bool? emptyPackagingCheck_1 = false;
  bool? emptyPackagingCheck_2 = false;
  bool? emptyPackagingCheck_3 = false;
  bool? emptyPackagingCheck_4 = false;
  bool? emptyPackagingCheck_5 = false;
  final employeeController = TextEditingController();
  final notesController = TextEditingController();
  final problemsController = TextEditingController();
  final EmptyPackagingModel _emptyPackagingModel = EmptyPackagingModel();
  void _fillEmptyPackagingModelFromFomr() {
    _emptyPackagingModel.id = widget.fullProductionModel.emptyPackaging.id;
    _emptyPackagingModel.empty_packaging_check_1 = emptyPackagingCheck_1;
    _emptyPackagingModel.empty_packaging_check_2 = emptyPackagingCheck_2;
    _emptyPackagingModel.empty_packaging_check_3 = emptyPackagingCheck_3;
    _emptyPackagingModel.empty_packaging_check_4 = emptyPackagingCheck_4;
    _emptyPackagingModel.empty_packaging_check_5 = emptyPackagingCheck_5;
    _emptyPackagingModel.employee = employeeController.text;
    _emptyPackagingModel.notes = notesController.text;
    _emptyPackagingModel.problems = problemsController.text;

    _emptyPackagingModel.start_time =
        startTimeController.text.isEmpty ? null : startTimeController.text;
    _emptyPackagingModel.finish_time =
        finishTimeController.text.isEmpty ? null : finishTimeController.text;
    _emptyPackagingModel.completion_date = completionDateController.text.isEmpty
        ? null
        : completionDateController.text;
  }

  @override
  void initState() {
    super.initState();
    emptyPackagingCheck_1 =
        widget.fullProductionModel.emptyPackaging.empty_packaging_check_1;
    emptyPackagingCheck_2 =
        widget.fullProductionModel.emptyPackaging.empty_packaging_check_2;
    emptyPackagingCheck_3 =
        widget.fullProductionModel.emptyPackaging.empty_packaging_check_3;
    emptyPackagingCheck_4 =
        widget.fullProductionModel.emptyPackaging.empty_packaging_check_4;
    emptyPackagingCheck_5 =
        widget.fullProductionModel.emptyPackaging.empty_packaging_check_5;
    employeeController.text =
        widget.fullProductionModel.emptyPackaging.employee ?? '';
    notesController.text =
        widget.fullProductionModel.emptyPackaging.notes ?? '';
    problemsController.text =
        widget.fullProductionModel.emptyPackaging.problems ?? '';

    startTimeController.text =
        widget.fullProductionModel.emptyPackaging.start_time ?? '';
    finishTimeController.text =
        widget.fullProductionModel.emptyPackaging.finish_time ?? '';
    completionDateController.text =
        widget.fullProductionModel.emptyPackaging.completion_date ?? '';
    if (startTimeController.text.isNotEmpty) {
      DateTime parsedTime = DateFormat('HH:mm').parse(startTimeController.text);
      String formattedTime = DateFormat('hh:mm').format(parsedTime);
      startTimeController.text = formattedTime;
    }
    if (finishTimeController.text.isNotEmpty) {
      DateTime parsedTime =
          DateFormat('HH:mm').parse(finishTimeController.text);
      String formattedTime = DateFormat('hh:mm').format(parsedTime);
      finishTimeController.text = formattedTime;
    }

    _calculateDuration();
  }

  @override
  Widget build(BuildContext context) {
    AppUserState state = context.watch<AppUserCubit>().state;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    return BlocProvider(
      create: (context) => ProductionBloc(
        ProductionServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      ),
      child: Builder(builder: (context) {
        return BlocListener<ProductionBloc, ProductionState>(
          listener: (context, state) {
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
                  builder: (
                    context,
                  ) {
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'معلومات قسم الفوارغ',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (widget.type == 'Production') ...[
                      CheckboxListTile(
                        title: const Text(
                          'جرد الفوارغ',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: emptyPackagingCheck_1,
                        onChanged: (bool? value) {
                          setState(() {
                            emptyPackagingCheck_1 = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'طبعت اللواصق',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: emptyPackagingCheck_2,
                        onChanged: (bool? value) {
                          setState(() {
                            emptyPackagingCheck_2 = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'لزقت الفوارغ',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: emptyPackagingCheck_3,
                        onChanged: (bool? value) {
                          setState(() {
                            emptyPackagingCheck_3 = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'طبعت لواصق الكراتين ',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: emptyPackagingCheck_4,
                        onChanged: (bool? value) {
                          setState(() {
                            emptyPackagingCheck_4 = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        title: const Text(
                          'المعلومات جاهزة للأرشفة',
                          style: TextStyle(fontSize: 12),
                        ),
                        value: emptyPackagingCheck_5,
                        onChanged: (bool? value) {
                          setState(() {
                            emptyPackagingCheck_5 = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ],
                    MyTextField(
                        controller: employeeController,
                        labelText: 'موظف الفوارغ'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: startTimeController,
                            labelText: 'وقت بدء الفوارغ',
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                final now = DateTime.now();
                                final formattedTime =
                                    DateFormat('HH:mm').format(
                                  DateTime(now.year, now.month, now.day,
                                      pickedTime.hour, pickedTime.minute),
                                );
                                startTimeController.text = formattedTime;
                                _calculateDuration();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: MyTextField(
                            controller: finishTimeController,
                            labelText: 'وقت انتهاء الفوارغ',
                            readOnly: true,
                            onTap: () async {
                              TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime != null) {
                                final now = DateTime.now();
                                final formattedTime =
                                    DateFormat('HH:mm').format(
                                  DateTime(now.year, now.month, now.day,
                                      pickedTime.hour, pickedTime.minute),
                                );
                                finishTimeController.text = formattedTime;
                                _calculateDuration();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'مدة العمل: $durationText',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      readOnly: true,
                      controller: completionDateController,
                      labelText: 'تاريخ انتهاء الفوارغ',
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            completionDateController.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: notesController,
                        labelText: 'ملاحظات الفوارغ'),
                    const SizedBox(
                      height: 10,
                    ),
                    MyTextField(
                        controller: problemsController,
                        labelText: 'مشاكل الفوارغ'),
                    if ((groups!.contains('admins') ||
                            groups!.contains('emptyPackaging_dep')) &&
                        widget.type == 'Production')
                      Mybutton(
                        text: 'حفظ',
                        onPressed: () {
                          _fillEmptyPackagingModelFromFomr();
                          print(_emptyPackagingModel);
                          context.read<ProductionBloc>().add(SaveEmptyPackaging(
                              emptyPackagingModel: _emptyPackagingModel));
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _calculateDuration() {
    if (startTimeController.text.isNotEmpty &&
        finishTimeController.text.isNotEmpty) {
      final format = DateFormat('HH:mm');

      final DateTime startTime = format.parse(startTimeController.text);
      final DateTime finishTime = format.parse(finishTimeController.text);

      final Duration duration = finishTime.difference(startTime);

      if (duration.isNegative) {
        final nextDayFinishTime = finishTime.add(const Duration(days: 1));
        final Duration nextDayDuration =
            nextDayFinishTime.difference(startTime);
        setState(() {
          durationText = _formatDuration(nextDayDuration);
        });
      } else {
        setState(() {
          durationText = _formatDuration(duration);
        });
      }
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
