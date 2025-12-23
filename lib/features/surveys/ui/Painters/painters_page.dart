import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/common/widgets/searchable_dropdown.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/navigate_with_animate.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/surveys/bloc/surveys_bloc.dart';
import 'package:gmcappclean/features/surveys/models/painters_model.dart';
import 'package:gmcappclean/features/surveys/services/surveys_services.dart';
import 'package:gmcappclean/features/surveys/ui/Painters/painters_list.dart';
import 'package:gmcappclean/features/surveys/ui/Painters/painters_page.dart';
import 'package:gmcappclean/features/surveys/ui/lists/locations.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:gmcappclean/init_dependencies.dart';

class PaintersPage extends StatelessWidget {
  PaintersModel? paintersModel;
  PaintersPage({super.key, this.paintersModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveysBloc(SurveysServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(
        builder: (context) {
          return PaintersPageChild(paintersModel: paintersModel);
        },
      ),
    );
  }
}

class PaintersPageChild extends StatefulWidget {
  PaintersModel? paintersModel;
  PaintersPageChild({super.key, this.paintersModel});

  @override
  State<PaintersPageChild> createState() => _PaintersPageChildState();
}

class _PaintersPageChildState extends State<PaintersPageChild> {
  final _painterNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _regionController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.paintersModel != null) {
      _painterNameController.text = widget.paintersModel!.painter_name ?? '';
      _mobileNumberController.text = widget.paintersModel!.mobile_number ?? '';
      _regionController.text = widget.paintersModel!.region ?? '';
    }

    regions = Locations.regions;
  }

  @override
  void dispose() {
    _painterNameController.dispose();
    _mobileNumberController.dispose();
    _regionController.dispose();

    super.dispose();
  }

  late List<String> regions;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Text(
            widget.paintersModel == null ? 'إضافة رقم دهان' : 'تعديل رقم دهان',
          ),
        ),
        body: BlocConsumer<SurveysBloc, SurveysState>(
          listener: (context, state) {
            if (state is SurveysSuccess<PaintersModel>) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.paintersModel == null ? 'الإضافة' : 'التعديل'}',
                failure: false,
              );
              Navigator.pop(context);
              navigateWithAnimateReplace(context, const PaintersList());
            } else if (state is SurveysError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
            } else if (state is SurveysSuccess<bool>) {
              showSnackBar(
                context: context,
                content: 'تم الحذف بنجاح',
                failure: false,
              );
              Navigator.pop(context);
              navigateWithAnimateReplace(context, const PaintersList());
            }
          },
          builder: (context, state) {
            if (state is SurveysLoading) {
              return const Center(child: Loader());
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 20,
                    children: [
                      MyTextField(
                          controller: _painterNameController,
                          labelText: 'اسم الدهان'),
                      MyTextField(
                          controller: _mobileNumberController,
                          labelText: 'رقم الدهان'),
                      SearchableDropdown(
                        controller: _regionController,
                        labelText: 'المنطقة',
                        items: regions,
                      ),
                      Center(
                        child: Mybutton(
                          text:
                              widget.paintersModel == null ? 'إضافة' : 'تعديل',
                          onPressed: _submitForm,
                        ),
                      ),
                      if (widget.paintersModel != null)
                        Center(
                          child: IconButton(
                            icon: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(0.2),
                                border: Border.all(
                                    color: Colors.red.withOpacity(0.5),
                                    width: 1),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const FaIcon(
                                FontAwesomeIcons.trash,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                            tooltip: 'حذف',
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => Directionality(
                                  textDirection: ui.TextDirection.rtl,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Wrap(
                                      children: [
                                        const ListTile(
                                          title: Text('تأكيد الحذف',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          subtitle: Text('هل انت متأكد؟'),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('إلغاء'),
                                            ),
                                            const SizedBox(width: 8),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.withOpacity(0.1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  side: BorderSide(
                                                      color: Colors.red
                                                          .withOpacity(0.3)),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                context.read<SurveysBloc>().add(
                                                      DeleteOnePainter(
                                                        id: widget
                                                            .paintersModel!.id,
                                                      ),
                                                    );
                                              },
                                              child: const Text('حذف',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm() {
    // Validate required fields
    final List<String> missingFields = [];

    if (_painterNameController.text.trim().isEmpty) {
      missingFields.add('اسم الدهان');
    }
    if (_mobileNumberController.text.trim().isEmpty) {
      missingFields.add('رقم الدهان');
    }

    if (_regionController.text.trim().isEmpty) {
      missingFields.add('المنطقة');
    }

    if (missingFields.isNotEmpty) {
      showSnackBar(
        context: context,
        content:
            'يرجى تعبئة الحقول المطلوبة التالية:\n${missingFields.join('، ')}',
        failure: true,
      );
      return;
    }

    final model = _fillModelFromForm();
    print(model);
    if (widget.paintersModel == null) {
      context.read<SurveysBloc>().add(
            AddNewPainter(paintersModel: model),
          );
    } else {
      context.read<SurveysBloc>().add(
            EditPainter(
              paintersModel: model,
              id: widget.paintersModel!.id,
            ),
          );
    }
  }

  PaintersModel _fillModelFromForm() {
    return PaintersModel(
      id: widget.paintersModel?.id ?? 0,
      painter_name: _painterNameController.text,
      region: _regionController.text,
      mobile_number: _mobileNumberController.text,
    );
  }
}
