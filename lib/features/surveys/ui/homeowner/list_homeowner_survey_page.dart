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
import 'package:gmcappclean/features/surveys/models/homeowner/brief_homeowner_model.dart';
import 'package:gmcappclean/features/surveys/models/homeowner/homeowner_model.dart';
import 'package:gmcappclean/features/surveys/services/surveys_services.dart';
import 'package:gmcappclean/features/surveys/ui/homeowner/homeowner_statistics_page.dart';
import 'package:gmcappclean/features/surveys/ui/homeowner/homeowner_survey_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ListHomeownerSurveyPage extends StatelessWidget {
  const ListHomeownerSurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveysBloc(
        SurveysServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetHomeownerSurveys(page: 1)),
      child: const ListHomeownerSurveyPageChild(),
    );
  }
}

class ListHomeownerSurveyPageChild extends StatefulWidget {
  const ListHomeownerSurveyPageChild({super.key});

  @override
  State<ListHomeownerSurveyPageChild> createState() =>
      _ListHomeownerSurveyPageChildState();
}

class _ListHomeownerSurveyPageChildState
    extends State<ListHomeownerSurveyPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  bool hasMoreData = true;
  List<BriefHomeownerModel> _model = [];
  int? count;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent / 2 &&
        !isLoadingMore) {
      _nextPage();
    }
  }

  void _nextPage() {
    setState(() => isLoadingMore = true);
    currentPage++;
    context.read<SurveysBloc>().add(
          GetHomeownerSurveys(page: currentPage),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveFile(Uint8List bytes) async {
    try {
      final directory = await getTemporaryDirectory();
      const fileName = 'استبيانات صاحب منزل.xlsx'; // More relevant name
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SurveysBloc, SurveysState>(
      listener: (context, state) {
        if (state is SurveysError) {
          isLoadingMore = false;
          showSnackBar(context: context, content: 'حدث خطأ ما', failure: true);
        }
      },
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: FloatingDraggableWidget(
          floatingWidget: FloatingActionButton(
            heroTag: 1,
            mini: true,
            onPressed: () {
              navigateWithAnimate(context, HomeownerSurveyPage());
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
                    'استبيانات صاحب منزل',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  if (count != null) MyCircleAvatar(text: count.toString()),
                ],
              ),
              actions: [
                PopupMenuButton<String>(
                  // Style the 3 dots icon
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    // Handle logic based on which option is clicked
                    if (value == 'export') {
                      context
                          .read<SurveysBloc>()
                          .add(ExportExcelHomeownerSurvey());
                    } else if (value == 'stats') {
                      navigateWithAnimate(
                          context, const HomeownerStatisticsPage());
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    // Option 1: Export
                    const PopupMenuItem<String>(
                      value: 'export',
                      child: ListTile(
                        leading: FaIcon(FontAwesomeIcons.fileExport, size: 18),
                        title: Text('تصدير Excel'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    // Option 2: Statistics
                    const PopupMenuItem<String>(
                      value: 'stats',
                      child: ListTile(
                        leading: FaIcon(FontAwesomeIcons.chartPie, size: 18),
                        title: Text('إحصائيات'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: BlocConsumer<SurveysBloc, SurveysState>(
              listener: (context, state) async {
                if (state is SurveysSuccess<PageintedResult>) {
                  bool shouldRebuildAppBar = false;
                  if (count == null ||
                      currentPage == 1 ||
                      state.result.totalCount! > 0) {
                    shouldRebuildAppBar = count != state.result.totalCount;
                    count = state.result.totalCount;
                  }
                  if (currentPage == 1) {
                    _model = state.result.results.cast<BriefHomeownerModel>();
                  } else {
                    final newResults =
                        state.result.results.cast<BriefHomeownerModel>();
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
                } else if (state is SurveysSuccess<HomeownerModel>) {
                  navigateWithAnimate(
                    context,
                    HomeownerSurveyPage(homeownerModel: state.result),
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
                  return const Center(child: Text('لا توجد استبيانات'));
                }

                return OrientationBuilder(
                  builder: (context, orientation) {
                    return orientation == Orientation.landscape
                        ? _buildLandscape()
                        : _buildPortrait();
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
  Widget _buildPortrait() {
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
                    item.region ?? '',
                    style: const TextStyle(fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            title: Text(item.customer_name ?? '', textAlign: TextAlign.center),
            subtitle: Column(
              children: [
                Text(item.store_name ?? ''),
                Text(
                  "${item.visit_date ?? ""} - ${_formatTime(item.visit_time)}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            onTap: () {
              context
                  .read<SurveysBloc>()
                  .add(GetOneHomeownerSurveys(id: item.id));
            },
          ),
        );
      },
    );
  }

  // ================= LANDSCAPE =================
  Widget _buildLandscape() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 3.5,
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
              context
                  .read<SurveysBloc>()
                  .add(GetOneHomeownerSurveys(id: item.id));
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
                          item.region ?? '',
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
                        Text(item.store_name ?? '',
                            overflow: TextOverflow.ellipsis),
                        Text(
                          "${item.visit_date ?? ""} - ${_formatTime(item.visit_time)}",
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

String _formatTime(String? timeString) {
  if (timeString == null || timeString.isEmpty) return '';
  final parts = timeString.split(':');
  if (parts.length >= 2) {
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
  return timeString;
}
