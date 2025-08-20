import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/purchases/Bloc/purchase_bloc.dart';
import 'package:gmcappclean/features/purchases/Models/brief_purchase_model.dart';
import 'package:gmcappclean/features/purchases/Models/purchases_model.dart';
import 'package:gmcappclean/features/purchases/Services/purchase_service.dart';
import 'package:gmcappclean/features/purchases/UI/general%20purchases/List_for_payment_page.dart';
import 'package:gmcappclean/features/purchases/UI/add_purchase_page.dart';
import 'package:gmcappclean/features/purchases/UI/general%20purchases/full_purchase_details.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PurchasesList extends StatelessWidget {
  final int status;
  const PurchasesList({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PurchaseBloc(
        PurchaseService(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      )..add(GetAllPurchases(page: 1, status: status, department: '')),
      child: Builder(builder: (context) {
        return PurchasesListChild(
          status: status,
        );
      }),
    );
  }
}

class PurchasesListChild extends StatefulWidget {
  final int status;
  const PurchasesListChild({required this.status, super.key});

  @override
  State<PurchasesListChild> createState() => _PurchasesListChildState();
}

class _PurchasesListChildState extends State<PurchasesListChild> {
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool isLoadingMore = false;
  List<BriefPurchaseModel> _briefPurchases = [];
  double width = 0;
  final Map<int, String> _itemStatus = {
    2: 'طلبات بدون ملاحظة المشتريات',
    9: 'طلبات بدون موافقة عرض السعر',
    1: 'الطلبات الغير موافقة من المدير',
    3: 'الطلبات الموافقة من المدير',
    4: 'الطلبات المرفوضة من المدير',
    5: 'الطلبات الموافقة من المدير وغير منفذة',
    6: 'الطلبات الغير مؤرشفة وغير مستلمة',
    7: 'كافة الطلبات الغير مؤرشفة',
    8: 'كافة طلبات المشتريات',
  };
  final List<String> _itemsSection = [
    'الصيانة',
    'الزراعة',
    'العهد',
    'الخدمات',
    'المبيعات',
    'أقسام الإنتاج',
    'IT',
    'شركة النور',
  ];

  late String _selectedStatus;

  String? _selectedItemDepartment;
  List<String>? groups;

  @override
  void initState() {
    super.initState();
    _selectedStatus = _getItemStatusString(widget.status);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    AppUserState state = context.read<AppUserCubit>().state;

    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    width = MediaQuery.of(context).size.width;
    return Builder(builder: (context) {
      return BlocListener<PurchaseBloc, PurchaseState>(
        listener: (context, state) {
          if (state is PurchaseError) {
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
                          return const AddPurchasePage(
                            type: 'general',
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
                if (groups != null &&
                    (groups!.contains('purchase_admins') ||
                        groups!.contains('admins')) &&
                    Platform.isWindows)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      // Handle selection based on the value
                      switch (value) {
                        case 'quotes':
                          // Handle "بحاجة عروض أسعار"
                          context.read<PurchaseBloc>().add(
                                ExportExcelPendingOffers(),
                              );

                          break;
                        case 'purchase':
                          context.read<PurchaseBloc>().add(
                                ExportExcelReadyToBuy(),
                              );
                          break;
                        case 'payment':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ListForPaymentPage()),
                          );
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'quotes', // Unique value for this item
                        child: ListTile(
                          leading: Icon(Icons.call),
                          title: Text('بحاجة عروض أسعار'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'purchase', // Unique value for this item
                        child: ListTile(
                          leading: Icon(Icons.shopping_cart_outlined),
                          title: Text('بحاجة شراء'),
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'payment', // Unique value for this item
                        child: ListTile(
                          leading: Icon(Icons.attach_money),
                          title: Text('أمر الصرف'),
                        ),
                      ),
                    ],
                  ),
              ],
              backgroundColor:
                  isDark ? AppColors.gradient2 : AppColors.lightGradient2,
              title: const Text(
                'طلبات مشتريات عام',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Dropdown for Status
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.teal.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          hint: Text(
                            'الحالة',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade200
                                  : Colors.teal.shade700,
                            ),
                          ),
                          value: _selectedStatus,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              // Add null check
                              setState(() {
                                currentPage = 1;
                                _selectedStatus = newValue;
                              });
                              _briefPurchases = [];
                              runBloc();
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: _itemStatus.values
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey.shade200
                                        : Colors.teal.shade700,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dropdown for Section
                      Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800
                              : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                hint: Text(
                                  'القسم',
                                  style: TextStyle(
                                      color: isDark
                                          ? Colors.grey.shade200
                                          : Colors.orange.shade700),
                                ),
                                value: _selectedItemDepartment,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    currentPage = 1;
                                    _selectedItemDepartment = newValue;
                                  });
                                  _briefPurchases = [];
                                  runBloc();
                                },
                                isExpanded: true,
                                underline:
                                    const SizedBox(), // Remove the default underline
                                items: _itemsSection
                                    .map<DropdownMenuItem<String>>(
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
                                                : Colors.orange
                                                    .shade700), // Dropdown text color
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            if (_selectedItemDepartment !=
                                null) // Show clear button only if a value is selected
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedItemDepartment = null;
                                  });
                                  _briefPurchases = [];
                                  runBloc();
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SearchRow(
                          textEditingController: _searchController,
                          onSearch: () {
                            _briefPurchases = [];
                            runBlocSearch();
                          })
                    ],
                  ),
                ),
                Expanded(
                  flex: 14,
                  child: BlocConsumer<PurchaseBloc, PurchaseState>(
                    listener: (context, state) async {
                      if (state is PurchaseError) {
                        showSnackBar(
                          context: context,
                          content: 'حدث خطأ ما',
                          failure: true,
                        );
                      } else if (state
                          is PurchaseSuccess<List<BriefPurchaseModel>>) {
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
                          },
                        );
                      } else if (state is PurchaseSuccess<PurchasesModel>) {
                        int statusID = _getItemStatusID();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FullPurchaseDetails(
                                purchasesModel: state.result,
                                status: statusID,
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
                                'لا توجد طلبات مشتريات لعرضها',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (_briefPurchases.isNotEmpty) {
                        return Builder(builder: (context) {
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
                                    : const SizedBox
                                        .shrink(); // Empty space when not loading more data
                              }

                              final screenWidth =
                                  MediaQuery.of(context).size.width;
                              return InkWell(
                                onTap: () {
                                  context.read<PurchaseBloc>().add(
                                        GetOnePurchase(
                                            id: _briefPurchases[index].id),
                                      );
                                },
                                child: TweenAnimationBuilder<double>(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  (_briefPurchases[index]
                                                                  .last_price ??
                                                              "")
                                                          .isNotEmpty
                                                      ? Icons.check
                                                      : Icons.close,
                                                  color: (_briefPurchases[index]
                                                                  .last_price ??
                                                              "")
                                                          .isNotEmpty
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 15,
                                                ),
                                                Icon(
                                                  _briefPurchases[index]
                                                              .manager_check ==
                                                          true
                                                      ? Icons
                                                          .check // ✅ If true, show check mark
                                                      : _briefPurchases[index]
                                                                  .manager_check ==
                                                              false
                                                          ? Icons.close
                                                          : Icons
                                                              .stop_circle_outlined,
                                                  color: _briefPurchases[index]
                                                              .manager_check ==
                                                          true
                                                      ? Colors.green
                                                      : _briefPurchases[index]
                                                                  .manager_check ==
                                                              false
                                                          ? Colors.red
                                                          : Colors.grey,
                                                  size: 15,
                                                ),
                                                Icon(
                                                  (_briefPurchases[index]
                                                              .received_check ==
                                                          true)
                                                      ? Icons.check
                                                      : Icons.close,
                                                  color: (_briefPurchases[index]
                                                              .received_check ==
                                                          true)
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 15,
                                                ),
                                                Icon(
                                                  (_briefPurchases[index]
                                                              .archived ==
                                                          true)
                                                      ? Icons.check
                                                      : Icons.close,
                                                  color: (_briefPurchases[index]
                                                              .archived ==
                                                          true)
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 15,
                                                ),
                                                Icon(
                                                  (_briefPurchases[index]
                                                              .bill
                                                              ?.isNotEmpty ??
                                                          false)
                                                      ? Icons.check
                                                      : Icons.close,
                                                  color: (_briefPurchases[index]
                                                              .bill
                                                              ?.isNotEmpty ??
                                                          false)
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                            Text(_briefPurchases[index]
                                                    .insert_date ??
                                                '')
                                          ],
                                        ),
                                      ),
                                      subtitle: SizedBox(
                                          width: screenWidth * 0.6,
                                          child: Text(
                                            _briefPurchases[index].details ??
                                                "",
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                          )),
                                      leading: SizedBox(
                                        width: screenWidth * 0.10,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Colors.teal,
                                              radius: 11,
                                              child: Text(
                                                _briefPurchases[index]
                                                    .id
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8),
                                              ),
                                            ),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                _briefPurchases[index]
                                                        .department ??
                                                    "",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 8),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                      } else if (state is PurchaseError) {
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
              ],
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
    if (_searchController.text == "") {
      runBloc();
    } else {
      runBlocSearch();
    }
  }

  int _getItemStatusID() {
    // Find the entry in the _itemStatus map where the value matches _selectedItemStatus
    var entry = _itemStatus.entries.firstWhere(
      (entry) => entry.value == _selectedStatus,
      orElse: () =>
          const MapEntry(-1, ''), // Default entry if no match is found
    );

    // If a matching entry is found, return its key (status ID)
    if (entry.key != -1) {
      return entry.key;
    }

    // If no matching entry is found, return null
    return 1;
  }

  String _getItemStatusString(int statusID) {
    return _itemStatus[statusID] ?? '';
  }

  void runBloc() {
    int statusID = _getItemStatusID();
    context.read<PurchaseBloc>().add(
          GetAllPurchases(
              page: currentPage,
              status: statusID,
              department: _selectedItemDepartment ?? ''),
        );
  }

  void runBlocSearch() {
    context.read<PurchaseBloc>().add(
          SearchPurchases(page: currentPage, search: _searchController.text),
        );
  }
}

Future<void> _saveFile(Uint8List bytes, BuildContext context) async {
  try {
    final directory = await getTemporaryDirectory();

    const fileName = 'تقرير مشتريات.xlsx';
    final path = '${directory.path}\\$fileName';

    final file = File(path);
    await file.writeAsBytes(bytes);

    await _showDialog(context, 'نجاح', 'تم حفظ الملف وسيتم فتحه الآن');

    // Open the file
    final result = await OpenFilex.open(path);

    if (result.type != ResultType.done) {
      await _showDialog(
          context, 'Error', 'لم يتم فتح الملف: ${result.message}');
    }
  } catch (e) {
    await _showDialog(context, 'Error', 'Failed to save/open file:\n$e');
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
          onPressed: () => Navigator.of(context).pop(), // Close the dialog
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
