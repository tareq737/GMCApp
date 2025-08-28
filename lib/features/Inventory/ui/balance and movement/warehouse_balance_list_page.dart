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
  bool _isWarehouseDialogShowing = false;
  bool _isItemDialogShowing = false;

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
    _itemController.dispose();
    _warehouseFocusNode.removeListener(_onWarehouseFocusChange);
    _warehouseFocusNode.dispose();
    _itemFocusNode.removeListener(_onItemFocusChange);
    _itemFocusNode.dispose();
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
        _isSearchingWarehouse = false;
      });
      FocusScope.of(context).unfocus();
    } else if (results.length > 1) {
      _showWarehouseSelectionDialog(
          context, results, _warehouseController.text);
    } else {
      _warehouseController.clear();
      setState(() {
        _selectedWarehouseId = null;
        _isSearchingWarehouse = false;
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
    String currentSearch,
  ) async {
    final inventoryBloc = context.read<InventoryBloc>();
    setState(() {
      _isWarehouseDialogShowing = true;
      _isSearchingWarehouse = false;
    });

    final selectedFromWarehouse = await showDialog<WarehousesModel>(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: inventoryBloc,
          child: _WarehouseSelectionDialog(
            initialWarehouses: warehouses,
            initialSearch: currentSearch,
          ),
        );
      },
    );

    setState(() {
      _isWarehouseDialogShowing = false;
    });

    if (selectedFromWarehouse != null) {
      setState(() {
        _warehouseController.text =
            '${selectedFromWarehouse.code ?? ''}-${selectedFromWarehouse.name ?? ''}';
        _selectedWarehouseId = selectedFromWarehouse.id;
      });
      FocusScope.of(context).unfocus();
    } else {
      // Keep text field as is if user cancels
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
            warehouse_id: _selectedWarehouseId,
            page: _currentPage,
          ),
        );
  }

  void _onItemFocusChange() {
    if (!_itemFocusNode.hasFocus && _itemController.text.isNotEmpty) {
      setState(() {
        _isSearchingItem = true;
      });
      context.read<InventoryBloc>().add(
            SearchItems(
              search: _itemController.text,
              page: 1,
            ),
          );
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
    if (results.length == 1) {
      final selectedItem = results.first;
      setState(() {
        _itemController.text =
            '${selectedItem.code ?? ''}-${selectedItem.name ?? ''}';
        _selectedItemId = selectedItem.id;
        _isSearchingItem = false;
      });
      FocusScope.of(context).unfocus();
    } else if (results.length > 1) {
      _showItemsSelectionDialog(context, results, _itemController.text);
    } else {
      _itemController.clear();
      setState(() {
        _selectedItemId = null;
        _isSearchingItem = false;
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
    String currentSearch,
  ) async {
    final inventoryBloc = context.read<InventoryBloc>();
    setState(() {
      _isItemDialogShowing = true;
      _isSearchingItem = false; // This is already correct
    });
    final selectedItems = await showDialog<ItemsModel>(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: inventoryBloc,
          child: _ItemSelectionDialog(
            initialItems: items,
            initialSearch: currentSearch,
          ),
        );
      },
    );

    setState(() {
      _isItemDialogShowing = false;
      _isSearchingItem = false; // Add this line here
    });

    if (selectedItems != null) {
      setState(() {
        _itemController.text =
            '${selectedItems.code ?? ''}-${selectedItems.name ?? ''}';
        _selectedItemId = selectedItems.id;
      });
      FocusScope.of(context).unfocus();
    } else {
      // Keep text field as is if user cancels
    }
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
                              _fetchInitialBalanceList(context);
                            },
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              BlocListener<InventoryBloc, InventoryState>(
                listener: (context, state) {
                  // Handle Warehouse Search Results
                  if (state is InventorySuccess<List<WarehousesModel>> &&
                      !_isWarehouseDialogShowing) {
                    _handleWarehouseSearchResults(context, state.result);
                  }
                  // Handle Item Search Results
                  else if (state is InventorySuccess<List<ItemsModel>> &&
                      !_isItemDialogShowing) {
                    _handleItemSearchResults(context, state.result);
                  }
                  // Handle Movement List Results
                  else if (state is InventorySuccess<List<BalanceModel>>) {
                    if (mounted) {
                      setState(() {
                        if (_currentPage == 1) {
                          _balanceList = state.result;
                        } else {
                          _balanceList.addAll(state.result);
                        }
                        if (state.result.length < 10) {
                          _hasMore = false;
                        }
                        _isFetchingMore = false;
                      });
                    }
                  }

                  // Handle Errors
                  else if (state is InventoryError) {
                    showSnackBar(
                      context: context,
                      content: 'فشل تحميل البيانات',
                      failure: true,
                    );
                    if (mounted) {
                      setState(() {
                        _isFetchingMore = false;
                        _isSearchingWarehouse = false;
                        _isSearchingItem = false;
                      });
                    }
                  }
                },
                child: Expanded(
                  child: _balanceList.isEmpty
                      ? const Center(child: Text(''))
                      : NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent - 100 &&
                                !_isFetchingMore &&
                                _hasMore) {
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
}

class _WarehouseSelectionDialog extends StatefulWidget {
  final List<WarehousesModel> initialWarehouses;
  final String initialSearch;

  const _WarehouseSelectionDialog({
    required this.initialWarehouses,
    required this.initialSearch,
  });

  @override
  State<_WarehouseSelectionDialog> createState() =>
      _WarehouseSelectionDialogState();
}

class _WarehouseSelectionDialogState extends State<_WarehouseSelectionDialog> {
  late List<WarehousesModel> _warehouses;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  int _currentPage = 1;
  bool _isFetchingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _warehouses = List.from(widget.initialWarehouses);
    _searchController.text = widget.initialSearch;
    _scrollController.addListener(_onScroll);
    if (widget.initialWarehouses.length < 10) {
      _hasMore = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isFetchingMore &&
        _hasMore) {
      _fetchMoreWarehouses();
    }
  }

  void _fetchMoreWarehouses() {
    setState(() => _isFetchingMore = true);
    _currentPage++;
    context.read<InventoryBloc>().add(
          SearchWarehouse(search: _searchController.text, page: _currentPage),
        );
  }

  void _performSearch() {
    setState(() {
      _warehouses.clear();
      _currentPage = 1;
      _hasMore = true;
      _isFetchingMore = true;
    });
    context
        .read<InventoryBloc>()
        .add(SearchWarehouse(search: _searchController.text, page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BlocListener<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state is InventorySuccess<List<WarehousesModel>>) {
            if (mounted) {
              setState(() {
                if (_currentPage == 1) {
                  _warehouses = state.result;
                } else {
                  _warehouses.addAll(state.result);
                }
                if (state.result.length < 10) {
                  _hasMore = false;
                }
                _isFetchingMore = false;
              });
            }
          } else if (state is InventoryError) {
            if (mounted) setState(() => _isFetchingMore = false);
          }
        },
        child: AlertDialog(
          title: const Text('اختر المستودع'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'بحث',
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _performSearch),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
                Expanded(
                  child: _isFetchingMore && _warehouses.isEmpty
                      ? const Center(child: Loader())
                      : ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: _warehouses.length + (_hasMore ? 1 : 0),
                          itemBuilder: (BuildContext context, int index) {
                            if (index < _warehouses.length) {
                              final warehouse = _warehouses[index];
                              return ListTile(
                                title: Text(warehouse.name ?? ''),
                                subtitle: Text(warehouse.code ?? ''),
                                onTap: () => Navigator.pop(context, warehouse),
                              );
                            } else {
                              return const Center(child: Loader());
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Stateful Widget for Item Selection Dialog
class _ItemSelectionDialog extends StatefulWidget {
  final List<ItemsModel> initialItems;
  final String initialSearch;

  const _ItemSelectionDialog({
    required this.initialItems,
    required this.initialSearch,
  });

  @override
  State<_ItemSelectionDialog> createState() => __ItemSelectionDialogState();
}

class __ItemSelectionDialogState extends State<_ItemSelectionDialog> {
  late List<ItemsModel> _items;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  int _currentPage = 1;
  bool _isFetchingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.initialItems);
    _searchController.text = widget.initialSearch;
    _scrollController.addListener(_onScroll);
    if (widget.initialItems.length < 10) {
      _hasMore = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isFetchingMore &&
        _hasMore) {
      _fetchMoreItems();
    }
  }

  void _fetchMoreItems() {
    setState(() => _isFetchingMore = true);
    _currentPage++;
    context.read<InventoryBloc>().add(
          SearchItems(search: _searchController.text, page: _currentPage),
        );
  }

  void _performSearch() {
    setState(() {
      _items.clear();
      _currentPage = 1;
      _hasMore = true;
      _isFetchingMore = true;
    });
    context
        .read<InventoryBloc>()
        .add(SearchItems(search: _searchController.text, page: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: BlocListener<InventoryBloc, InventoryState>(
        listener: (context, state) {
          if (state is InventorySuccess<List<ItemsModel>>) {
            if (mounted) {
              setState(() {
                if (_currentPage == 1) {
                  _items = state.result;
                } else {
                  _items.addAll(state.result);
                }
                if (state.result.length < 10) {
                  _hasMore = false;
                }
                _isFetchingMore = false;
              });
            }
          } else if (state is InventoryError) {
            if (mounted) setState(() => _isFetchingMore = false);
          }
        },
        child: AlertDialog(
          title: const Text('اختر المادة'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'بحث',
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _performSearch),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
                Expanded(
                  child: _isFetchingMore && _items.isEmpty
                      ? const Center(child: Loader())
                      : ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: _items.length + (_hasMore ? 1 : 0),
                          itemBuilder: (BuildContext context, int index) {
                            if (index < _items.length) {
                              final item = _items[index];
                              return ListTile(
                                title: Text(item.name ?? ''),
                                subtitle: Text(item.code ?? ''),
                                onTap: () => Navigator.pop(context, item),
                              );
                            } else {
                              return const Center(child: Loader());
                            }
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
