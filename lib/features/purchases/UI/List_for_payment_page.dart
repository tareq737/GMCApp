import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui; // Alias for disambiguation

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/purchases/Bloc/purchase_bloc.dart';
import 'package:gmcappclean/features/purchases/Models/for_payments_model.dart';
import 'package:gmcappclean/features/purchases/Models/purchases_model.dart';
import 'package:gmcappclean/features/purchases/Services/purchase_service.dart';
import 'package:gmcappclean/features/purchases/UI/full_purchase_details.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ListForPaymentPage extends StatefulWidget {
  const ListForPaymentPage({super.key});

  @override
  State<ListForPaymentPage> createState() => _ListForPaymentPageState();
}

class _ListForPaymentPageState extends State<ListForPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchaseBloc(
        PurchaseService(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(
          GetListForPayment(page: 1),
        ),
      child: Builder(builder: (context) {
        return const ListForPayaymentPageChild();
      }),
    );
  }
}

class ListForPayaymentPageChild extends StatefulWidget {
  const ListForPayaymentPageChild({super.key});

  @override
  State<ListForPayaymentPageChild> createState() =>
      _ListForPayaymentPageChildState();
}

class _ListForPayaymentPageChildState extends State<ListForPayaymentPageChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;
  List<ForPaymentsModel> _briefPurchases = [];

  // No need for 'check' if using selectedIds.contains logic
  // bool check = false;

  List<int> selectedIds = [];

  // New variable to track the "check all" state
  bool _checkAll = false;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // --- Add this new method to handle "Check All" functionality ---
  void _toggleCheckAll(bool value) {
    setState(() {
      _checkAll = value;
      if (_checkAll) {
        // If "Check All" is true, add all current briefPurchases IDs to selectedIds
        selectedIds = _briefPurchases.map((purchase) => purchase.id).toList();
      } else {
        // If "Check All" is false, clear all selected IDs
        selectedIds.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocListener<PurchaseBloc, PurchaseState>(
      listener: (context, state) {
        if (state is PurchaseError) {
          showSnackBar(context: context, content: 'حدث خطأ ما', failure: true);
        }
      },
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:
                isDark ? AppColors.gradient2 : AppColors.lightGradient2,
            title: const Text(
              'طلبات الشراء',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              // New "Check All" button
              IconButton(
                onPressed: () {
                  _toggleCheckAll(!_checkAll); // Toggle the checkAll state
                },
                icon: Icon(
                  _checkAll
                      ? FontAwesomeIcons
                          .solidSquareCheck // Filled checkbox icon when all are checked
                      : FontAwesomeIcons
                          .square, // Empty checkbox icon when not all are checked
                  color: Colors.white,
                ),
                tooltip: _checkAll ? 'إلغاء تحديد الكل' : 'تحديد الكل',
              ),
              IconButton(
                onPressed: () {
                  print("Selected IDs: $selectedIds");
                  context.read<PurchaseBloc>().add(
                        ExportExcelForPayment(ids: selectedIds),
                      );
                },
                icon: const FaIcon(FontAwesomeIcons.fileExport,
                    color: Colors.white),
                tooltip: 'تصدير المحدد إلى Excel',
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocConsumer<PurchaseBloc, PurchaseState>(
                  listener: (context, state) async {
                    if (state is PurchaseError) {
                      showSnackBar(
                        context: context,
                        content: 'حدث خطأ ما',
                        failure: true,
                      );
                    } else if (state
                        is PurchaseSuccess<List<ForPaymentsModel>>) {
                      setState(
                        () {
                          if (currentPage == 1) {
                            _briefPurchases =
                                state.result; // First page, replace data
                          } else {
                            _briefPurchases
                                .addAll(state.result); // Append new data
                          }
                          isLoadingMore = false;

                          // After new data arrives, check if 'check all' state needs adjustment
                          // If 'check all' was true, and new items loaded, add them too.
                          // If all items are selected by checkbox, update _checkAll flag
                          if (_briefPurchases.isNotEmpty &&
                              selectedIds.length == _briefPurchases.length) {
                            _checkAll = true;
                          } else {
                            _checkAll = false;
                          }
                        },
                      );
                    } else if (state is PurchaseSuccess<PurchasesModel>) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FullPurchaseDetails(
                              purchasesModel: state.result,
                              status: 7,
                            );
                          },
                        ),
                      );
                    } else if (state is PurchaseSuccess<Uint8List>) {
                      await _saveFile(state.result, context);
                    }
                  },
                  builder: (context, state) {
                    if (state is PurchaseInitial) {
                      return const SizedBox();
                    } else if (state is PurchaseLoading && currentPage == 1) {
                      return const Center(
                        child: Loader(),
                      );
                    } else if (state is PurchaseError) {
                      return const Center(child: Text('حدث خطأ ما'));
                    } else if (_briefPurchases.isEmpty) {
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
                              'لا توجد طلبات شراء لعرضها',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (_briefPurchases.isNotEmpty) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: _briefPurchases.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _briefPurchases.length) {
                            return isLoadingMore
                                ? const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(child: Loader()),
                                  )
                                : const SizedBox.shrink();
                          }

                          final screenWidth = MediaQuery.of(context).size.width;
                          return InkWell(
                            onLongPress: () {
                              context.read<PurchaseBloc>().add(
                                    GetOnePurchase(
                                        id: _briefPurchases[index].id),
                                  );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                title: SizedBox(
                                  width: screenWidth * 0.20,
                                  child: Text(
                                    _briefPurchases[index].type ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: screenWidth * 0.25,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(_briefPurchases[index].price ?? ''),
                                      Text(_briefPurchases[index].insert_date ??
                                          '')
                                    ],
                                  ),
                                ),
                                subtitle: SizedBox(
                                    width: screenWidth * 0.6,
                                    child: Text(
                                      _briefPurchases[index].details ?? "",
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    )),
                                leading: SizedBox(
                                  width: screenWidth *
                                      0.15, // Adjusted width for better fit
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Checkbox(
                                          value: selectedIds.contains(
                                              _briefPurchases[index].id),
                                          onChanged: (bool? value) {
                                            setState(() {
                                              int id =
                                                  _briefPurchases[index].id;
                                              if (value == true) {
                                                selectedIds.add(id);
                                              } else {
                                                selectedIds.remove(id);
                                              }
                                              // Update _checkAll flag based on current selection
                                              _checkAll = _briefPurchases
                                                      .isNotEmpty &&
                                                  selectedIds.length ==
                                                      _briefPurchases.length;
                                            });
                                          },
                                          checkColor: Colors.white,
                                          activeColor: Colors.green,
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          _briefPurchases[index].id.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Loader(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    double halfwayPoint = _scrollController.position.maxScrollExtent / 2;

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
    context.read<PurchaseBloc>().add(
          GetListForPayment(
            page: currentPage,
          ),
        );
  }

  // Future<void> _saveFile(Uint8List bytes, BuildContext context) async {
  //   try {
  //     final directory = await getTemporaryDirectory();

  //     const fileName = 'طلبات مشتريات بحاجة شراء.xlsx';
  //     final path = '${directory.path}/$fileName'; // Use '/' for path separator

  //     final file = File(path);
  //     await file.writeAsBytes(bytes);

  //     await _showDialog(context, 'نجاح', 'تم حفظ الملف وسيتم فتحه الآن');

  //     final result = await OpenFilex.open(path);

  //     if (result.type != ResultType.done) {
  //       await _showDialog(
  //           context, 'خطأ', 'لم يتم فتح الملف: ${result.message}');
  //     }
  //   } catch (e) {
  //     await _showDialog(context, 'خطأ', 'فشل في حفظ/فتح الملف:\n$e');
  //   }
  // }
  Future<void> _saveFile(Uint8List bytes, BuildContext context) async {
    try {
      const String fileName = 'أمر الصرف.xlsx';

      // Show the dialog
      final FileSaveLocation? location = await getSaveLocation(
        suggestedName: fileName,
        acceptedTypeGroups: [
          const XTypeGroup(label: 'Excel', extensions: ['xlsx']),
        ],
      ); // returns null if user pressed “Cancel”

      if (location == null) return;

      // Write the bytes
      final XFile xFile = XFile.fromData(
        bytes,
        name: fileName,
        mimeType:
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
      await xFile.saveTo(location.path);

      await _showDialog(
        context,
        'نجاح',
        'تم حفظ الملف في:\n${location.path}',
      );
    } catch (e) {
      await _showDialog(context, 'خطأ', 'فشل في حفظ الملف:\n$e');
    }
  }

  Future<void> _showDialog(BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
