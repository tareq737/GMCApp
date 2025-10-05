import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/bloc/operations_bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/models/operations_model.dart';
import 'package:gmcappclean/features/sales_management/operations/services/operations_services.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_call_page.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_visit_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

// No changes needed in this widget
class OperationsDatePage extends StatelessWidget {
  final String fromDate;
  final String toDate;
  final String? reception;
  final bool? bill;
  final bool? paid_money;

  const OperationsDatePage({
    super.key,
    required this.fromDate,
    required this.toDate,
    this.reception,
    this.bill,
    this.paid_money,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<SalesBloc>()),
        BlocProvider(
          create: (context) => OperationsBloc(OperationsServices(
            apiClient: getIt<ApiClient>(),
            checkUserSessionStatus: getIt<CheckUserSessionStatus>(),
          )),
        ),
      ],
      child: OperationsDatePageChild(
        fromDate: fromDate,
        toDate: toDate,
        reception: reception,
        bill: bill,
        paid_money: paid_money,
      ),
    );
  }
}

// No changes needed in this widget
class OperationsDatePageChild extends StatefulWidget {
  final String fromDate;
  final String toDate;
  final String? reception;
  final bool? bill;
  final bool? paid_money;
  const OperationsDatePageChild({
    super.key,
    required this.fromDate,
    required this.toDate,
    this.reception,
    this.bill,
    this.paid_money,
  });

  @override
  State<OperationsDatePageChild> createState() =>
      _OperationsDatePageChildState();
}

// --- All changes are within this State class ---
class _OperationsDatePageChildState extends State<OperationsDatePageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  bool isLoadingMore = false;
  List<OperationsModel> _model = [];
  bool isInitialDataLoaded = false;
  double width = 0;
  @override
  void initState() {
    super.initState();
    _fromDateController.text = widget.fromDate;
    _toDateController.text = widget.toDate;
    _scrollController.addListener(_onScroll);
    runBloc();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      const fileName = 'تقرير زيارات المبيعات.xlsx';
      final path = '${directory.path}\\$fileName';
      final file = File(path);
      await file.writeAsBytes(bytes);
      await _showDialog('نجاح', 'تم حفظ الملف وسيتم فتحه الآن');
      final result = await OpenFilex.open(path);
      if (result.type != ResultType.done) {
        await _showDialog('Error', 'لم يتم فتح الملف: ${result.message}');
      }
      Navigator.of(context).pop();
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
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent *
                0.8 && // Trigger when 80% scrolled
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

  void runBloc({bool reset = false}) {
    if (reset) {
      setState(() {
        currentPage = 1;
        _model.clear();
        isInitialDataLoaded = false;
      });
    }
    context.read<OperationsBloc>().add(
          GetAllOperationsForDate(
            page: currentPage,
            date1: _fromDateController.text,
            date2: _toDateController.text,
            reception: widget.reception,
            bill: widget.bill,
            paid_money: widget.paid_money,
          ),
        );
  }

  // --- REFACTORED BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Text('عمليات الزبائن'),
              SizedBox(width: 10),
              Icon(Icons.info_outline),
            ],
          ),
          actions: [
            // ... (Your AppBar actions remain the same)
            if (defaultTargetPlatform == TargetPlatform.windows)
              BlocConsumer<OperationsBloc, OperationsState>(
                listener: (context, state) async {
                  if (state is OperationsError) {
                    showSnackBar(
                      context: context,
                      content: state.errorMessage,
                      failure: true,
                    );
                  } else if (state is OperationsSuccess<Uint8List>) {
                    await _saveFile(state.result);
                  }
                },
                builder: (context, state) {
                  return IconButton(
                    icon: const Icon(FontAwesomeIcons.fileExport),
                    onPressed: () {
                      if (_fromDateController.text.isNotEmpty &&
                          _toDateController.text.isNotEmpty) {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "اختر نوع التصدير",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ListTile(
                                    leading:
                                        const Icon(Icons.people_alt_outlined),
                                    title: const Text("الزيارات"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      context.read<OperationsBloc>().add(
                                            ExportExcelOperations(
                                              fromDate:
                                                  _fromDateController.text,
                                              toDate: _toDateController.text,
                                              type: 'visits',
                                            ),
                                          );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                        Icons.phone_in_talk_outlined),
                                    title: const Text("المكالمات"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      context.read<OperationsBloc>().add(
                                            ExportExcelOperations(
                                              fromDate:
                                                  _fromDateController.text,
                                              toDate: _toDateController.text,
                                              type: 'calls',
                                            ),
                                          );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.all_inclusive),
                                    title: const Text("الكل"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      context.read<OperationsBloc>().add(
                                            ExportExcelOperations(
                                              fromDate:
                                                  _fromDateController.text,
                                              toDate: _toDateController.text,
                                              type: 'both',
                                            ),
                                          );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        showSnackBar(
                          context: context,
                          content: 'الرجاء تحديد تاريخ البدء وتاريخ الانتهاء',
                          failure: true,
                        );
                      }
                    },
                  );
                },
              ),
          ],
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return _buildLandscapeLayout();
            } else {
              return _buildPortraitLayout();
            }
          },
        ),
      ),
    );
  }

  /// Builds the layout for portrait mode (Filters on top of List).
  Widget _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildFilterSectionColumn(),
          const SizedBox(height: 10),
          Expanded(child: _buildResultsList()),
        ],
      ),
    );
  }

  /// Builds the layout for landscape mode (Filters in a row on top of a Grid).
  Widget _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          _buildFilterSectionRow(), // Using the new Row layout for filters
          const SizedBox(height: 10),
          Expanded(child: _buildResultsGrid()), // Using GridView for results
        ],
      ),
    );
  }

  /// Filter controls arranged in a Column (for Portrait).
  Widget _buildFilterSectionColumn() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildFromDateField()),
              const SizedBox(width: 5),
              Expanded(child: _buildToDateField()),
            ],
          ),
          const SizedBox(height: 5),
          _buildSearchButton(),
        ],
      ),
    );
  }

  /// Filter controls arranged in a single Row (for Landscape).
  Widget _buildFilterSectionRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: _buildFromDateField()),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: _buildToDateField()),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: _buildSearchButton()),
        ],
      ),
    );
  }

  // --- Reusable Filter Components ---
  Widget _buildFromDateField() {
    return MyTextField(
      readOnly: true,
      controller: _fromDateController,
      labelText: 'من تاريخ',
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100));
        if (pickedDate != null) {
          setState(() {
            _fromDateController.text =
                DateFormat('yyyy-MM-dd').format(pickedDate);
          });
          runBloc(reset: true);
        }
      },
    );
  }

  Widget _buildToDateField() {
    return MyTextField(
      readOnly: true,
      controller: _toDateController,
      labelText: 'إلى تاريخ',
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100));
        if (pickedDate != null) {
          setState(() {
            _toDateController.text =
                DateFormat('yyyy-MM-dd').format(pickedDate);
          });
          runBloc(reset: true);
        }
      },
    );
  }

  Widget _buildSearchButton() {
    return Mybutton(
      text: 'بحث',
      onPressed: () {
        if (_fromDateController.text.isNotEmpty &&
            _toDateController.text.isNotEmpty) {
          runBloc(reset: true);
        }
      },
    );
  }

  /// Common logic for handling Bloc states and building the UI.
  Widget _buildResultsBloc(Widget Function() contentBuilder) {
    return BlocConsumer<OperationsBloc, OperationsState>(
      listener: (context, state) {
        if (state is OperationsSuccess<List<OperationsModel>>) {
          setState(() {
            if (currentPage == 1) {
              _model = state.result;
            } else {
              _model.addAll(state.result);
            }
            isLoadingMore = false;
            isInitialDataLoaded = true;
          });
        } else if (state is OperationsError) {
          setState(() {
            isLoadingMore = false;
          });
        }
      },
      builder: (context, state) {
        if (!isInitialDataLoaded && state is OperationsLoading) {
          return const Center(child: Loader());
        }
        if (state is OperationsError && _model.isEmpty) {
          return Center(child: Text(state.errorMessage));
        }
        if (isInitialDataLoaded && _model.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('لا توجد عمليات لعرضها',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600])),
              ],
            ),
          );
        }
        return contentBuilder();
      },
    );
  }

  /// Builds the results as a ListView.
  Widget _buildResultsList() {
    return _buildResultsBloc(() => _buildOperationsListView());
  }

  /// Builds the results as a GridView.
  Widget _buildResultsGrid() {
    return _buildResultsBloc(() => _buildOperationsGridView());
  }

  /// The ListView builder for operations.
  /// The ListView builder for operations.
  Widget _buildOperationsListView() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      itemCount: _model.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _model.length) {
          return isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: Loader()),
                )
              : const SizedBox.shrink();
        }
        // A variable to hold the type for cleaner code
        final operationType = _model[index].type;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: width, end: 0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.decelerate,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(value, 0),
              child: child,
            );
          },
          child: Card(
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    operationType == 'visit'
                        ? Icons.work_history_outlined
                        : operationType == 'call'
                            ? Icons.call
                            : Icons.error,
                    // --- This is the added line ---
                    color: operationType == 'visit'
                        ? Colors.blueAccent
                        : operationType == 'call'
                            ? Colors.green
                            : Colors.grey,
                  ),
                  Text(_model[index].id.toString()),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(_model[index].customer_name ?? ""),
                  Text(_model[index].shop_name ?? ""),
                ],
              ),
              title: Center(
                child: Text(_model[index].date!),
              ),
              trailing: Text("${_model[index].duration}"),
              onTap: () => _navigateToDetails(_model[index]),
            ),
          ),
        );
      },
    );
  }

  /// NEW: The GridView builder for operations.
  Widget _buildOperationsGridView() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250, // Each item will have a max width of 250
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 4 / 3, // Adjust aspect ratio as needed
      ),
      itemCount: _model.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _model.length) {
          return isLoadingMore
              ? const Center(child: Loader())
              : const SizedBox.shrink();
        }
        return _OperationGridItem(
          model: _model[index],
          onTap: () => _navigateToDetails(_model[index]),
        );
      },
    );
  }

  /// Common navigation logic for both list and grid items.
  void _navigateToDetails(OperationsModel model) {
    if (model.type == 'visit') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewVisitPage(operationsModel: model)),
      );
    } else if (model.type == 'call') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewCallPage(operationsModel: model)),
      );
    }
  }
}

/// NEW: A dedicated widget for displaying an operation in the grid.
class _OperationGridItem extends StatelessWidget {
  final OperationsModel model;
  final VoidCallback onTap;

  const _OperationGridItem({required this.model, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isVisit = model.type == 'visit';
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    isVisit ? Icons.work_history_outlined : Icons.call,
                    color: isVisit ? Colors.blueAccent : Colors.green,
                    size: 20,
                  ),
                  Text(
                    model.id.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        model.customer_name ?? 'N/A',
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        model.shop_name ?? 'N/A',
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                model.date ?? '',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
