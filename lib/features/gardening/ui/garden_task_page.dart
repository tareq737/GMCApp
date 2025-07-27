// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_dropdown_button_widget.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/gardening/bloc/gardening_bloc.dart';
import 'package:gmcappclean/features/gardening/models/garden_activities_model.dart';

import 'package:gmcappclean/features/gardening/models/garden_tasks_model.dart';
import 'package:gmcappclean/features/gardening/services/gardening_services.dart';
import 'package:gmcappclean/features/gardening/ui/list_garden_tasks_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class GardenTaskPage extends StatelessWidget {
  final GardenTasksModel? gardenTasksModel;
  const GardenTaskPage({
    super.key,
    this.gardenTasksModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GardeningBloc(GardeningServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      ))
        ..add(GetAllGardenActivities()),
      child: GardenTaskChild(gardenTasksModel: gardenTasksModel),
    );
  }
}

class GardenTaskChild extends StatefulWidget {
  final GardenTasksModel? gardenTasksModel;

  const GardenTaskChild({super.key, this.gardenTasksModel});

  @override
  State<GardenTaskChild> createState() => _GardenTaskChildState();
}

class _GardenTaskChildState extends State<GardenTaskChild> {
  String? selectedActivity;
  String? selectedDetail;
  List<String> activities = [];
  List<String> details = [];
  List<GardenActivitiesModel> gardenActivityDetails = [];
  final TextEditingController dateController = TextEditingController();
  final TextEditingController fromTimeController = TextEditingController();
  final TextEditingController toTimeController = TextEditingController();
  final TextEditingController workerController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String totalTime = '';
  List<String> workers = [];
  String? selectedWorker;
  bool _done = false;
  void calculateTotalTime() {
    try {
      final from = TimeOfDay(
        hour: int.parse(fromTimeController.text.split(':')[0]),
        minute: int.parse(fromTimeController.text.split(':')[1]),
      );
      final to = TimeOfDay(
        hour: int.parse(toTimeController.text.split(':')[0]),
        minute: int.parse(toTimeController.text.split(':')[1]),
      );

      final fromMinutes = from.hour * 60 + from.minute;
      final toMinutes = to.hour * 60 + to.minute;
      final diff = toMinutes - fromMinutes;

      if (diff >= 0) {
        final hours = (diff ~/ 60).toString().padLeft(2, '0');
        final minutes = (diff % 60).toString().padLeft(2, '0');
        setState(() {
          totalTime = '$hours:$minutes';
        });
      } else {
        setState(() {
          totalTime = 'الوقت غير صحيح';
        });
      }
    } catch (e) {
      setState(() {
        totalTime = 'صيغة وقت غير صالحة';
      });
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hour.toString().padLeft(2, '0');
    final minute = tod.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void initState() {
    super.initState();

    // Fetch workers list
    context
        .read<GardeningBloc>()
        .add(GetAllGardeningWorkers(department: 'قسم الزراعة'));

    final model = widget.gardenTasksModel;

    if (model != null) {
      // Populate initial field values
      selectedActivity = model.activity!.name;
      selectedDetail = model.activity!.details;
      dateController.text = model.date ?? '';
      final timeFormat = DateFormat('HH:mm');
      if (model.done == true) {
        _done = true;
      } else {
        _done = false;
      }
// Reformat time_from
      if (model.time_from != null && model.time_from!.isNotEmpty) {
        try {
          final parsedFrom = DateFormat('HH:mm').parse(model.time_from!);
          fromTimeController.text = timeFormat.format(parsedFrom);
        } catch (_) {
          fromTimeController.text = model.time_from!;
        }
      }

// Reformat time_to
      if (model.time_to != null && model.time_to!.isNotEmpty) {
        try {
          final parsedTo = DateFormat('HH:mm').parse(model.time_to!);
          toTimeController.text = timeFormat.format(parsedTo);
        } catch (_) {
          toTimeController.text = model.time_to!;
        }
      }
      selectedWorker = model.worker_name;
      notesController.text = model.notes ?? '';

      // Compute total time if from/to time are provided
      if (model.time_from != null && model.time_to != null) {
        calculateTotalTime();
      }

      // If name is set, fetch details for it
      if (model.activity!.name != null) {
        context
            .read<GardeningBloc>()
            .add(GetAllGardenActivitiesDetails(name: model.activity!.name!));
      }
    }

    // You can also prefetch all activities if needed
    context.read<GardeningBloc>().add(GetAllGardenActivities());
  }

  @override
  void dispose() {
    dateController.dispose();
    fromTimeController.dispose();
    toTimeController.dispose();
    workerController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.gardenTasksModel == null
              ? 'إضافة مهمة زراعة'
              : 'تعديل مهمة زراعة'),
        ),
        body: BlocConsumer<GardeningBloc, GardeningState>(
          listener: (context, state) {
            print(state);
            if (state is GardeningError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
            } else if (state is GardeningSuccess<List>) {
              final resultList = state.result;

              // Detect if the result is a list of activity names or details
              if (resultList.isNotEmpty && resultList.first is String) {
                // List of activity names
                setState(() {
                  activities =
                      List<String>.from(resultList.map((e) => e.toString()));
                });
              } else if (resultList.isNotEmpty &&
                  resultList.first is GardenActivitiesModel) {
                setState(() {
                  gardenActivityDetails =
                      List<GardenActivitiesModel>.from(resultList);

                  details = gardenActivityDetails
                      .map((e) => e.details!.trim())
                      .toList();

                  // Set selectedDetail if editing existing task
                  if (widget.gardenTasksModel != null &&
                      widget.gardenTasksModel!.activity!.details != null &&
                      details.contains(
                          widget.gardenTasksModel!.activity!.details!.trim())) {
                    selectedDetail =
                        widget.gardenTasksModel!.activity!.details!.trim();
                  } else {
                    selectedDetail = null;
                  }
                });
              }
            } else if (state is GetWorkerSuccess<List>) {
              final resultList = state.result;

              // Detect if the result is a list of activity names or details
              if (resultList.isNotEmpty && resultList.first is String) {
                // List of activity names
                setState(() {
                  workers =
                      List<String>.from(resultList.map((e) => e.toString()));
                });
              }
            } else if (state is GardeningSuccess<GardenTasksModel>) {
              showSnackBar(
                context: context,
                content: 'تم بنجاح',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListGardenTasksPage(),
                ),
              );
            }
          },
          builder: (context, state) {
            final bool isLoading = state is GardeningLoading;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 20,
                  children: [
                    MyDropdownButton(
                      value: selectedActivity,
                      items: activities.map((activity) {
                        return DropdownMenuItem<String>(
                          value: activity,
                          child: Text(activity),
                        );
                      }).toList(),
                      labelText: 'العمل',
                      onChanged: (value) {
                        setState(() {
                          selectedActivity = value;
                          selectedDetail = null;
                          details = [];
                        });

                        // Only fire the detail event if value is not null
                        if (value != null) {
                          context.read<GardeningBloc>().add(
                                GetAllGardenActivitiesDetails(name: value),
                              );
                        }
                      },
                    ),
                    MyDropdownButton(
                      value: selectedDetail,
                      items: details.map((detail) {
                        return DropdownMenuItem<String>(
                          value: detail,
                          child: Text(detail),
                        );
                      }).toList(),
                      labelText: 'التفاصيل',
                      onChanged: (value) {
                        setState(() {
                          selectedDetail = value;
                        });
                      },
                    ),
                    MyTextField(
                      controller: dateController,
                      readOnly: true,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          dateController.text =
                              picked.toIso8601String().split('T').first;
                        }
                      },
                      labelText: 'تاريخ المهمة',
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: MyTextField(
                            controller: fromTimeController,
                            readOnly: true,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                fromTimeController.text =
                                    formatTimeOfDay(picked);
                                calculateTotalTime();
                              }
                            },
                            labelText: 'من الساعة',
                          ),
                        ),
                        Expanded(
                          child: MyTextField(
                            controller: toTimeController,
                            readOnly: true,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (picked != null) {
                                toTimeController.text = formatTimeOfDay(picked);
                                calculateTotalTime();
                              }
                            },
                            labelText: 'إلى الساعة',
                          ),
                        ),
                      ],
                    ),
                    if (totalTime.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'المدة الإجمالية: $totalTime',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    MyDropdownButton(
                      value: selectedWorker,
                      items: workers.map((worker) {
                        return DropdownMenuItem<String>(
                          value: worker,
                          child: Text(worker),
                        );
                      }).toList(),
                      labelText: 'اسم العامل',
                      onChanged: (value) {
                        setState(() {
                          selectedWorker = value;
                        });
                      },
                    ),
                    MyTextField(
                      controller: notesController,
                      maxLines: 3,
                      labelText: 'ملاحظات',
                    ),
                    CheckboxListTile(
                      value: _done,
                      onChanged: (bool? value) {
                        setState(() {
                          _done = value ?? false;
                        });
                      },
                      title: const Text('تم الإنجاز'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    isLoading
                        ? const Loader()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Mybutton(
                                text: 'إضافة',
                                onPressed: () {
                                  // Log all available activity details for debugging
                                  for (var e in gardenActivityDetails) {
                                    print(
                                        '🧪 Matching ${e.name?.trim()} / ${e.details?.trim()} '
                                        'against ${selectedActivity?.trim()} / ${selectedDetail?.trim()}');
                                  }

                                  final selectedActivityModel =
                                      gardenActivityDetails.firstWhere(
                                    (e) =>
                                        (e.name?.trim() ==
                                            selectedActivity?.trim()) &&
                                        (e.details?.trim() ==
                                            selectedDetail?.trim()),
                                    orElse: () => GardenActivitiesModel(
                                        id: null, name: null, details: null),
                                  );

                                  if (selectedActivityModel.id == null) {
                                    showSnackBar(
                                      context: context,
                                      content:
                                          'لا يمكن العثور على النشاط المختار. الرجاء التحقق من الحقول.',
                                      failure: true,
                                    );
                                    return;
                                  }

                                  final task = GardenTasksModel(
                                    activity_id: selectedActivityModel.id,
                                    activity: selectedActivityModel,
                                    date: dateController.text,
                                    time_from: fromTimeController.text,
                                    time_to: toTimeController.text,
                                    worker_name: selectedWorker,
                                    notes: notesController.text,
                                    done: _done,
                                  );

                                  print('✅ Adding Task Model: $task');

                                  context.read<GardeningBloc>().add(
                                      AddGardenTask(gardenTasksModel: task));
                                },
                              ),
                              if (widget.gardenTasksModel != null)
                                Mybutton(
                                  text: 'تعديل',
                                  onPressed: () {
                                    if (widget.gardenTasksModel == null) {
                                      showSnackBar(
                                        context: context,
                                        content: 'لا يوجد مهمة للتعديل',
                                        failure: true,
                                      );
                                      return;
                                    }

                                    // Log available entries for debugging
                                    for (var e in gardenActivityDetails) {
                                      print(
                                          '🧪 Matching ${e.name?.trim()} / ${e.details?.trim()} '
                                          'against ${selectedActivity?.trim()} / ${selectedDetail?.trim()}');
                                    }

                                    final selectedActivityModel =
                                        gardenActivityDetails.firstWhere(
                                      (e) =>
                                          (e.name?.trim() ==
                                              selectedActivity?.trim()) &&
                                          (e.details?.trim() ==
                                              selectedDetail?.trim()),
                                      orElse: () => GardenActivitiesModel(
                                          id: null, name: null, details: null),
                                    );

                                    if (selectedActivityModel.id == null) {
                                      showSnackBar(
                                        context: context,
                                        content:
                                            'لا يمكن العثور على النشاط المختار. الرجاء التحقق من الحقول.',
                                        failure: true,
                                      );
                                      return;
                                    }

                                    final task = GardenTasksModel(
                                      activity_id: selectedActivityModel.id,
                                      date: dateController.text,
                                      time_from: fromTimeController.text,
                                      time_to: toTimeController.text,
                                      worker_name: selectedWorker,
                                      notes: notesController.text,
                                      done: _done,
                                    );

                                    print('✅ Updating Task Model: $task');
                                    print(
                                        '🔗 Using activity model: $selectedActivityModel');

                                    context.read<GardeningBloc>().add(
                                          UpdateGardenTask(
                                            id: widget.gardenTasksModel!.id!,
                                            gardenTasksModel: task,
                                          ),
                                        );
                                  },
                                ),
                            ],
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
}
