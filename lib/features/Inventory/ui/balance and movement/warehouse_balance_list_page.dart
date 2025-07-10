import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/balance_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/warehouses_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class WarehouseBalanceListPage extends StatelessWidget {
  const WarehouseBalanceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(
        InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      ),
      child: const WarehouseBalanceListPageChild(),
    );
  }
}

class WarehouseBalanceListPageChild extends StatefulWidget {
  const WarehouseBalanceListPageChild({super.key});

  @override
  State<WarehouseBalanceListPageChild> createState() =>
      _WarehouseBalanceListPageChildState();
}

class _WarehouseBalanceListPageChildState
    extends State<WarehouseBalanceListPageChild> {
  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _warehouseController = TextEditingController();
  final _itemController = TextEditingController();
  final _warehouseFocusNode = FocusNode();
  final _itemFocusNode = FocusNode();
  int? _selectedWarehouseId;
  int? _selectedItemId;
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  bool _isSearchingWarehouse = false;
  bool _isSearchingItem = false;
  List<BalanceModel> _balanceList = [];

  @override
  void initState() {
    super.initState();
    _fromDateController.text = '2000-01-01';
    _toDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _warehouseFocusNode.addListener(_onWarehouseFocusChange);
    _itemFocusNode.addListener(_onItemFocusChange);
  }

  @override
  void dispose() {
    _fromDateController.dispose();
    _toDateController.dispose();
    _warehouseController.dispose();
    _warehouseFocusNode.removeListener(_onWarehouseFocusChange);
    _warehouseFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onWarehouseFocusChange() {
    if (!_warehouseFocusNode.hasFocus && _warehouseController.text.isNotEmpty) {
      setState(() {
        _isSearchingWarehouse = true;
      });
      context.read<InventoryBloc>().add(
            SearchWarehouse(
              search: _warehouseController.text,
              page: 1,
            ),
          );
    } else if (!_warehouseFocusNode.hasFocus &&
        _warehouseController.text.isEmpty) {
      setState(() {
        _selectedWarehouseId = null;
      });
    }
  }

  void _handleWarehouseSearchResults(
    BuildContext context,
    List<WarehousesModel> results,
  ) {
    if (results.length == 1) {
      final selectedWarehouse = results.first;
      setState(() {
        _warehouseController.text =
            '${selectedWarehouse.code ?? ''}-${selectedWarehouse.name ?? ''}';
        _selectedWarehouseId = selectedWarehouse.id;
      });
      FocusScope.of(context).unfocus();
    } else if (results.length > 1) {
      _showWarehouseSelectionDialog(context, results);
    } else {
      _warehouseController.clear();
      setState(() {
        _selectedWarehouseId = null;
      });
      showSnackBar(
        context: context,
        content: 'لم يتم العثور على مستودعات مطابقة.',
        failure: true,
      );
    }
  }

  void _showWarehouseSelectionDialog(
    BuildContext context,
    List<WarehousesModel> warehouses,
  ) async {
    final selectedFromWarehouse = await showDialog<WarehousesModel>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختر المستودع'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: warehouses.length,
                itemBuilder: (BuildContext context, int index) {
                  final Warehouse = warehouses[index];
                  return ListTile(
                    title: Text(Warehouse.name ?? ''),
                    subtitle: Text(Warehouse.code ?? ''),
                    onTap: () {
                      Navigator.pop(context, Warehouse);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (selectedFromWarehouse != null) {
      setState(() {
        _warehouseController.text =
            '${selectedFromWarehouse.code ?? ''}-${selectedFromWarehouse.name ?? ''}';
        _selectedWarehouseId = selectedFromWarehouse.id;
      });
      FocusScope.of(context).unfocus();
    } else {
      setState(() {
        _warehouseController.clear();
        _selectedWarehouseId = null;
      });
    }
  }

  void _fetchInitialBalanceList(BuildContext context) {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
      _balanceList = [];
    });

    context.read<InventoryBloc>().add(
          GetWarehouseBalance(
            date_1: _fromDateController.text,
            date_2: _toDateController.text,
            warehouse_id: _selectedWarehouseId,
            item_id: _selectedItemId,
            page: _currentPage,
          ),
        );
  }

  void _fetchMore(BuildContext context) {
    if (_isFetchingMore || !_hasMore) return;

    _isFetchingMore = true;
    _currentPage += 1;

    context.read<InventoryBloc>().add(
          GetWarehouseBalance(
            date_1: _fromDateController.text,
            date_2: _toDateController.text,
            warehouse_id: _selectedWarehouseId!,
            page: _currentPage,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Text('جرد'),
              SizedBox(width: 10),
              Icon(Icons.warehouse),
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
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
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
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    MyTextField(
                      controller: _warehouseController,
                      labelText: 'المستودع',
                      focusNode: _warehouseFocusNode,
                    ),
                    const SizedBox(height: 5),
                    MyTextField(
                      controller: _itemController,
                      labelText: 'المادة',
                      focusNode: _itemFocusNode,
                    ),
                    const SizedBox(height: 5),
                    _isSearchingWarehouse && _isSearchingItem
                        ? const Loader()
                        : Mybutton(
                            text: 'بحث',
                            onPressed: () {
                              if (_fromDateController.text.isNotEmpty &&
                                  _toDateController.text.isNotEmpty) {
                                _fetchInitialBalanceList(context);
                              } else {
                                showSnackBar(
                                  context: context,
                                  content:
                                      'يرجى إدخال التواريخ واختيار مستودع.',
                                  failure: true,
                                );
                              }
                            },
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              BlocListener<InventoryBloc, InventoryState>(
                listener: (context, state) {
                  if (state is InventoryLoading) {
                    //_isSearchingWarehouse = true;
                  }

                  if (state is InventorySuccess<List<WarehousesModel>>) {
                    _isSearchingWarehouse = false;
                    _handleWarehouseSearchResults(context, state.result);
                  } else if (state is InventorySuccess<List<ItemsModel>>) {
                    _isSearchingItem = false;
                    _isItemSearchInProgress = false; // Add this
                    _handleItemSearchResults(context, state.result);
                  } else if (state is InventorySuccess<List<BalanceModel>>) {
                    if (_currentPage == 1) {
                      _balanceList = state.result;
                    } else {
                      _balanceList.addAll(state.result);
                    }

                    if (state.result.length < 20) {
                      _hasMore = false;
                    }

                    _isFetchingMore = false;
                    _isSearchingWarehouse = false;
                    setState(() {});
                  } else if (state is InventoryError) {
                    showSnackBar(
                      context: context,
                      content: 'فشل تحميل البيانات',
                      failure: true,
                    );
                    _isFetchingMore = false;
                    _isSearchingWarehouse = false;
                    _isSearchingItem = false;
                    _isItemSearchInProgress = false; // Add this
                  }
                  setState(() {});
                },
                child: Expanded(
                  child: _balanceList.isEmpty
                      ? const SizedBox()
                      : NotificationListener<ScrollNotification>(
                          onNotification: (scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent &&
                                !_isFetchingMore) {
                              _fetchMore(context);
                            }
                            return false;
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _balanceList.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index < _balanceList.length) {
                                final item = _balanceList[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                      '${item.item_name ?? ''} - ${item.unit ?? ''}',
                                      style: TextStyle(
                                        color: item.quantity < 0
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                    subtitle: Text(
                                      item.warehouse_name ?? '',
                                      style: TextStyle(
                                        color: item.quantity < 0
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                    trailing: Text(
                                      item.quantity.toString(),
                                      style: TextStyle(
                                        color: item.quantity < 0
                                            ? Colors.red
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Center(child: Loader()),
                                );
                              }
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isItemSearchInProgress = false;

  void _onItemFocusChange() {
    if (!_itemFocusNode.hasFocus && _itemController.text.isNotEmpty) {
      if (!_isItemSearchInProgress) {
        setState(() {
          _isSearchingItem = true;
          _isItemSearchInProgress = true;
        });
        context.read<InventoryBloc>().add(
              SearchItems(
                search: _itemController.text,
                page: 1,
              ),
            );
      }
    } else if (!_itemFocusNode.hasFocus && _itemController.text.isEmpty) {
      setState(() {
        _selectedItemId = null;
      });
    }
  }

  void _handleItemSearchResults(
    BuildContext context,
    List<ItemsModel> results,
  ) {
    _isItemSearchInProgress = false;

    if (results.length == 1) {
      final selectedItem = results.first;
      setState(() {
        _itemController.text =
            '${selectedItem.code ?? ''}-${selectedItem.name ?? ''}';
        _selectedItemId = selectedItem.id;
      });
      FocusScope.of(context).unfocus();
    } else if (results.length > 1) {
      _showItemsSelectionDialog(context, results);
    } else {
      _itemController.clear();
      setState(() {
        _selectedItemId = null;
      });
      showSnackBar(
        context: context,
        content: 'لم يتم العثور على مواد مطابقة.',
        failure: true,
      );
    }
  }

  void _showItemsSelectionDialog(
    BuildContext context,
    List<ItemsModel> items,
  ) async {
    final selectedItems = await showDialog<ItemsModel>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختر المادة'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final selectedItems = items[index];
                  return ListTile(
                    title: Text(selectedItems.name ?? ''),
                    subtitle: Text(selectedItems.code ?? ''),
                    onTap: () {
                      Navigator.pop(context, selectedItems);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (selectedItems != null) {
      setState(() {
        _itemController.text =
            '${selectedItems.code ?? ''}-${selectedItems.name ?? ''}';
        _selectedItemId = selectedItems.id;
      });
      FocusScope.of(context).unfocus();
    } else {
      setState(() {
        _itemController.clear();
        _selectedItemId = null;
      });
    }
  }
}
