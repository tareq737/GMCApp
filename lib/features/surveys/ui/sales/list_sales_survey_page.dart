import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/api/pageinted_result.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/my_circle_avatar.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/navigate_with_animate.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/surveys/bloc/surveys_bloc.dart';
import 'package:gmcappclean/features/surveys/models/sales/brief_sales_model.dart';
import 'package:gmcappclean/features/surveys/models/sales/sales_model.dart';
import 'package:gmcappclean/features/surveys/services/surveys_services.dart';
import 'package:gmcappclean/features/surveys/ui/sales/sales_survey_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ListSalesSurveyPage extends StatelessWidget {
  const ListSalesSurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveysBloc(
        SurveysServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetSalesSurveys(page: 1)),
      child: const ListSalesSurveyPageChild(),
    );
  }
}

class ListSalesSurveyPageChild extends StatefulWidget {
  const ListSalesSurveyPageChild({super.key});

  @override
  State<ListSalesSurveyPageChild> createState() =>
      _ListSalesSurveyPageChildState();
}

class _ListSalesSurveyPageChildState extends State<ListSalesSurveyPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  bool hasMoreData = true;
  List<BriefSalesModel> _model = [];
  int? count;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        hasMoreData) {
      _loadNextPage();
    }
  }

  void _loadNextPage() {
    if (isLoadingMore || !hasMoreData) return;
    setState(() => isLoadingMore = true);
    currentPage++;
    context.read<SurveysBloc>().add(GetSalesSurveys(page: currentPage));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      const fileName = 'استبيانات المبيعات.xlsx'; // More relevant name
      final path = '${directory.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(bytes);
      await _showDialog('نجاح', 'تم حفظ الملف وسيتم فتحه الآن');
      final result = await OpenFilex.open(path);
      if (result.type != ResultType.done) {
        await _showDialog('خطأ', 'لم يتم فتح الملف: ${result.message}');
      }
    } catch (e) {
      await _showDialog('خطأ', 'فشل حفظ/فتح الملف:\n${e.toString()}');
    }
  }

  Future<void> _showDialog(String title, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
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

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SurveysBloc, SurveysState>(
      listener: (context, state) {
        if (state is SurveysError) {
          isLoadingMore = false;
          showSnackBar(
            context: context,
            content: 'حدث خطأ ما',
            failure: true,
          );
        }
      },
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: FloatingDraggableWidget(
          floatingWidget: FloatingActionButton(
            heroTag: 1,
            mini: true,
            onPressed: () {
              navigateWithAnimate(context, SalesSurveyPage());
            },
            child: const Icon(Icons.add),
          ),
          floatingWidgetWidth: 40,
          floatingWidgetHeight: 40,
          mainScreenWidget: Scaffold(
            appBar: AppBar(
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: Row(
                children: [
                  const Text(
                    'استبيانات المبيعات',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (count != null) MyCircleAvatar(text: count.toString()),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<SurveysBloc>().add(
                          ExportExcelSalesSurvey(),
                        );
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.fileExport,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: BlocConsumer<SurveysBloc, SurveysState>(
              listener: (context, state) async {
                if (state is SurveysSuccess<PageintedResult>) {
                  final result = state.result;
                  count = result.totalCount;

                  if (currentPage == 1) {
                    _model = result.results.cast<BriefSalesModel>();
                    hasMoreData = _model.length < (result.totalCount ?? 0);
                  } else {
                    final newItems = result.results.cast<BriefSalesModel>();
                    if (newItems.isNotEmpty) {
                      _model.addAll(newItems);
                      hasMoreData = _model.length < (result.totalCount ?? 0);
                    } else {
                      hasMoreData = false;
                    }
                  }
                  isLoadingMore = false;
                  setState(() {});
                } else if (state is SurveysSuccess<SalesModel>) {
                  navigateWithAnimate(
                    context,
                    SalesSurveyPage(salesModel: state.result),
                  );
                } else if (state is SurveysSuccess<Uint8List>) {
                  await _saveFile(state.result);
                }
              },
              builder: (context, state) {
                if (state is SurveysLoading && _model.isEmpty) {
                  return const Center(child: Loader());
                }

                if (_model.isEmpty) {
                  return const Center(
                    child: Text('لا توجد استبيانات لعرضها'),
                  );
                }

                return OrientationBuilder(
                  builder: (context, orientation) {
                    if (orientation == Orientation.landscape) {
                      return _buildLandscapeLayout();
                    } else {
                      return _buildPortraitLayout();
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ================= PORTRAIT =================
  Widget _buildPortraitLayout() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _model.length + (hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _model.length) {
          return isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Loader()),
                )
              : const SizedBox.shrink();
        }

        final item = _model[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: ListTile(
            leading: SizedBox(
              width: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  Text(
                    item.region_name ?? '',
                    style: const TextStyle(fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            title: Text(item.customer_name ?? '', textAlign: TextAlign.center),
            subtitle: Column(
              children: [
                Text(item.shop_name ?? ''),
                Text(
                  item.date ?? "",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            onTap: () {
              context.read<SurveysBloc>().add(GetOneSalesSurveys(id: item.id));
            },
          ),
        );
      },
    );
  }

  // ================= LANDSCAPE =================
  Widget _buildLandscapeLayout() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 3.4,
      ),
      itemCount: _model.length + (hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _model.length) {
          return isLoadingMore
              ? const Center(child: Loader())
              : const SizedBox.shrink();
        }

        final item = _model[index];

        return Card(
          child: InkWell(
            onTap: () {
              context.read<SurveysBloc>().add(GetOneSalesSurveys(id: item.id));
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.red),
                        Text(
                          item.region_name ?? '',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item.customer_name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(item.shop_name ?? '',
                            overflow: TextOverflow.ellipsis),
                        Text(
                          item.date ?? "",
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
