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
import 'package:gmcappclean/features/surveys/models/painters_model.dart';
import 'package:gmcappclean/features/surveys/services/surveys_services.dart';
import 'package:gmcappclean/features/surveys/ui/Painters/painters_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class PaintersList extends StatelessWidget {
  const PaintersList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveysBloc(
        SurveysServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetPainters(page: 1)),
      child: const PaintersListChild(),
    );
  }
}

class PaintersListChild extends StatefulWidget {
  const PaintersListChild({super.key});

  @override
  State<PaintersListChild> createState() => _PaintersListChildState();
}

class _PaintersListChildState extends State<PaintersListChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  bool hasMoreData = true;
  List<PaintersModel> _model = [];
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
    context.read<SurveysBloc>().add(GetPainters(page: currentPage));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              navigateWithAnimate(context, PaintersPage());
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
                    'أرقام الدهانة',
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
            ),
            body: BlocConsumer<SurveysBloc, SurveysState>(
              listener: (context, state) {
                if (state is SurveysSuccess<PageintedResult>) {
                  final result = state.result;
                  count = result.totalCount;

                  if (currentPage == 1) {
                    _model = result.results.cast<PaintersModel>();
                    hasMoreData = _model.length < (result.totalCount ?? 0);
                  } else {
                    final newItems = result.results.cast<PaintersModel>();
                    if (newItems.isNotEmpty) {
                      _model.addAll(newItems);
                      hasMoreData = _model.length < (result.totalCount ?? 0);
                    } else {
                      hasMoreData = false;
                    }
                  }
                  isLoadingMore = false;
                  setState(() {});
                } else if (state is SurveysSuccess<PaintersModel>) {
                  navigateWithAnimate(
                    context,
                    PaintersPage(paintersModel: state.result),
                  );
                }
              },
              builder: (context, state) {
                if (state is SurveysLoading && _model.isEmpty) {
                  return const Center(child: Loader());
                }

                if (_model.isEmpty) {
                  return const Center(
                    child: Text('لا توجد أرقام لعرضها'),
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
            leading: const Icon(Icons.location_on, color: Colors.red),
            title: Text(
              item.painter_name ?? '',
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              item.mobile_number ?? '',
              textAlign: TextAlign.center,
            ),
            onTap: () {
              context.read<SurveysBloc>().add(GetOnePainter(id: item.id));
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
              context.read<SurveysBloc>().add(GetOnePainter(id: item.id));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.paintRoller,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item.painter_name ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.mobile_number ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.region ?? '',
                          style: const TextStyle(fontSize: 12),
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
