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
import 'package:gmcappclean/features/HR/models/overtime_model.dart';
import 'package:gmcappclean/features/HR/ui/overtime/overtime_page.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/HR/bloc/hr_bloc.dart';
import 'package:gmcappclean/features/HR/services/hr_services.dart';
import 'package:gmcappclean/init_dependencies.dart';

class OvertimeListPage extends StatelessWidget {
  const OvertimeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HrBloc(HrServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>())),
      child: const Directionality(
        textDirection: ui.TextDirection.rtl,
        child: OvertimeListPageChild(),
      ),
    );
  }
}

class OvertimeListPageChild extends StatefulWidget {
  const OvertimeListPageChild({super.key});

  @override
  State<OvertimeListPageChild> createState() => _OvertimeListPageChildState();
}

class _OvertimeListPageChildState extends State<OvertimeListPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<OvertimeModel> _model = [];
  int? count;
  DateTime? _startDate;
  DateTime? _endDate;
  bool? _approve;
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

  @override
  void initState() {
    super.initState();

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
          GetOvertimes(
            page: currentPage,
            approve: _approve,
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

  Future<void> _showFilterDialog() async {
    DateTime? tempStartDate = _startDate;
    DateTime? tempEndDate = _endDate;
    // **NEW: Local temp variable for approve filter**
    bool? tempApprove = _approve;
    int? tempSelectedEmployeeId = _selectedEmployeeId;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<HrBloc>(),
          child: BlocBuilder<HrBloc, HrState>(
            builder: (context, state) {
              if (state is GetDepartmentEmployeesSuccess) {
                // Keep the state of _departmentEmployees updated
                _departmentEmployees =
                    List<Map<String, dynamic>>.from(state.result);
              }

              return Directionality(
                textDirection: ui.TextDirection.rtl,
                child: AlertDialog(
                  title: const Text('تصفية الإضافي'),
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  content: StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Start Date Picker
                            ListTile(
                              title: Text(tempStartDate == null
                                  ? 'اختر تاريخ البداية'
                                  : 'تاريخ البداية: ${_formatDateUI(tempStartDate)}'),
                              trailing: const Icon(Icons.calendar_today),
                              contentPadding: EdgeInsets.zero, // **DESIGN FIX**
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
                              contentPadding: EdgeInsets.zero, // **DESIGN FIX**
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

                            // **NEW: Approval Status Dropdown**
                            DropdownButtonFormField<bool?>(
                              value: tempApprove,
                              decoration: const InputDecoration(
                                  labelText: 'حالة الموافقة',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0)),
                              items: const [
                                DropdownMenuItem<bool?>(
                                  value: null,
                                  child: Text('الكل'),
                                ),
                                DropdownMenuItem<bool>(
                                  value: true,
                                  child: Text('موافقة'),
                                ),
                                DropdownMenuItem<bool>(
                                  value: false,
                                  child: Text('غير موافق/قيد الانتظار'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => tempApprove = value);
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
                                  // **DESIGN FIX: Ensure employee list is loaded before mapping**
                                  if (_departmentEmployees.isNotEmpty)
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
                              ),
                            const SizedBox(
                                height:
                                    20), // **DESIGN FIX: Add space at bottom**
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
                        // **UPDATE: Pass tempApprove**
                        Navigator.pop(context, {
                          'approve': tempApprove,
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
        // **UPDATE: Apply new filter state**
        _approve = result['approve'] as bool?;
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
        _approve != null || // **UPDATE: Include _approve**
        _selectedEmployeeId != null;

    // Create a concise summary text
    String summary = 'جميع الإضافي';

    // **UPDATE: Add approval status to summary**
    if (_approve != null) {
      final statusText = _approve! ? 'موافق' : 'غير موافق';
      summary += summary == 'جميع الإضافي'
          ? ' ($statusText)'
          : ', الحالة: $statusText';
    }

    if (_selectedEmployeeId != null) {
      // **TEXT FIX: Ensure correct Arabic text flow and comma separation**
      summary += (summary.contains('جميع الإضافي') && !_approve.isNotNull)
          ? ' للموظف: $_selectedEmployeeName'
          : ', موظف: $_selectedEmployeeName';
    }

    if (_startDate != null || _endDate != null) {
      final start = _startDate != null ? _formatDateUI(_startDate) : 'البداية';
      final end = _endDate != null ? _formatDateUI(_endDate) : 'النهاية';

      // **TEXT FIX: Correct Arabic phrase for date range**
      summary += (summary.contains('جميع الإضافي') &&
              !_approve.isNotNull &&
              _selectedEmployeeId == null)
          ? ' التاريخ: $start - $end'
          : ', التاريخ: $start - $end';
    }

    // Clear the default 'جميع الإضافي' if other filters were applied and format for final display
    if (isFiltered) {
      // A more robust way to remove the default phrase if other filters exist
      if (summary.startsWith('جميع الإضافي')) {
        summary = summary.substring('جميع الإضافي'.length).trim();
      }
      if (summary.startsWith(',')) {
        summary = summary.substring(1).trim();
      }
      // Final polish: remove leading comma if it somehow remained
      if (summary.startsWith(', ')) {
        summary = summary.substring(2).trim();
      }
    } else {
      summary = 'جميع الإضافي (بدون تصفية)';
    }

    // **DESIGN FIX: Ensure the row is not excessively tall, set alignment**
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
        crossAxisAlignment: CrossAxisAlignment.center, // **DESIGN FIX**
        children: [
          Expanded(
            child: AutoSizeText(
              // **TEXT FIX: Ensure summary is not empty, though theoretically shouldn't happen**
              summary.isEmpty ? 'ملخص التصفية' : summary,
              style: const TextStyle(fontSize: 14),
              minFontSize: 8,
              maxLines: 1,
              // **DESIGN FIX: Use clip instead of visible to prevent overflow if text is too long**
              overflow: TextOverflow.clip,
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list, size: 20),
            label: const Text('تصفية'),
            style: OutlinedButton.styleFrom(),
          ),
          if (isFiltered)
            IconButton(
              onPressed: () {
                setState(() {
                  _startDate = null;
                  _endDate = null;
                  _approve = null; // **UPDATE: Clear _approve**
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
            // **TEXT FIX: More specific error message for next page load/general error**
            showSnackBar(
                context: context,
                content: 'فشل في تحميل البيانات',
                failure: true);
          }
        } else if (state is GetDepartmentEmployeesSuccess) {
          _departmentEmployees = List<Map<String, dynamic>>.from(state.result);
          // Initial fetch only if model is empty (i.e., first load)
          if (_model.isEmpty && currentPage == 1) {
            runBloc();
          }
        } else if (state is HRSuccess<PageintedResult>) {
          bool shouldRebuildAppBar = false;
          // **DESIGN FIX/LOGIC FIX: Simplified total count logic. Only update if it changes or it's the first page.**
          if (count != state.result.totalCount) {
            shouldRebuildAppBar = true;
            count = state.result.totalCount;
          }

          if (currentPage == 1) {
            _model = state.result.results.cast<OvertimeModel>();
          } else {
            final newResults = state.result.results.cast<OvertimeModel>();
            if (newResults.isNotEmpty) {
              _model.addAll(newResults);
            }
          }
          isLoadingMore = false;

          if (shouldRebuildAppBar) {
            // Update the UI to reflect the new count in the AppBar
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {});
              }
            });
          }
        } else if (state is HRSuccess<OvertimeModel>) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return OvertimePage(
                  overtimeModel: state.result,
                );
              },
            ),
          );
        } else if (state is ExcelExportedSuccess<Uint8List>) {}
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const OvertimePage();
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),

            // Export to Excel Button (logic remains commented out)
            IconButton(
              onPressed: () async {},
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
                'الإضافي',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              // **DESIGN FIX: Show count only if it's non-null and > 0**
              if (count != null && count! > 0)
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
                        // **TEXT FIX: Better error message**
                        return const Center(
                            child: Text(
                                'حدث خطأ ما أثناء التحميل الأولي للإضافي.'));
                      } else if (_model.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons
                                    .access_time_filled_outlined, // **DESIGN FIX: More relevant icon**
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا يوجد إضافي لعرضه',
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
                              final overtime = _model[index];
                              return _buildCard(overtime, context);
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
                              final overtime = _model[index];
                              return _buildGridCard(overtime, context);
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

  // --- Card Builders (Updated to show approval status) ------------------------------------------

  Widget _buildCard(OvertimeModel overtime, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final Color titleColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[700]!;
    final Color accentColor = isDark ? Colors.tealAccent : Colors.teal;
    final Color iconColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;

    // **NEW: Approval status visualization**
    final bool? isApproved = overtime.hr_approve;
    final Color statusColor;
    final String statusText;
    final IconData statusIcon;

    if (isApproved == true) {
      statusColor = Colors.green;
      statusText = 'موافق';
      statusIcon = Icons.check_circle;
    } else if (isApproved == false) {
      statusColor = Colors.red;
      statusText = 'مرفوض';
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusText = 'قيد الانتظار';
      statusIcon = Icons.access_time;
    }

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
                GetOnOvertime(id: overtime.id),
              );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Name + Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      overtime.employee_full_name ?? "",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    overtime.date ?? '',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Status and Duration
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Duration
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: iconColor),
                      const SizedBox(width: 4),
                      Text(
                        // **TEXT FIX: Better display of time and duration**
                        "${overtime.start_time ?? ''} - ${overtime.end_time ?? ''} = (${overtime.duration ?? '0:00'})",
                        style: TextStyle(fontSize: 13, color: subtitleColor),
                      ),
                    ],
                  ),
                  // Status
                  Row(
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                            fontSize: 13,
                            color: statusColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),
              // Reason
              Text(
                'السبب: ${overtime.reason ?? ''}', // **TEXT FIX: Add label for clarity**
                style: TextStyle(fontSize: 13, color: subtitleColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // **Grid Card Updated for consistency with list card**
  Widget _buildGridCard(OvertimeModel overtime, BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color cardColor = isDark ? const Color(0xFF1E1E2C) : Colors.white;
    final Color titleColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[700]!;
    final Color accentColor = isDark ? Colors.tealAccent : Colors.teal;
    final Color iconColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;

    final bool? isApproved = overtime.hr_approve;
    final Color statusColor;
    final String statusText;
    final IconData statusIcon;

    if (isApproved == true) {
      statusColor = Colors.green;
      statusText = 'موافق';
      statusIcon = Icons.check_circle;
    } else if (isApproved == false) {
      statusColor = Colors.red;
      statusText = 'مرفوض';
      statusIcon = Icons.cancel;
    } else {
      statusColor = Colors.orange;
      statusText = 'قيد الانتظار';
      statusIcon = Icons.access_time;
    }

    return Card(
      color: cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.read<HrBloc>().add(
                GetOnOvertime(id: overtime.id),
              );
        },
        child: Padding(
          padding: const EdgeInsets.all(
              12), // **DESIGN FIX: Slightly smaller padding for grid**
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Employee Name + Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      overtime.employee_full_name ?? "",
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // **DESIGN FIX: Smaller font for grid**
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    overtime.date ?? '',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12, // **DESIGN FIX: Smaller font for grid**
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Status
              Row(
                children: [
                  Icon(statusIcon,
                      size: 14,
                      color: statusColor), // **DESIGN FIX: Smaller icon**
                  const SizedBox(width: 4),
                  Text(
                    statusText,
                    style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Dates/Duration
              Row(
                children: [
                  Icon(Icons.timer, size: 14, color: iconColor),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "${overtime.start_time ?? ''} - ${overtime.end_time ?? ''} = (${overtime.duration ?? '0:00'})",
                      style: TextStyle(fontSize: 12, color: subtitleColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              // Reason
              Expanded(
                child: Text(
                  'السبب: ${overtime.reason ?? ''}',
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// **Helper extension for checking nullability for cleaner code (outside the class)**
extension on bool? {
  bool get isNotNull => this != null;
}
