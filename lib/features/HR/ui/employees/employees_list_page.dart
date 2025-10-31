import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_circle_avatar.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/HR/bloc/hr_bloc.dart';
import 'package:gmcappclean/features/HR/models/brief_employee_model.dart';
import 'package:gmcappclean/features/HR/models/employee_model.dart';
import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:gmcappclean/features/HR/ui/employees/employee_page.dart';

import 'package:gmcappclean/init_dependencies.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class EmployeesListPage extends StatelessWidget {
  const EmployeesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HrBloc(HrServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          SearchEmployee(page: 1, is_working: true),
        ),
      child: Builder(builder: (context) {
        return const EmployeesListPageChild();
      }),
    );
  }
}

class EmployeesListPageChild extends StatefulWidget {
  const EmployeesListPageChild({super.key});

  @override
  State<EmployeesListPageChild> createState() => _EmployeesListPageChildState();
}

class _EmployeesListPageChildState extends State<EmployeesListPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;
  bool isSearching = false;
  bool isLoadingMore = false;
  bool isEmployeeLoading = false;
  List<BriefEmployeeModel> _model = [];
  List<String>? groups;

  String? _selectedItemDepartment;
  String? _selectedStatus;
  int? count;
  final List<String> _status = [
    'يعمل',
    'لا يعمل',
    'الكل',
  ];
  final List<String> _department = [
    'الإدارة',
    'بطاقة ثانية',
    'دعم تقني',
    'الزراعة',
    'شركة النور',
    'الأولية',
    'التصنيع',
    'التعبئة',
    'التوزيع',
    'الخدمات',
    'الصيانة',
    'المبيعات',
    'المحاسبة',
    'المخبر',
    'الموارد البشرية',
    'الجاهزة',
    'ضبط جودة',
    'المشتريات',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);
    // Set initial filter status to 'الكل'
    _selectedStatus = 'يعمل';
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool? _getStatusBool() {
    if (_selectedStatus == 'يعمل') {
      return true;
    } else if (_selectedStatus == 'لا يعمل') {
      return false;
    }
    return null;
  }

  void runBloc() {
    context.read<HrBloc>().add(
          SearchEmployee(
            page: currentPage,
            search: _searchController.text,
            department: _selectedItemDepartment ?? '',
            is_working: _getStatusBool(),
          ),
        );
  }

  Widget _buildDepartmentDropdown(bool isDark) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              hint: Text(
                'القسم',
                style: TextStyle(
                    color:
                        isDark ? Colors.grey.shade200 : Colors.orange.shade700),
              ),
              value: _selectedItemDepartment,
              onChanged: (String? newValue) {
                setState(() {
                  currentPage = 1;
                  _selectedItemDepartment = newValue;
                });
                _model = [];
                runBloc();
              },
              isExpanded: true,
              underline: const SizedBox(),
              items: _department.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: isDark
                                ? Colors.grey.shade200
                                : Colors.orange.shade700),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          if (_selectedItemDepartment != null)
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedItemDepartment = null;
                });
                _model = [];
                runBloc();
              },
              child: Icon(
                Icons.close,
                color: Colors.red.shade400,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  // Status Segmented Button Widget
  Widget _buildStatusSegmentedButton(bool isDark) {
    return SegmentedButton<String>(
      segments: _status.map((status) {
        return ButtonSegment<String>(
          value: status,
          label: Text(status, style: const TextStyle(fontSize: 12)),
          icon: status == 'يعمل'
              ? Icon(Icons.check_circle_outline,
                  size: 16, color: Colors.green.shade700)
              : status == 'لا يعمل'
                  ? Icon(Icons.cancel_outlined,
                      size: 16, color: Colors.red.shade700)
                  : const Icon(Icons.people_alt_outlined,
                      size: 16, color: Colors.blueGrey),
        );
      }).toList(),
      selected: {_selectedStatus ?? 'الكل'},
      onSelectionChanged: (Set<String> newSelection) {
        if (newSelection.isNotEmpty) {
          setState(() {
            currentPage = 1;
            _selectedStatus = newSelection.first;
            _model.clear();
            runBloc();
          });
        }
      },
      showSelectedIcon: false,
      emptySelectionAllowed: false,
      style: SegmentedButton.styleFrom(
          // Ensure consistent colors/styling
          selectedForegroundColor: isDark ? Colors.white : Colors.black,
          selectedBackgroundColor:
              isDark ? AppColors.gradient2 : Colors.orange.shade100,
          side: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.orange.shade200,
            width: 1.0,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8)),
    );
  }

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      const fileName = 'تقرير الموظفين.xlsx';
      final path = '${directory.path}\\$fileName';

      final file = File(path);
      await file.writeAsBytes(bytes);

      await _showDialog('نجاح', 'تم حفظ الملف وسيتم فتحه الآن');
      final result = await OpenFilex.open(path);
      if (result.type != ResultType.done) {
        await _showDialog('Error', 'لم يتم فتح الملف: ${result.message}');
      }
    } catch (e) {
      await _showDialog('Error', 'Failed to save/open file:\n$e');
      Navigator.of(context).pop();
    }
  }

  Future<void> _showDialog(String title, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<HrBloc, HrState>(
      listener: (context, state) {
        if (state is HRError) {
          setState(() {
            isEmployeeLoading = false;
          });
          showSnackBar(context: context, content: 'حدث خطأ ما', failure: true);
        }
      },
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const EmployeePage();
                      },
                    ),
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () async {
                  final result = await showDialog<bool?>(
                    context: context,
                    builder: (context) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        title: const Text('اختر نوع التصدير'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('الموظفين العاملين'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('الموظفين المستقيلين'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, null),
                            child: const Text('كافة الموظفين'),
                          ),
                        ],
                      ),
                    ),
                  );

                  if (result != null || result == null) {
                    context
                        .read<HrBloc>()
                        .add(ExportExcelEmployees(isWorking: result));
                  }
                },
                icon: const Icon(
                  FontAwesomeIcons.fileExport,
                  color: Colors.white,
                ),
              )
            ],
            backgroundColor:
                isDark ? AppColors.gradient2 : AppColors.lightGradient2,
            title: Row(
              children: [
                const Text(
                  'الموظفون',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                if (count != null)
                  MyCircleAvatar(
                    text: count.toString(),
                  ),
              ],
            ),
          ),
          body: OrientationBuilder(
            builder: (context, orientation) {
              final isPortrait = orientation == Orientation.portrait;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isPortrait
                        ? Column(
                            children: [
                              _buildDepartmentDropdown(isDark),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: _buildStatusSegmentedButton(isDark),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: _buildDepartmentDropdown(isDark)),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: _buildStatusSegmentedButton(isDark),
                              ),
                            ],
                          ),
                  ),
                  SearchRow(
                    textEditingController: _searchController,
                    onSearch: () {
                      currentPage = 1;
                      _model.clear();
                      runBloc();
                    },
                  ),
                  Expanded(
                    child: BlocConsumer<HrBloc, HrState>(
                      listener: (context, state) async {
                        if (state is HRError) {
                          setState(() {
                            isEmployeeLoading = false;
                          });
                          showSnackBar(
                            context: context,
                            content: 'حدث خطأ ما',
                            failure: true,
                          );
                        } else if (state is HRSuccess<PageintedResult>) {
                          bool shouldRebuildAppBar = false;
                          if (count == null ||
                              currentPage == 1 ||
                              state.result.totalCount! > 0) {
                            shouldRebuildAppBar =
                                count != state.result.totalCount;
                            count = state.result.totalCount;
                          }
                          if (currentPage == 1) {
                            _model =
                                state.result.results.cast<BriefEmployeeModel>();
                          } else {
                            final newResults =
                                state.result.results.cast<BriefEmployeeModel>();
                            if (newResults.isNotEmpty) {
                              _model.addAll(newResults);
                            }
                          }
                          isLoadingMore = false;

                          if (shouldRebuildAppBar) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {});
                              }
                            });
                          }
                        } else if (state is HRSuccess<EmployeeModel>) {
                          setState(() {
                            isEmployeeLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EmployeePage(
                                  employeeModel: state.result,
                                );
                              },
                            ),
                          );
                        } else if (state is ExcelExportedSuccess<Uint8List>) {
                          await _saveFile(state.result);
                        }
                      },
                      builder: (context, state) {
                        if (state is HRLoading &&
                            (currentPage == 1 || isEmployeeLoading == true)) {
                          return const Center(child: Loader());
                        } else if (state is HRError) {
                          return const Center(child: Text('حدث خطأ ما'));
                        } else if (_model.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.people_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد موظفين لعرضها',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (_model.isNotEmpty) {
                          if (isPortrait) {
                            // PORTRAIT VIEW: ListView
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: _model.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _model.length) {
                                  return isLoadingMore
                                      ? const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Center(child: Loader()),
                                        )
                                      : const SizedBox.shrink();
                                }
                                final employee = _model[index];
                                return _buildEmployeeCard(employee, context);
                              },
                            );
                          } else {
                            // LANDSCAPE VIEW: GridView
                            return GridView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 3.2,
                              ),
                              itemCount: _model.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _model.length) {
                                  return isLoadingMore
                                      ? const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Center(child: Loader()),
                                        )
                                      : const SizedBox.shrink();
                                }
                                final employee = _model[index];
                                return _buildEmployeeGridCard(
                                    employee, context);
                              },
                            );
                          }
                        } else {
                          return const Center(
                            child: Loader(),
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

  Widget _buildEmployeeCard(BriefEmployeeModel employee, BuildContext context) {
    final bool isWorking = employee.is_working ?? false;
    final String duration = _calculateDuration(
      employee.employment_date,
      quittingDate: employee.quitting_date,
    );

    // Determine gender appearance
    final String? gender = employee.gender?.toLowerCase();
    late final IconData genderIcon;
    late final Color genderColor;
    late final String genderLabel;

    if (gender == 'male' || gender == 'ذكر') {
      genderIcon = Icons.male;
      genderColor = Colors.blueAccent;
      genderLabel = 'ذكر';
    } else if (gender == 'female' || gender == 'أنثى') {
      genderIcon = Icons.female;
      genderColor = Colors.pinkAccent;
      genderLabel = 'أنثى';
    } else {
      genderIcon = Icons.person_outline;
      genderColor = Colors.grey;
      genderLabel = 'غير محدد';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isEmployeeLoading = true;
          });
          context.read<HrBloc>().add(GetOnEemployee(id: employee.id));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Tooltip(
                message: genderLabel,
                child: CircleAvatar(
                  backgroundColor: genderColor.withOpacity(0.15),
                  radius: 18,
                  child: Icon(
                    genderIcon,
                    color: genderColor,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: AutoSizeText(
                            employee.full_name ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            minFontSize: 8,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: AutoSizeText(
                              employee.department_name ?? "",
                              minFontSize: 8,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'تاريخ التوظيف: ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              employee.employment_date ?? "",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: AutoSizeText(
                                'مدة العمل: $duration',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                                minFontSize: 8,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                isWorking ? Icons.check_circle : Icons.cancel,
                color: isWorking ? Colors.green : Colors.red,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeGridCard(
    BriefEmployeeModel employee,
    BuildContext context,
  ) {
    final bool isWorking = employee.is_working ?? false;
    final String duration = _calculateDuration(
      employee.employment_date,
      quittingDate: employee.quitting_date,
    );

    // Determine gender and avatar style
    final String? gender = employee.gender?.toLowerCase();
    late final IconData genderIcon;
    late final Color genderColor;

    if (gender == 'male' || gender == 'ذكر') {
      genderIcon = Icons.male;
      genderColor = Colors.blueAccent;
    } else if (gender == 'female' || gender == 'أنثى') {
      genderIcon = Icons.female;
      genderColor = Colors.pinkAccent;
    } else {
      genderIcon = Icons.person_outline;
      genderColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.all(4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isEmployeeLoading = true;
          });
          context.read<HrBloc>().add(GetOnEemployee(id: employee.id));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: genderColor.withOpacity(0.15),
                radius: 18,
                child: Icon(
                  genderIcon,
                  color: genderColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Text(
                            employee.full_name ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: AutoSizeText(
                              employee.department_name ?? "",
                              minFontSize: 8,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'تاريخ التوظيف: ${employee.employment_date ?? ""}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: AutoSizeText(
                            'مدة العمل: $duration',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 8,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Icon(
                  isWorking ? Icons.check_circle : Icons.cancel,
                  color: isWorking ? Colors.green : Colors.red,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    double halfwayPoint = _scrollController.position.maxScrollExtent * 0.5;

    if (_scrollController.position.pixels >= halfwayPoint && !isLoadingMore) {
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    if (isLoadingMore) return;
    if (_model.isEmpty) return;
    setState(() => isLoadingMore = true);
    currentPage++;
    runBloc();
  }

  String _calculateDuration(String? employmentDate, {String? quittingDate}) {
    if (employmentDate == null || employmentDate.isEmpty) {
      return '';
    }

    try {
      final employmentDateTime = DateTime.parse(employmentDate);

      final DateTime endDateTime;
      if (quittingDate != null && quittingDate.isNotEmpty) {
        endDateTime = DateTime.parse(quittingDate);
      } else {
        endDateTime = DateTime.now();
      }

      if (endDateTime.isBefore(employmentDateTime)) {
        return 'تاريخ غير صالح';
      }

      final difference = endDateTime.difference(employmentDateTime);
      int days = difference.inDays;

      int years = days ~/ 365;
      days %= 365;
      int months = days ~/ 30;
      days %= 30;

      String durationText = '';

      if (years > 0) {
        durationText += '$years سنوات ';
      }

      if (months > 0) {
        durationText += '$months أشهر ';
      }

      if (days > 0 || durationText.isEmpty) {
        if (durationText.isEmpty) {
          durationText += '$days يوم';
        } else if (days > 0) {
          durationText += '$days يوم';
        }
      }

      return durationText.trim();
    } catch (e) {
      return 'تنسيق تاريخ غير صالح';
    }
  }
}
