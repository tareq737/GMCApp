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
import 'package:gmcappclean/features/gardening/services/gardening_services.dart';
import 'package:gmcappclean/init_dependencies.dart';

class AddGardenActivityPage extends StatefulWidget {
  const AddGardenActivityPage({super.key});

  @override
  State<AddGardenActivityPage> createState() => _AddGardenActivityPageState();
}

class _AddGardenActivityPageState extends State<AddGardenActivityPage> {
  final _detailsController = TextEditingController();
  String? selectedActivity;
  List<String> activities = [];

  @override
  void initState() {
    super.initState();
    _detailsController.text = '';
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GardeningBloc(GardeningServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      ))
        ..add(GetAllGardenActivities()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('إضافة مهمة جديدة'),
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
                }
              } else if (state is GardeningSuccess<GardenActivitiesModel>) {
                showSnackBar(
                  context: context,
                  content: 'تم الإضافة بنجاح',
                  failure: false,
                );
                Future.delayed(const Duration(milliseconds: 1500), () {
                  Navigator.pop(context);
                });
              }
            },
            builder: (context, state) {
              final bool isLoading = state is GardeningLoading;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 40,
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
                        });

                        // Only fire the detail event if value is not null
                        if (value != null) {
                          context.read<GardeningBloc>().add(
                                GetAllGardenActivitiesDetails(name: value),
                              );
                        }
                      },
                    ),
                    MyTextField(
                      controller: _detailsController,
                      labelText: 'تفاصيل المهمة',
                    ),
                    isLoading
                        ? const Loader()
                        : Mybutton(
                            text: 'إضافة',
                            onPressed: () {
                              if (selectedActivity == null ||
                                  selectedActivity!.isEmpty) {
                                showSnackBar(
                                  context: context,
                                  content: 'الرجاء اختيار العمل',
                                  failure: true,
                                );
                                return;
                              }

                              if (_detailsController.text.isEmpty) {
                                showSnackBar(
                                  context: context,
                                  content: 'الرجاء إدخال تفاصيل المهمة',
                                  failure: true,
                                );
                                return;
                              }

                              final model = GardenActivitiesModel(
                                name: selectedActivity,
                                details: _detailsController.text,
                              );
                              context.read<GardeningBloc>().add(
                                  AddGardenActivity(
                                      gardenActivitiesModel: model));
                            },
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
