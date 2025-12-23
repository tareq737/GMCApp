import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Exchange%20Rate/bloc/exchange_rate_bloc.dart';
import 'package:gmcappclean/features/Exchange%20Rate/models/rate_model.dart';
import 'package:gmcappclean/features/Exchange%20Rate/services/rate_service.dart';
import 'package:gmcappclean/features/Exchange%20Rate/ui/rate_chart_page.dart';
import 'package:gmcappclean/features/Exchange%20Rate/ui/rate_details_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class RateListPage extends StatelessWidget {
  const RateListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterday = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 1)));
    return BlocProvider(
      create: (context) => ExchangeRateBloc(
        RateService(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetAllRatesForDate(
          start: yesterday,
          end: today,
          details: false,
          page: 1,
        )),
      child: Builder(builder: (context) {
        return const RateListPageChild();
      }),
    );
  }
}

class RateListPageChild extends StatefulWidget {
  const RateListPageChild({super.key});

  @override
  State<RateListPageChild> createState() => _RateListPageChildState();
}

class _RateListPageChildState extends State<RateListPageChild> {
  int? selectedIndex; // Track the selected index
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  bool? details = false;
  bool isLoadingMore = false;
  List<RateModel> resultList = [];
  double width = 0;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fromDateController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 1)));

    _toDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    AppUserState state = context.read<AppUserCubit>().state;
    List<String>? groups;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: FloatingDraggableWidget(
        floatingWidget: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (
                  context,
                ) {
                  return RateChartPage(
                    date1: _fromDateController.text,
                    date2: _toDateController.text,
                  );
                },
              ),
            );
          },
          mini: true,
          child: const Icon(Icons.show_chart),
        ),
        floatingWidgetWidth: 40,
        floatingWidgetHeight: 40,
        mainScreenWidget: Scaffold(
          appBar: AppBar(
            actions: [
              BlocBuilder<ExchangeRateBloc, ExchangeRateState>(
                builder: (context, state) {
                  if (state is NewRatesLoading) {
                    return const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Loader(),
                      ),
                    );
                  }
                  return IconButton(
                    onPressed: () {
                      runBlocGetNewRates();
                    },
                    icon: const Icon(Icons.refresh),
                  );
                },
              )
            ],
            title: const Row(
              children: [
                Text(
                  'أسعار الصرف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.monetization_on,
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade500,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              readOnly: true,
                              controller: _fromDateController,
                              labelText: 'من تاريخ',
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    _fromDateController.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                  });
                                  resultList = [];
                                  currentPage = 1;
                                  runBloc();
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: MyTextField(
                              readOnly: true,
                              controller: _toDateController,
                              labelText: 'إلى تاريخ',
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    _toDateController.text =
                                        DateFormat('yyyy-MM-dd')
                                            .format(pickedDate);
                                  });
                                  resultList = [];
                                  currentPage = 1;
                                  runBloc();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: Text(
                                (details ?? false) ? 'تفصيلي' : 'تجميعي',
                                style: const TextStyle(fontSize: 12),
                              ),
                              value: details,
                              onChanged: (bool? value) {
                                setState(() {
                                  details = value;
                                });
                                resultList = [];
                                currentPage = 1;
                                runBloc();
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Expanded(
                            child: Mybutton(
                              text: 'بحث',
                              onPressed: () {
                                if (_fromDateController.text.isNotEmpty &&
                                    _toDateController.text.isNotEmpty) {
                                  context.read<ExchangeRateBloc>().add(
                                        GetAllRatesForDate(
                                          start: _fromDateController.text,
                                          end: _toDateController.text,
                                          details: details ?? false,
                                          page: 1,
                                        ),
                                      );
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                BlocConsumer<ExchangeRateBloc, ExchangeRateState>(
                  listener: (context, state) {
                    if (state is RatesError) {
                      showSnackBar(
                        context: context,
                        content: 'حدث خطأ ما',
                        failure: true,
                      );
                    } else if (state is RatesSuccess<String>) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          if (state.result == 'No new data to store.') {
                            showSnackBar(
                              context: context,
                              content: 'لا يوجد سعر جديد',
                              failure: true,
                            );
                          }
                          if (state.result == 'New data fetched and stored.') {
                            showSnackBar(
                              context: context,
                              content: 'تم تجديد السعر',
                              failure: false,
                            );
                            // Refresh the data
                            resultList = [];
                            currentPage = 1;
                            runBloc();
                          }
                        },
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is RatesLoading && currentPage == 1) {
                      return const Loader();
                    } else if (state is RatesSuccess<List<RateModel>>) {
                      if (currentPage == 1) {
                        resultList = state.result;
                      } else {
                        resultList.addAll(state.result);
                      }
                      isLoadingMore = false;

                      return _buildRateList(context, state.result);
                    } else {
                      return _buildRateList(context, resultList);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for a single rate item to avoid code duplication
  Widget _buildRateItem(int index) {
    // Helper function to get trend icon for a field
    Icon getTrendIcon(String? todayVal, String? yesterdayVal) {
      final today = double.tryParse(todayVal ?? '0') ?? 0;
      final yesterday = double.tryParse(yesterdayVal ?? '0') ?? 0;

      if (today > yesterday) {
        return const Icon(Icons.arrow_upward, color: Colors.green, size: 16);
      } else if (today < yesterday) {
        return const Icon(Icons.arrow_downward, color: Colors.red, size: 16);
      } else {
        return const Icon(Icons.remove, color: Colors.grey, size: 16);
      }
    }

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
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Euro column
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '€: ${formatValue(resultList[index].euro_buy)}',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      if (index < resultList.length - 1)
                        getTrendIcon(resultList[index].euro_buy,
                            resultList[index + 1].euro_buy),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '€: ${formatValue(resultList[index].euro_sell)}',
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      if (index < resultList.length - 1)
                        getTrendIcon(resultList[index].euro_sell,
                            resultList[index + 1].euro_sell),
                    ],
                  ),
                ],
              ),

              // Date + time
              Column(
                children: [
                  Text(
                    resultList[index].date,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    resultList[index].time,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),

              // Dollar column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        '\$: ${formatValue(resultList[index].usd_buy)}',
                        style:
                            const TextStyle(color: Colors.green, fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      if (index < resultList.length - 1)
                        getTrendIcon(resultList[index].usd_buy,
                            resultList[index + 1].usd_buy),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '\$: ${formatValue(resultList[index].usd_sell)}',
                        style:
                            const TextStyle(color: Colors.green, fontSize: 14),
                      ),
                      const SizedBox(width: 4),
                      if (index < resultList.length - 1)
                        getTrendIcon(resultList[index].usd_sell,
                            resultList[index + 1].usd_sell),
                    ],
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RateDetailsPage(rateModel: resultList[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  // Main list/grid building widget
  Widget _buildRateList(BuildContext context, List<RateModel> rateModel) {
    return Expanded(
      child: RefreshIndicator(
        color: Colors.blue,
        onRefresh: () async {
          await runBlocGetNewRates();
        },
        child: OrientationBuilder(
          builder: (context, orientation) {
            // Display GridView in landscape mode
            if (orientation == Orientation.landscape) {
              return GridView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: resultList.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns in landscape
                  childAspectRatio: 4, // Adjust for better item appearance
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  if (index == resultList.length) {
                    return isLoadingMore
                        ? const Center(child: Loader())
                        : const SizedBox.shrink();
                  }
                  return _buildRateItem(index);
                },
              );
            }
            // Display ListView in portrait mode (default)
            else {
              return ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: resultList.length + 1,
                itemBuilder: (context, index) {
                  if (index == resultList.length) {
                    return isLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: Loader()),
                          )
                        : const SizedBox.shrink();
                  }
                  return _buildRateItem(index);
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _onScroll() {
    // Calculate the halfway point
    double halfwayPoint = _scrollController.position.maxScrollExtent / 2;

    // Check if the current scroll position is at or beyond the halfway point
    if (_scrollController.position.pixels >= halfwayPoint && !isLoadingMore) {
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

  void runBloc() {
    context.read<ExchangeRateBloc>().add(
          GetAllRatesForDate(
            start: _fromDateController.text,
            end: _toDateController.text,
            details: details ?? false,
            page: currentPage,
          ),
        );
  }

  Future<void> runBlocGetNewRates() async {
    context.read<ExchangeRateBloc>().add(GetNewRates());
    runBloc();
  }

  final formatter = NumberFormat.decimalPattern();

  String formatValue(String? value) {
    if (value == null || value.isEmpty) return '';
    final num = double.tryParse(value);
    if (num == null) return value;
    return formatter.format(num.round());
  }
}
