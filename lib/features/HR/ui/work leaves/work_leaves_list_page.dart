// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/widgets/my_circle_avatar.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/HR/bloc/hr_bloc.dart';
import 'package:gmcappclean/features/HR/models/workleaves_model.dart';
import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:gmcappclean/features/HR/ui/work%20leaves/work_leaves_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class WorkLeavesListPage extends StatelessWidget {
  final int? selectedProgress;
  const WorkLeavesListPage({
    Key? key,
    required this.selectedProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HrBloc(HrServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>())),
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: WorkLeavesListPageChild(
          selectedProgress: selectedProgress,
        ),
      ),
    );
  }
}

class WorkLeavesListPageChild extends StatefulWidget {
  final int? selectedProgress;
  const WorkLeavesListPageChild({super.key, required this.selectedProgress});

  @override
  State<WorkLeavesListPageChild> createState() =>
      _WorkLeavesListPageChildState();
}

class _WorkLeavesListPageChildState extends State<WorkLeavesListPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<WorkleavesModel> _model = [];
  int? count;
  // Filter State
  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedProgress; // 1: Dep Head, 2: HR, 3: Manager, null: All
  int? _selectedEmployeeId;

  // Employee Data
  List<Map<String, dynamic>> _departmentEmployees = [];
  String get _selectedEmployeeName {
    if (_selectedEmployeeId == null) return 'الكل';
    final employee = _departmentEmployees.firstWhere(
      (emp) => emp['id'] == _selectedEmployeeId,
      orElse: () => {'full_name': 'غير محدد'},
    );
    return employee['full_name'] as String;
  }

  String get _selectedProgressLabel {
    switch (_selectedProgress) {
      case 0:
        return 'رئيس القسم';
      case 1:
        return 'الموارد البشرية';
      case 2:
        return 'المدير';
      default:
        return 'الكل';
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedProgress = widget.selectedProgress;
    _scrollController.addListener(_onScroll);

    // Fetch employees first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HrBloc>().add(GetDepartmentEmployees());
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatDateUI(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Common function to run the Work Leaves fetch event with current filters
  void runBloc() {
    // Reset scroll position to top when applying new filters (currentPage == 1)
    if (currentPage == 1 && _scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }

    context.read<HrBloc>().add(
          GetWorkLeaves(
            page: currentPage,
            progress: _selectedProgress,
            employee_id: _selectedEmployeeId,
            date1: _formatDate(_startDate),
            date2: _formatDate(_endDate),
          ),
        );
  }

  // Logic for infinite scrolling
  void _onScroll() {
    double scrollThreshold = _scrollController.position.maxScrollExtent * 0.75;
    if (_scrollController.position.pixels >= scrollThreshold &&
        !isLoadingMore) {
      _nextPage(context);
    }
  }

  void _nextPage(BuildContext context) {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;
    runBloc();
  }

  // --- File Save Logic (Unchanged) -------------------------------------------

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      const fileName = 'تقرير إجازات الموظفين.xlsx';
      final path = '${directory.path}/$fileName';

      final file = File(path);
      await file.writeAsBytes(bytes);

      if (!mounted) return;

      await _showDialog('نجاح', 'تم حفظ الملف وسيتم فتحه الآن');
      if (!mounted) return;

      final result = await OpenFilex.open(path);

      if (!mounted) return;

      if (result.type != ResultType.done) {
        await _showDialog('خطأ', 'لم يتم فتح الملف: ${result.message}');
      }
    } catch (e) {
      if (!mounted) return; // FIX: Check mounted state after pop in error case
      await _showDialog('خطأ', 'Failed to save/open file:\n$e');
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

  // --- Filter Dialog ----------------------------------------------------

  Future<void> _showFilterDialog() async {
    DateTime? tempStartDate = _startDate;
    DateTime? tempEndDate = _endDate;
    int? tempSelectedProgress = _selectedProgress;
    int? tempSelectedEmployeeId = _selectedEmployeeId;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<HrBloc>(),
          child: BlocBuilder<HrBloc, HrState>(
            builder: (context, state) {
              if (state is GetDepartmentEmployeesSuccess) {
                _departmentEmployees =
                    List<Map<String, dynamic>>.from(state.result);
              }

              return Directionality(
                textDirection: ui.TextDirection.rtl,
                child: AlertDialog(
                  title: const Text('تصفية الإجازات'),
                  content: StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Progress Dropdown
                            DropdownButtonFormField<int>(
                              value: tempSelectedProgress,
                              decoration: const InputDecoration(
                                  labelText: 'مرحلة الاعتماد',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0)),
                              items: const [
                                DropdownMenuItem<int>(
                                  value: null,
                                  child: Text('الكل'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 0,
                                  child: Text('عند رئيس القسم'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 1,
                                  child: Text('عند الموارد البشرية'),
                                ),
                                DropdownMenuItem<int>(
                                  value: 2,
                                  child: Text('عند المدير'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => tempSelectedProgress = value);
                              },
                            ),
                            const SizedBox(height: 16),

                            // Start Date Picker
                            ListTile(
                              title: Text(tempStartDate == null
                                  ? 'اختر تاريخ البداية'
                                  : 'تاريخ البداية: ${_formatDateUI(tempStartDate)}'),
                              trailing: const Icon(Icons.calendar_today),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: tempStartDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => tempStartDate = picked);
                                }
                              },
                            ),

                            // End Date Picker
                            ListTile(
                              title: Text(tempEndDate == null
                                  ? 'اختر تاريخ النهاية'
                                  : 'تاريخ النهاية: ${_formatDateUI(tempEndDate)}'),
                              trailing: const Icon(Icons.calendar_today),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: tempEndDate ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => tempEndDate = picked);
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            // Employee Dropdown
                            if (_departmentEmployees.isEmpty &&
                                (state is HRLoading))
                              const Center(child: Loader())
                            else
                              DropdownButtonFormField<int>(
                                value: tempSelectedEmployeeId,
                                decoration: const InputDecoration(
                                    labelText: 'اختر الموظف (اختياري)',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0)),
                                items: [
                                  const DropdownMenuItem<int>(
                                    value: null,
                                    child: Text('الكل'),
                                  ),
                                  ..._departmentEmployees.map((emp) {
                                    return DropdownMenuItem<int>(
                                      value: emp['id'] as int,
                                      child: Text(emp['full_name'] as String),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(
                                      () => tempSelectedEmployeeId = value);
                                },
                              )
                          ],
                        ),
                      );
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'progress': tempSelectedProgress,
                          'date1': tempStartDate,
                          'date2': tempEndDate,
                          'employee_id': tempSelectedEmployeeId,
                        });
                      },
                      child: const Text('تصفية'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    // Apply filters and fetch new data if the dialog returned a result
    if (result != null) {
      setState(() {
        _startDate = result['date1'] as DateTime?;
        _endDate = result['date2'] as DateTime?;
        _selectedProgress = result['progress'] as int?;
        _selectedEmployeeId = result['employee_id'] as int?;

        // Reset pagination for new filter search
        currentPage = 1;
        _model = []; // Clear current list
        isLoadingMore = false;
      });
      runBloc();
    }
  }

  // --- New Filter Bar Widget ----------------------------------------------------

  Widget _buildFilterBar(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    // Check if any filter is active
    final bool isFiltered = _startDate != null ||
        _endDate != null ||
        _selectedProgress != null ||
        _selectedEmployeeId != null;

    // Create a concise summary text
    String summary = 'جميع الإجازات';
    if (_selectedProgress != null) {
      summary = 'مرحلة: ${_selectedProgressLabel}';
    }
    if (_selectedEmployeeId != null) {
      summary += summary == 'جميع الإجازات'
          ? 'للموظف: $_selectedEmployeeName'
          : ', موظف: $_selectedEmployeeName';
    }
    if (_startDate != null || _endDate != null) {
      final start = _startDate != null ? _formatDateUI(_startDate) : 'البداية';
      final end = _endDate != null ? _formatDateUI(_endDate) : 'النهاية';
      summary += summary == 'جميع الإجازات'
          ? 'التاريخ: $start - $end'
          : ', تاريخ: $start - $end';
    }

    // Clear the default 'جميع الإجازات' if other filters were applied
    if (isFiltered && summary.startsWith('جميع الإجازات')) {
      summary = summary.substring('جميع الإجازات'.length).trim();
    } else if (isFiltered && summary.startsWith(',')) {
      summary = summary.substring(1).trim();
    }
    if (!isFiltered) summary = 'جميع الإجازات (بدون تصفية)';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AutoSizeText(
              summary,
              style: const TextStyle(fontSize: 14),
              minFontSize: 8,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list, size: 20),
            label: const Text('تصفية'),
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.tealAccent : Colors.teal,
              side: BorderSide(color: isDark ? Colors.tealAccent : Colors.teal),
            ),
          ),
          if (isFiltered)
            IconButton(
              onPressed: () {
                setState(() {
                  _startDate = null;
                  _endDate = null;
                  _selectedProgress = null;
                  _selectedEmployeeId = null;
                  currentPage = 1;
                  _model = [];
                  isLoadingMore = false;
                });
                runBloc();
              },
              icon: const Icon(Icons.clear, color: Colors.red),
              tooltip: 'إزالة التصفية',
            ),
        ],
      ),
    );
  }

  // --- Main Build Method ----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<HrBloc, HrState>(
      listener: (context, state) async {
        if (state is HRError) {
          if (_model.isEmpty && currentPage == 1) {
            // Error on initial load, handled by BlocConsumer below
          } else {
            showSnackBar(
                context: context, content: 'حدث خطأ ما', failure: true);
          }
        } else if (state is GetDepartmentEmployeesSuccess) {
          _departmentEmployees = List<Map<String, dynamic>>.from(state.result);
          // Initial fetch only if model is empty (i.e., first load)
          if (_model.isEmpty && currentPage == 1) {
            runBloc();
          }
        } else if (state is HRSuccess<PageintedResult>) {
          bool shouldRebuildAppBar = false;
          if (count == null ||
              currentPage == 1 ||
              state.result.totalCount! > 0) {
            shouldRebuildAppBar = count != state.result.totalCount;
            count = state.result.totalCount;
          }
          if (currentPage == 1) {
            _model = state.result.results.cast<WorkleavesModel>();
          } else {
            final newResults = state.result.results.cast<WorkleavesModel>();
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
          // setState(() {
          //   if (currentPage == 1) {
          //     _model = state.result;
          //   } else {
          //     _model.addAll(state.result);
          //   }
          //   isLoadingMore = false;
          // });
        } else if (state is HRSuccess<WorkleavesModel>) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return WorkLeavesPage(
                  workleavesModel: state.result,
                );
              },
            ),
          );
        } else if (state is ExcelExportedSuccess<Uint8List>) {
          await _saveFile(state.result);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // Add Work Leave Button
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const WorkLeavesPage();
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),

            // Export to Excel Button (logic remains in AppBar as it's a secondary action)
            IconButton(
              onPressed: () async {
                int? employeeIdForExport = _selectedEmployeeId;
                DateTime? startDateForExport = _startDate;
                DateTime? endDateForExport = _endDate;

                // Show Date/Employee picker for export
                await showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return BlocProvider.value(
                      value: context.read<HrBloc>(),
                      child: BlocBuilder<HrBloc, HrState>(
                        builder: (context, state) {
                          return Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: AlertDialog(
                              title: const Text('اختر الفترة الزمنية والموظف'),
                              content: StatefulBuilder(
                                builder: (context, setState) {
                                  return SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Start Date Picker
                                        ListTile(
                                          title: Text(startDateForExport == null
                                              ? 'اختر تاريخ البداية'
                                              : 'تاريخ البداية: ${_formatDateUI(startDateForExport)}'),
                                          trailing:
                                              const Icon(Icons.calendar_today),
                                          onTap: () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: startDateForExport ??
                                                  DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picked != null) {
                                              setState(() =>
                                                  startDateForExport = picked);
                                            }
                                          },
                                        ),
                                        // End Date Picker
                                        ListTile(
                                          title: Text(endDateForExport == null
                                              ? 'اختر تاريخ النهاية'
                                              : 'تاريخ النهاية: ${_formatDateUI(endDateForExport)}'),
                                          trailing:
                                              const Icon(Icons.calendar_today),
                                          onTap: () async {
                                            final picked = await showDatePicker(
                                              context: context,
                                              initialDate: endDateForExport ??
                                                  DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picked != null) {
                                              setState(() =>
                                                  endDateForExport = picked);
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        // Employee Dropdown (using the locally cached list)
                                        if (_departmentEmployees.isNotEmpty)
                                          DropdownButtonFormField<int>(
                                            value: employeeIdForExport,
                                            decoration: const InputDecoration(
                                              labelText:
                                                  'اختر الموظف (اختياري)',
                                              border: OutlineInputBorder(),
                                            ),
                                            items: [
                                              const DropdownMenuItem<int>(
                                                value: null,
                                                child: Text('الكل'),
                                              ),
                                              ..._departmentEmployees
                                                  .map((emp) {
                                                return DropdownMenuItem<int>(
                                                  value: emp['id'] as int,
                                                  child: Text(emp['full_name']
                                                      as String),
                                                );
                                              }).toList(),
                                            ],
                                            onChanged: (value) {
                                              setState(() =>
                                                  employeeIdForExport = value);
                                            },
                                          )
                                        else if (state is HRLoading)
                                          const Center(child: Loader())
                                        else
                                          const Text('لا توجد بيانات موظفين.'),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (startDateForExport != null &&
                                        endDateForExport != null) {
                                      Navigator.pop(context, {
                                        'date1': startDateForExport,
                                        'date2': endDateForExport,
                                        'employee_id': employeeIdForExport,
                                      });
                                    } else {
                                      showSnackBar(
                                        context: context,
                                        content:
                                            'يجب اختيار تاريخي البداية والنهاية',
                                        failure: true,
                                      );
                                    }
                                  },
                                  child: const Text('تأكيد'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ).then((result) {
                  if (result != null) {
                    final date1 = _formatDate(result['date1'] as DateTime);
                    final date2 = _formatDate(result['date2'] as DateTime);
                    final employeeId = result['employee_id'] as int?;

                    context.read<HrBloc>().add(
                          ExportExcelWorksLeaves(
                            date1: date1,
                            date2: date2,
                            employee_id: employeeId,
                          ),
                        );
                  }
                });
              },
              icon: const Icon(
                FontAwesomeIcons.fileExport,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor:
              isDark ? AppColors.gradient2 : AppColors.lightGradient2,
          title: Row(
            children: [
              const Text(
                'الإجازات',
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
        body: Column(
          children: [
            // New Filter Bar at the top of the body
            _buildFilterBar(context),

            Expanded(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  final isPortrait = orientation == Orientation.portrait;
                  return BlocConsumer<HrBloc, HrState>(
                    listener: (context, state) {
                      // Handled by the root BlocListener
                    },
                    builder: (context, state) {
                      final isInitialLoading =
                          state is HRLoading && currentPage == 1;

                      if (isInitialLoading) {
                        return const Center(child: Loader());
                      } else if (state is HRError && _model.isEmpty) {
                        return const Center(
                            child: Text('حدث خطأ ما أثناء التحميل الأولي.'));
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
                                'لا توجد إجازات لعرضها',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
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
                              final workleaves = _model[index];
                              return _buildCard(workleaves, context);
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
                              childAspectRatio: 2.5,
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
                              final workleaves = _model[index];
                              return _buildGridCard(workleaves, context);
                            },
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Card Builders (Unchanged) ------------------------------------------

  Widget _buildCard(WorkleavesModel workleaves, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final Color titleColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[700]!;
    final Color accentColor = isDark ? Colors.tealAccent : Colors.teal;
    final Color iconColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shadowColor: isDark ? Colors.black45 : Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.read<HrBloc>().add(
                GetOnWorkLeave(id: workleaves.id),
              );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Name + Kind
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      workleaves.employee_full_name ?? "",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    workleaves.kind ?? '',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Dates
              Row(
                children: [
                  Icon(Icons.date_range, size: 16, color: iconColor),
                  const SizedBox(width: 4),
                  Text(
                    "${workleaves.start_date ?? ''} - ${workleaves.duration ?? ''} ${workleaves.duration_unit ?? ''}",
                    style: TextStyle(fontSize: 13, color: subtitleColor),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Approvals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildApprovalChip(
                      context, "رئيس القسم", workleaves.dep_head_approve),
                  _buildApprovalChip(
                      context, "الموارد البشرية", workleaves.hr_approve),
                  _buildApprovalChip(
                      context, "المدير", workleaves.manager_approve),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridCard(WorkleavesModel workleaves, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final Color titleColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[700]!;
    final Color accentColor = isDark ? Colors.tealAccent : Colors.teal;
    final Color iconColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;
    return Card(
      color: cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.read<HrBloc>().add(
                GetOnWorkLeave(id: workleaves.id),
              );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Employee Name + Kind
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      workleaves.employee_full_name ?? "",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    workleaves.kind ?? '',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Dates
              Row(
                children: [
                  Icon(Icons.date_range, size: 16, color: iconColor),
                  const SizedBox(width: 4),
                  Text(
                    "${workleaves.start_date ?? ''} - ${workleaves.duration ?? ''} ${workleaves.duration_unit ?? ''}",
                    style: TextStyle(fontSize: 13, color: subtitleColor),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Approvals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildApprovalChip(
                      context, "رئيس القسم", workleaves.dep_head_approve),
                  _buildApprovalChip(
                      context, "الموارد البشرية", workleaves.hr_approve),
                  _buildApprovalChip(
                      context, "المدير", workleaves.manager_approve),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Approval Chip (Unchanged) --------------------------------------------

Widget _buildApprovalChip(BuildContext context, String label, bool? approved) {
  bool isDark = Theme.of(context).brightness == Brightness.dark;

  late Color color;
  late String text;

  if (approved == true) {
    color = Colors.green.shade600;
    text = "✔ $label";
  } else if (approved == false) {
    color = Colors.red.shade600;
    text = "✖ $label";
  } else {
    color = isDark ? Colors.grey.shade700 : Colors.grey.shade400;
    text = "- $label";
  }

  return Chip(
    label: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 11),
    ),
    backgroundColor: color,
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
  );
}
