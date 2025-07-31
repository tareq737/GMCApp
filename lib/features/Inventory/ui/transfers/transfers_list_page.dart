// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/transfer_brief_model.dart';
import 'package:gmcappclean/features/Inventory/models/transfer_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/transfers/transfer_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class TransfersListPage extends StatelessWidget {
  final int transfer_type;
  const TransfersListPage({
    Key? key,
    required this.transfer_type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>()))
        ..add(
          GetListBriefTransfers(page: 1, transfer_type: transfer_type),
        ),
      child: Builder(builder: (context) {
        return TrasfersListPageChild(
          transfer_type: transfer_type,
        );
      }),
    );
  }
}

class TrasfersListPageChild extends StatefulWidget {
  final int transfer_type;
  const TrasfersListPageChild({
    Key? key,
    required this.transfer_type,
  }) : super(key: key);

  @override
  State<TrasfersListPageChild> createState() => _TrasfersListPageChildState();
}

class _TrasfersListPageChildState extends State<TrasfersListPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<TransferBriefModel> _transferModel = [];
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Builder(builder: (context) {
      return BlocListener<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state is InventoryError) {
            showSnackBar(
                context: context, content: 'حدث خطأ ما', failure: true);
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
                          return TransferPage(
                            transfer_type: widget.transfer_type,
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: Text(
                _getTitleForTransferType(widget.transfer_type),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: BlocConsumer<InventoryBloc, InventoryState>(
              listener: (context, state) {
                if (state is InventoryError) {
                  showSnackBar(
                    context: context,
                    content: 'حدث خطأ ما',
                    failure: true,
                  );
                } else if (state
                    is InventorySuccess<List<TransferBriefModel>>) {
                  setState(
                    () {
                      if (currentPage == 1) {
                        _transferModel = state.result;
                      } else {
                        _transferModel.addAll(state.result);
                      }
                      isLoadingMore = false;
                    },
                  );
                } else if (state is InventorySuccess<TransferModel>) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return TransferPage(
                          transferModel: state.result,
                          transfer_type: widget.transfer_type,
                        );
                      },
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is InventoryInitial) {
                  return const SizedBox();
                } else if (state is InventoryLoading && currentPage == 1) {
                  return const Center(
                    child: Loader(),
                  );
                } else if (state is InventoryError) {
                  return const Center(child: Text('حدث خطأ ما'));
                } else if (_transferModel.isEmpty) {
                  // This is the new condition for empty list
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا توجد بيانات لعرضها',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (_transferModel.isNotEmpty) {
                  return Builder(builder: (context) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: _transferModel.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _transferModel.length) {
                          return isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: Loader()),
                                )
                              : const SizedBox.shrink();
                        }

                        return InkWell(
                          onTap: () {
                            context.read<InventoryBloc>().add(
                                  GetOneTransfer(id: _transferModel[index].id),
                                );
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.teal,
                                    radius: 11,
                                    child: Text(
                                      _transferModel[index].serial.toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 8),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      spacing: 5,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (widget.transfer_type != 101)
                                          Text(
                                            'من: ${_transferModel[index].from_warehouse_name ?? ""}',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        if (widget.transfer_type != 102)
                                          Text(
                                            'إلى: ${_transferModel[index].to_warehouse_name ?? ""}',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        Text(
                                          'البيان: ${_transferModel[index].note ?? ""}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _transferModel[index].date ?? "",
                                    style: const TextStyle(
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  });
                } else if (state is InventoryError) {
                  return const Center(
                    child: Text(
                      'حدث خطأ ما',
                    ),
                  );
                } else {
                  return const Center(
                    child: Loader(),
                  );
                }
              },
            ),
          ),
        ),
      );
    });
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
    context.read<InventoryBloc>().add(
          GetListBriefTransfers(
            page: currentPage,
            transfer_type: 1,
          ),
        );
  }

  String _getTitleForTransferType(int transferType) {
    switch (transferType) {
      case 1:
        return 'إدخال جاهزة';
      case 2:
        return 'إخراج جاهزة';
      case 3:
        return 'إدخال أولية';
      case 4:
        return 'إخراج أولية';
      case 5:
        return 'مناقلة بضاعة أمانة';
      case 6:
        return 'مناقلة مستودع';
      case 7:
        return 'إدخال تعبئة';
      case 8:
        return 'إخراج تعبئة';
      case 101:
        return 'مشتريات';
      case 102:
        return 'مبيعات';
      default:
        return 'المناقلات';
    }
  }
}
