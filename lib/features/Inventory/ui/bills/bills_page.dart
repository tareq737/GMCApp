import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/accounts_model.dart';
import 'package:gmcappclean/features/Inventory/models/bill_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/transfer_model.dart';
import 'package:gmcappclean/features/Inventory/models/warehouses_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/bills/bills_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';

class BillsPage extends StatelessWidget {
  final BillModel? billModel;
  final String bill_type;
  final int transfer_type;
  const BillsPage(
      {super.key,
      this.billModel,
      required this.bill_type,
      required this.transfer_type});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(
        InventoryServices(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      ),
      child: Builder(
        builder: (context) {
          return BillsPageChild(
            billModel: billModel,
            transfer_type: transfer_type,
            bill_type: bill_type,
          );
        },
      ),
    );
  }
}

class BillsPageChild extends StatefulWidget {
  final BillModel? billModel;
  final String bill_type;
  final int transfer_type;
  const BillsPageChild(
      {super.key,
      this.billModel,
      required this.bill_type,
      required this.transfer_type});

  @override
  State<BillsPageChild> createState() => _BillsPageChildState();
}

class _BillsPageChildState extends State<BillsPageChild> {
  bool get _isLandscape {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.orientation == Orientation.landscape;
  }

  bool _isSubmitting = false;
  int? _currentBillId;
  String? _previousSerial;
  final _fromWarehouseController = TextEditingController();
  final _fromWarehouseFocusNode = FocusNode();
  bool _isSelectingFromWarehouse = false;
  int? _selectedFromWarehouseId;

  final _toWarehouseController = TextEditingController();
  final _toWarehouseFocusNode = FocusNode();
  bool _isSelectingToWarehouse = false;
  int? _selectedToWarehouseId;

  final _customerController = TextEditingController();
  final _customerFocusNode = FocusNode();
  bool _isSelectingCustomer = false;
  int? _selectedCustomerId;

  final bool _isFormSubmitting = false;
  String? _lastSearchField;

  int currentItemSearchPage = 1;
  final ScrollController _scrollController = ScrollController();
  List<ItemsModel> _itemsList = [];
  final _serialController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();
  final _discountRateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _editableItems = [];
  final List<TextEditingController> _itemNameControllers = [];
  final List<TextEditingController> _itemUnitControllers = [];
  final List<TextEditingController> _quantityControllers = [];
  final List<TextEditingController> _priceControllers = [];
  final List<TextEditingController> _itemNoteControllers = [];
  final List<FocusNode> _itemNameFocusNodes = [];
  final List<FocusNode> _quantityFocusNodes = [];

  final List<ItemsModel?> _selectedItemData = [];
  final _serialFocusNode = FocusNode();
  bool _isSelectingItem = false;

  int? _currentItemSearchIndex;
  bool _isSearchingItem = false;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _currentBillId = widget.billModel?.id;
    if (widget.billModel != null) {
      _serialController.text = widget.billModel!.transfer!.serial.toString();
      _dateController.text = widget.billModel!.transfer!.date ?? '';
      _noteController.text = widget.billModel!.transfer!.note ?? '';
      _discountRateController.text =
          widget.billModel!.discount_rate?.toString() ?? '0';
      _fromWarehouseController.text =
          widget.billModel!.transfer!.from_warehouse_name ?? '';
      _selectedFromWarehouseId = widget.billModel!.transfer!.from_warehouse;

      _toWarehouseController.text =
          widget.billModel!.transfer!.to_warehouse_name ?? '';
      _selectedToWarehouseId = widget.billModel!.transfer!.to_warehouse;

      if (widget.billModel!.customer != null) {
        _customerController.text =
            widget.billModel!.customer!.account_name ?? '';
        _selectedCustomerId = widget.billModel!.customer_id;
      } else {
        _customerController.text = '';
        _selectedCustomerId = null;
      }

      if (widget.billModel!.transfer!.items != null) {
        // Initialize lists with existing item data
        for (int i = 0; i < widget.billModel!.transfer!.items!.length; i++) {
          var item = widget.billModel!.transfer!.items![i];

          _editableItems.add(Map<String, dynamic>.from(item));
          _itemNameControllers.add(
              TextEditingController(text: item['item_name']?.toString() ?? ''));
          _itemUnitControllers.add(
              TextEditingController(text: item['item_unit']?.toString() ?? ''));
          _quantityControllers.add(
              TextEditingController(text: item['quantity']?.toString() ?? ''));
          _priceControllers.add(
              TextEditingController(text: item['price']?.toString() ?? ''));
          _itemNoteControllers
              .add(TextEditingController(text: item['note']?.toString() ?? ''));

          _serialFocusNode.addListener(_onSerialFocusChange);
          // Add quantity focus node
          final quantityFocusNode = FocusNode();
          quantityFocusNode.addListener(() => _onQuantityFocusChange(
              _quantityFocusNodes.indexOf(quantityFocusNode)));
          _quantityFocusNodes.add(quantityFocusNode);

          // Add listeners for quantity and price to update totals
          _quantityControllers[i].addListener(_updateTotals);
          _priceControllers[i].addListener(_updateTotals);

          // Add focus node and its listener
          final newFocusNode = FocusNode();
          newFocusNode.addListener(() => _onItemFocusNodeChange(i));
          _itemNameFocusNodes.add(newFocusNode);

          // Properly parse item_details if it exists
          if (item['item_details'] != null && item['item_details'] is Map) {
            try {
              final ItemsModel selectedItem = ItemsModel.fromMap(
                  Map<String, dynamic>.from(item['item_details'] as Map));
              _selectedItemData.add(selectedItem);

              // Set the price from the 'item_details' if available
              if (_priceControllers[i].text.isEmpty) {
                final defaultPriceA = selectedItem.default_price?.firstWhere(
                  (priceEntry) =>
                      priceEntry is Map && priceEntry['list_name'] == 'A',
                  orElse: () => <String, dynamic>{},
                );
                if (defaultPriceA.isNotEmpty &&
                    defaultPriceA.containsKey('price')) {
                  _priceControllers[i].text = defaultPriceA['price'].toString();
                }
              }
            } catch (e) {
              print('Error parsing item_details for index $i: $e');
              _selectedItemData.add(null);
            }
          } else {
            _selectedItemData.add(null);
          }
        }
      }
    } else {
      // For a new transfer, set current date and add one empty item row
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _discountRateController.text = '0';
      _addNewItem();
    }

    _fromWarehouseFocusNode.addListener(_onFromWarehouseFocusChange);
    _toWarehouseFocusNode.addListener(_onToWarehouseFocusChange);
    _customerFocusNode.addListener(_onCustomerFocusChange);
    _discountRateController
        .addListener(_updateTotals); // Recalculate on discount change
  }

  @override
  void dispose() {
    _serialController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    _discountRateController.removeListener(_updateTotals);
    _discountRateController.dispose();
    _disposeItemControllers();
    _scrollController.dispose();

    _fromWarehouseFocusNode.removeListener(_onFromWarehouseFocusChange);
    _fromWarehouseFocusNode.dispose();
    _toWarehouseFocusNode.removeListener(_onToWarehouseFocusChange);
    _serialFocusNode.removeListener(_onSerialFocusChange);
    _serialFocusNode.dispose();
    _toWarehouseFocusNode.dispose();

    _customerFocusNode.dispose();
    _customerController.dispose();
    _customerFocusNode.removeListener(_onCustomerFocusChange);

    super.dispose();
  }

  // Helper to dispose all item-related controllers and clear lists
  void _disposeItemControllers() {
    for (var controller in _itemNameControllers) {
      controller.dispose();
    }
    for (var controller in _itemUnitControllers) {
      controller.dispose();
    }
    for (var controller in _quantityControllers) {
      controller
          .removeListener(_updateTotals); // Remove listener before disposing
      controller.dispose();
    }
    for (var controller in _priceControllers) {
      controller
          .removeListener(_updateTotals); // Remove listener before disposing
      controller.dispose();
    }
    for (var controller in _itemNoteControllers) {
      controller.dispose();
    }
    for (var node in _itemNameFocusNodes) {
      node.removeListener(
          () {}); // Remove all listeners before disposing, safer than specific one
      node.dispose();
    }
    for (var node in _quantityFocusNodes) {
      node.removeListener(() {});
      node.dispose();
    }
    _quantityFocusNodes.clear();
    _itemNameControllers.clear();
    _itemUnitControllers.clear();
    _quantityControllers.clear();
    _priceControllers.clear();
    _itemNoteControllers.clear();
    _itemNameFocusNodes.clear();
    _selectedItemData.clear(); // Clear _selectedItemData as well
  }

  void _onSerialFocusChange() {
    if (!_serialFocusNode.hasFocus &&
        _serialController.text.isNotEmpty &&
        _serialController.text != _previousSerial) {
      _previousSerial = _serialController.text;
      context.read<InventoryBloc>().add(
            GetOneBillBySerial(
              serial: int.tryParse(_serialController.text) ?? 0,
              transfer_type: widget.transfer_type,
            ),
          );
    }
  }

  void _addNewItem() {
    setState(() {
      _editableItems.add({
        'item': null,
        'item_name': '',
        'item_unit': '',
        'quantity': '',
        'price': '',
        'note': '',
      });
      final quantityController = TextEditingController();
      final priceController = TextEditingController();
      final quantityFocusNode = FocusNode();

      quantityController.addListener(_updateTotals);
      priceController.addListener(_updateTotals);
      quantityFocusNode.addListener(() => _onQuantityFocusChange(
          _quantityFocusNodes.indexOf(quantityFocusNode)));

      _itemNameControllers.add(TextEditingController());
      _itemUnitControllers.add(TextEditingController());
      _quantityControllers.add(quantityController);
      _priceControllers.add(priceController);
      _itemNoteControllers.add(TextEditingController());
      _quantityFocusNodes.add(quantityFocusNode);

      final newFocusNode = FocusNode();
      _itemNameFocusNodes.add(newFocusNode);
      newFocusNode.addListener(
        () => _onItemFocusNodeChange(_itemNameFocusNodes.indexOf(newFocusNode)),
      );
      _selectedItemData.add(null);
    });
  }

  void _onQuantityFocusChange(int index) {
    if (widget.transfer_type != 101) {
      if (index >= 0 && index < _quantityFocusNodes.length) {
        if (!_quantityFocusNodes[index].hasFocus) {
          // _validateQuantityAgainstInventory(index);
        }
      }
    }
  }

  void _validateQuantityAgainstInventory(int index) async {
    if (_selectedFromWarehouseId == null || _selectedItemData[index] == null) {
      return;
    }

    final quantityText = _quantityControllers[index].text.replaceAll(',', '');
    final enteredQuantity = double.tryParse(quantityText) ?? 0;

    if (enteredQuantity <= 0) {
      return;
    }

    // Find available quantity for this item in the from warehouse
    final item = _selectedItemData[index]!;

    final balance = item.balances?.firstWhere(
      (b) => b['warehouse_id'] == _selectedFromWarehouseId,
      orElse: () => {'quantity': 0},
    );

    // Safer quantity extraction
    final availableQuantity = balance != null
        ? (balance['quantity'] is String
            ? double.tryParse(balance['quantity']) ?? 0
            : (balance['quantity'] as num?)?.toDouble() ?? 0)
        : 0;

    if (enteredQuantity > availableQuantity) {
      showSnackBar(
        context: context,
        content:
            'الكمية المدخلة (${_quantityControllers[index].text}) تتجاوز الكمية المتاحة ($availableQuantity) في المستودع المصدر',
        failure: true,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _quantityControllers[index].clear();
        _quantityFocusNodes[index].requestFocus();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      // Dispose controllers and remove listeners before removing from lists
      _itemNameControllers[index].dispose();
      _itemUnitControllers[index].dispose();
      _quantityControllers[index].removeListener(_updateTotals);
      _quantityControllers[index].dispose();
      _quantityFocusNodes[index].removeListener(() {});
      _quantityFocusNodes[index].dispose();
      _priceControllers[index].removeListener(_updateTotals);
      _priceControllers[index].dispose();
      _itemNoteControllers[index].dispose();
      _itemNameFocusNodes[index]
          .removeListener(() {}); // Remove all listeners before disposing
      _itemNameFocusNodes[index].dispose();
      _quantityFocusNodes.removeAt(index);
      // Remove from lists
      _editableItems.removeAt(index);
      _itemNameControllers.removeAt(index);
      _itemUnitControllers.removeAt(index);
      _quantityControllers.removeAt(index);
      _priceControllers.removeAt(index);
      _itemNoteControllers.removeAt(index);
      _itemNameFocusNodes.removeAt(index);
      _selectedItemData.removeAt(index); // Remove the corresponding item data
    });
    _updateTotals(); // Recalculate total after removing an item
  }

  void _updateTotals() {
    // Calling setState here rebuilds the widget and updates the totals.
    setState(() {});
  }

  void _searchForItem(int index) {
    if (_itemNameControllers[index].text.isEmpty) {
      // Clear fields if search input is empty
      setState(() {
        _editableItems[index]['item'] = null;
        _itemUnitControllers[index].clear();
        _quantityControllers[index].clear();
        _priceControllers[index].clear();
        _itemNoteControllers[index].clear();
        _selectedItemData[index] = null;
      });
      _updateTotals();
      return;
    }

    setState(() {
      _isSearchingItem = true;
      _currentItemSearchIndex = index;
      _itemsList.clear();
      currentItemSearchPage = 1;
      isLoadingMore = false;
    });

    context.read<InventoryBloc>().add(
          SearchItems(search: _itemNameControllers[index].text, page: 1),
        );
  }

  Future<void> _showItemSearchDialog(int index) async {
    _scrollController.addListener(_onScrollItem);

    final selectedItem = await showDialog<ItemsModel?>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: BlocProvider.value(
            value: BlocProvider.of<InventoryBloc>(context),
            child: Builder(
              builder: (context) {
                return AlertDialog(
                  title: const Text('بحث عن مادة', textAlign: TextAlign.right),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: BlocBuilder<InventoryBloc, InventoryState>(
                      builder: (context, state) {
                        if (state is InventoryLoading &&
                            currentItemSearchPage == 1) {
                          return const Center(child: Loader());
                        } else if (state is InventoryError &&
                            currentItemSearchPage == 1) {
                          return Center(
                            child: Text(
                              'خطأ: ${state.errorMessage}',
                              textAlign: TextAlign.right,
                            ),
                          );
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              _itemsList.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, i) {
                            if (i == _itemsList.length) {
                              return const Center(child: Loader());
                            }
                            final item = _itemsList[i];
                            return ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              title: Text(
                                '${item.code ?? ''}=${item.name ?? ''} (${item.unit ?? ''})',
                                textAlign: TextAlign.right,
                                textDirection: ui.TextDirection.rtl,
                              ),
                              onTap: () {
                                Navigator.of(dialogContext).pop(item);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  actionsAlignment: MainAxisAlignment.start,
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(null);
                      },
                      child: const Text('إلغاء',
                          textDirection: ui.TextDirection.rtl),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight,
                );
              },
            ),
          ),
        );
      },
    );

    _scrollController.removeListener(_onScrollItem);
    setState(() {
      _isSearchingItem = false;
      _currentItemSearchIndex = null;

      if (selectedItem != null) {
        _editableItems[index]['item'] = selectedItem.id;
        _itemNameControllers[index].text =
            '${selectedItem.code ?? ''}-${selectedItem.name ?? ''}';
        _itemUnitControllers[index].text = selectedItem.unit ?? '';
        _selectedItemData[index] = selectedItem;

        final defaultPriceA = selectedItem.default_price?.firstWhere(
          (price) => price['list_name'] == 'A',
          orElse: () => <String, dynamic>{},
        );
        if (defaultPriceA.isNotEmpty && defaultPriceA.containsKey('price')) {
          _priceControllers[index].text = defaultPriceA['price'].toString();
        } else {
          _priceControllers[index].clear();
        }

        // Focus on quantity after item is selected
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _focusToQuantity(index));
      } else {
        if (_itemNameControllers[index].text.isNotEmpty) {
          _itemNameControllers[index].clear();
          _editableItems[index]['item'] = null;
          _itemUnitControllers[index].clear();
          _quantityControllers[index].clear();
          _priceControllers[index].clear();
          _itemNoteControllers[index].clear();
          _selectedItemData[index] = null;
        }
      }
    });
    _updateTotals();
  }

  void _onScrollItem() {
    // Load more items when near the end of the scroll
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore) {
      _nextPageItem();
    }
  }

  void _nextPageItem() {
    setState(() {
      isLoadingMore = true;
    });
    currentItemSearchPage++;
    runBlocItemSearch();
  }

  void runBlocItemSearch() {
    if (_currentItemSearchIndex == null) return;
    context.read<InventoryBloc>().add(
          SearchItems(
            page: currentItemSearchPage,
            search: _itemNameControllers[_currentItemSearchIndex!].text,
          ),
        );
  }

  void _onItemFocusNodeChange(int index) {
    if (_isFormSubmitting) return;

    // If focus is lost and the text field is empty, clear the item details.
    if (!_itemNameFocusNodes[index].hasFocus &&
        _itemNameControllers[index].text.isEmpty) {
      setState(() {
        _editableItems[index]['item'] = null;
        _itemUnitControllers[index].clear();
        _quantityControllers[index].clear();
        _priceControllers[index].clear();
        _itemNoteControllers[index].clear();
        _selectedItemData[index] = null; // Clear selected item data
      });
      _updateTotals(); // Recalculate total after clearing item fields
    }
    // If focus is lost and the text field is NOT empty, trigger search (if not already selecting)
    else if (!_itemNameFocusNodes[index].hasFocus &&
        _itemNameControllers[index].text.isNotEmpty &&
        !_isSelectingItem) {
      _searchForItem(index);
    }
  }

  void _onFromWarehouseFocusChange() {
    if (!_fromWarehouseFocusNode.hasFocus &&
        _fromWarehouseController.text.isNotEmpty &&
        !_isSelectingFromWarehouse) {
      _lastSearchField = 'from';
      context.read<InventoryBloc>().add(
            SearchWarehouse(
              search: _fromWarehouseController.text,
              page: 1,
              transfer_type: widget.transfer_type,
            ),
          );
    } else if (!_fromWarehouseFocusNode.hasFocus &&
        _fromWarehouseController.text.isEmpty) {
      setState(() {
        _selectedFromWarehouseId = null;
      });
    }
  }

  void _onToWarehouseFocusChange() {
    if (!_toWarehouseFocusNode.hasFocus &&
        _toWarehouseController.text.isNotEmpty &&
        !_isSelectingToWarehouse) {
      _lastSearchField = 'to';
      context.read<InventoryBloc>().add(
            SearchWarehouse(
              search: _toWarehouseController.text,
              page: 1,
              transfer_type: widget.transfer_type,
            ),
          );
    } else if (!_toWarehouseFocusNode.hasFocus &&
        _toWarehouseController.text.isEmpty) {
      setState(() {
        _selectedToWarehouseId = null;
      });
    }
  }

  void _onCustomerFocusChange() {
    if (!_customerFocusNode.hasFocus &&
        _customerController.text.isNotEmpty &&
        !_isSelectingCustomer) {
      context.read<InventoryBloc>().add(
            SearchAccounts(
              search: _customerController.text,
              page: 1,
            ),
          );
    } else if (!_customerFocusNode.hasFocus &&
        _customerController.text.isEmpty) {
      setState(() {
        _selectedCustomerId = null;
      });
    }
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

  void _fillFormFromTransferModel(BillModel bill) {
    // Use setState to ensure the UI rebuilds with the new data.
    setState(() {
      // 1. Update the state variables with the new transfer's info.
      _currentBillId = bill.id; // Solves the update ID issue
      _serialController.text =
          bill.transfer!.serial.toString(); // Updates the serial field

      // 2. Clear all previous data and controllers to prevent memory leaks.
      _disposeItemControllers();
      _editableItems.clear();
      _selectedItemData.clear();

      // 3. Set the main form fields from the new transfer object.
      _dateController.text = bill.transfer!.date ?? '';
      _noteController.text = bill.transfer!.note ?? '';
      _discountRateController.text = bill.discount_rate?.toString() ?? '0';
      _fromWarehouseController.text = bill.transfer!.from_warehouse_name ?? '';
      _toWarehouseController.text = bill.transfer!.to_warehouse_name ?? '';
      _selectedFromWarehouseId = bill.transfer!.from_warehouse;
      _selectedToWarehouseId = bill.transfer!.to_warehouse;
      _selectedCustomerId = bill.customer_id;
      _customerController.text = bill.customer!.name ?? '';

      // 4. Rebuild the item list from the new transfer's items.
      if (bill.transfer!.items != null) {
        for (var item in bill.transfer!.items!) {
          _editableItems.add(Map<String, dynamic>.from(item));

          // Create controllers for this item
          final itemNameController =
              TextEditingController(text: item['item_name']?.toString() ?? '');
          final itemUnitController =
              TextEditingController(text: item['item_unit']?.toString() ?? '');
          final quantityController =
              TextEditingController(text: item['quantity']?.toString() ?? '');
          final priceController =
              TextEditingController(text: item['price']?.toString() ?? '');
          final itemNoteController =
              TextEditingController(text: item['note']?.toString() ?? '');

          // Add controllers to lists
          _itemNameControllers.add(itemNameController);
          _itemUnitControllers.add(itemUnitController);
          _quantityControllers.add(quantityController);
          _priceControllers.add(priceController);
          _itemNoteControllers.add(itemNoteController);

          // Add focus nodes
          final quantityFocusNode = FocusNode();
          quantityFocusNode.addListener(() => _onQuantityFocusChange(
              _quantityFocusNodes.indexOf(quantityFocusNode)));
          _quantityFocusNodes.add(quantityFocusNode);

          final itemNameFocusNode = FocusNode();
          itemNameFocusNode.addListener(() => _onItemFocusNodeChange(
              _itemNameFocusNodes.indexOf(itemNameFocusNode)));
          _itemNameFocusNodes.add(itemNameFocusNode);

          // Add listeners to update totals automatically
          quantityController.addListener(_updateTotals);
          priceController.addListener(_updateTotals);

          // Parse item_details to get full item data for balances/prices
          ItemsModel? selectedItem;
          if (item['item_details'] != null && item['item_details'] is Map) {
            try {
              selectedItem = ItemsModel.fromMap(
                  Map<String, dynamic>.from(item['item_details'] as Map));
            } catch (e) {
              debugPrint('Error parsing item_details: $e');
            }
          }
          _selectedItemData.add(selectedItem);
        }
      }
    });
  }

  List<String>? groups;
  @override
  Widget build(BuildContext context) {
    AppUserState state = context.read<AppUserCubit>().state;

    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _getTitleForTransferType(widget.transfer_type),
          ),
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess<BillModel>) {
              if (_isSubmitting) {
                // YES: Show success and navigate back.
                _isSubmitting = false; // Reset the flag
                showSnackBar(context: context, content: 'تم', failure: false);
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BillsListPage(
                      transfer_type: widget.transfer_type,
                      bill_type: widget.bill_type,
                    ),
                  ),
                );
              } else {
                // NO: It was a fetch, so just update the form.
                _fillFormFromTransferModel(state.result);
                _serialController.text =
                    state.result.transfer!.serial.toString();
                _previousSerial =
                    _serialController.text; // Prevents re-fetching
              }
            } else if (state is InventorySuccessDeleted) {
              showSnackBar(
                context: context,
                content: 'تم الحذف بنجاح',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BillsListPage(
                    transfer_type: widget.transfer_type,
                    bill_type: widget.bill_type,
                  ),
                ),
              );
              return; // Important: return early to prevent other handlers
            } else if (state is InventoryError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
              // Navigator.pop(context);
              setState(() {
                _isSearchingItem = false;
                _currentItemSearchIndex = null;
              });
            } else if (state is InventorySuccess<List<ItemsModel>>) {
              setState(() {
                if (currentItemSearchPage == 1) {
                  _itemsList = state.result;
                } else {
                  _itemsList.addAll(state.result);
                }
                isLoadingMore = false;
                _isSearchingItem = false;

                if (_currentItemSearchIndex != null) {
                  if (_itemsList.isEmpty && currentItemSearchPage == 1) {
                    showSnackBar(
                      context: context,
                      content: 'لا توجد نتائج للمادة المدخلة.',
                      failure: true,
                    );
                    _itemNameControllers[_currentItemSearchIndex!].clear();
                    _editableItems[_currentItemSearchIndex!]['item'] = null;
                    _itemUnitControllers[_currentItemSearchIndex!].clear();
                    _quantityControllers[_currentItemSearchIndex!].clear();
                    _priceControllers[_currentItemSearchIndex!].clear();
                    _itemNoteControllers[_currentItemSearchIndex!].clear();
                    _selectedItemData[_currentItemSearchIndex!] = null;
                  } else if (_itemsList.length == 1 &&
                      currentItemSearchPage == 1) {
                    final item = _itemsList.first;
                    _editableItems[_currentItemSearchIndex!]['item'] = item.id;
                    _itemNameControllers[_currentItemSearchIndex!].text =
                        '${item.code ?? ''}-${item.name ?? ''}';
                    _itemUnitControllers[_currentItemSearchIndex!].text =
                        item.unit ?? '';
                    _selectedItemData[_currentItemSearchIndex!] = item;

                    final defaultPriceA = item.default_price?.firstWhere(
                      (price) => price['list_name'] == 'A',
                      orElse: () => <String, dynamic>{},
                    );
                    if (defaultPriceA.isNotEmpty &&
                        defaultPriceA.containsKey('price')) {
                      _priceControllers[_currentItemSearchIndex!].text =
                          defaultPriceA['price'].toString();
                    } else {
                      // If the new item has no default price, clear the field
                      _priceControllers[_currentItemSearchIndex!].clear();
                    }

                    // Focus on quantity after single item is found
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _focusToQuantity(_currentItemSearchIndex!));
                  } else if (_itemsList.length > 1 &&
                      currentItemSearchPage == 1) {
                    if (!_isSelectingItem) {
                      _isSelectingItem = true;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _showItemSearchDialog(_currentItemSearchIndex!)
                              .then((_) {
                            _isSelectingItem = false;
                          });
                        }
                      });
                    }
                  }
                }
              });
              _updateTotals();
            } else if (state is InventorySuccess<List<WarehousesModel>>) {
              if (_lastSearchField == 'from') {
                _handleFromWarehouseSearchResults(context, state.result);
              } else if (_lastSearchField == 'to') {
                _handleToWarehouseSearchResults(context, state.result);
              }
            } else if (state is InventoryError &&
                (_lastSearchField == 'from' || _lastSearchField == 'to')) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
              if (_lastSearchField == 'from' &&
                  _fromWarehouseController.text.isEmpty) {
                setState(() {
                  _selectedFromWarehouseId = null;
                });
              } else if (_lastSearchField == 'to' &&
                  _toWarehouseController.text.isEmpty) {
                setState(() {
                  _selectedToWarehouseId = null;
                });
              }
            } else if (state is InventorySuccess<List<AccountsModel>>) {
              _handleAccountsSearchResults(context, state.result);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4, // Adjusted flex for space
                                      child: MyTextField(
                                        readOnly: true,
                                        controller: _dateController,
                                        labelText: 'التاريخ ',
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                          );
                                          if (pickedDate != null) {
                                            setState(() {
                                              _dateController.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'الرجاء تحديد تاريخ';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (widget.billModel?.transfer!.serial !=
                                        null) ...[
                                      // NEW: First Button
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          tooltip: 'الأول', // Tooltip: First
                                          onPressed: () {
                                            context.read<InventoryBloc>().add(
                                                  BillNavigation(
                                                    serial: int.parse(
                                                        _serialController.text),
                                                    transfer_type:
                                                        widget.transfer_type,
                                                    action: 'first',
                                                  ),
                                                );
                                          },
                                          icon: const FaIcon(
                                              FontAwesomeIcons.anglesRight),
                                        ),
                                      ),
                                      const SizedBox(width: 4),

                                      // Existing Previous Button
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          tooltip:
                                              'السابق', // Tooltip: Previous
                                          onPressed: () {
                                            context.read<InventoryBloc>().add(
                                                  BillNavigation(
                                                    serial: int.parse(
                                                        _serialController.text),
                                                    transfer_type:
                                                        widget.transfer_type,
                                                    action: 'previous',
                                                  ),
                                                );
                                          },
                                          icon: const FaIcon(
                                              FontAwesomeIcons.angleRight),
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Serial TextField
                                      Expanded(
                                        flex: 3,
                                        child: MyTextField(
                                          controller: _serialController,
                                          focusNode: _serialFocusNode,
                                          labelText: 'الرقم',
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'الرجاء إدخال الرقم';
                                            }
                                            if (int.tryParse(value) == null) {
                                              return 'الرجاء إدخال رقم صحيح';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),

                                      // Existing Next Button
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          tooltip: 'التالي', // Tooltip: Next
                                          onPressed: () {
                                            context.read<InventoryBloc>().add(
                                                  BillNavigation(
                                                    serial: int.parse(
                                                        _serialController.text),
                                                    transfer_type:
                                                        widget.transfer_type,
                                                    action: 'next',
                                                  ),
                                                );
                                          },
                                          icon: const FaIcon(
                                              FontAwesomeIcons.angleLeft),
                                        ),
                                      ),
                                      const SizedBox(width: 4),

                                      // NEW: Last Button
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          tooltip: 'الأخير', // Tooltip: Last
                                          onPressed: () {
                                            context.read<InventoryBloc>().add(
                                                  BillNavigation(
                                                    serial: int.parse(
                                                        _serialController.text),
                                                    transfer_type:
                                                        widget.transfer_type,
                                                    action: 'last',
                                                  ),
                                                );
                                          },
                                          icon: const FaIcon(
                                              FontAwesomeIcons.anglesLeft),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 7),
                                if (_isLandscape &&
                                    (widget.transfer_type < 100 ||
                                        widget.transfer_type == 101 ||
                                        widget.transfer_type == 102))
                                  Row(
                                    children: [
                                      if (widget.transfer_type < 100 ||
                                          widget.transfer_type == 102)
                                        Expanded(
                                          child: MyTextField(
                                            controller:
                                                _fromWarehouseController,
                                            labelText: 'من المستودع',
                                            focusNode: _fromWarehouseFocusNode,
                                            suffixIcon: (_fromWarehouseController
                                                    .text.isNotEmpty
                                                ? (state is InventoryLoading &&
                                                        _lastSearchField ==
                                                            'from'
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2),
                                                        ),
                                                      )
                                                    : IconButton(
                                                        icon: const Icon(
                                                            Icons.clear),
                                                        onPressed: () {
                                                          setState(() {
                                                            _fromWarehouseController
                                                                .clear();
                                                            _selectedFromWarehouseId =
                                                                null;
                                                          });
                                                        },
                                                      ))
                                                : null),
                                            validator: (value) {
                                              if ((widget.transfer_type < 100 ||
                                                      widget.transfer_type ==
                                                          102) &&
                                                  (value == null ||
                                                      value.isEmpty)) {
                                                return 'الرجاء اختيار المستودع المصدر';
                                              }
                                              if ((widget.transfer_type < 100 ||
                                                      widget.transfer_type ==
                                                          102) &&
                                                  _selectedFromWarehouseId ==
                                                      null) {
                                                return 'الرجاء اختيار مستودع صحيح';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      if ((widget.transfer_type < 100 ||
                                              widget.transfer_type == 102) &&
                                          (widget.transfer_type < 100 ||
                                              widget.transfer_type == 101))
                                        const SizedBox(width: 8),
                                      if (widget.transfer_type < 100 ||
                                          widget.transfer_type == 101)
                                        Expanded(
                                          child: MyTextField(
                                            controller: _toWarehouseController,
                                            labelText: 'إلى المستودع',
                                            focusNode: _toWarehouseFocusNode,
                                            suffixIcon: (_toWarehouseController
                                                    .text.isNotEmpty
                                                ? (state is InventoryLoading &&
                                                        _lastSearchField == 'to'
                                                    ? const Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2),
                                                        ),
                                                      )
                                                    : IconButton(
                                                        icon: const Icon(
                                                            Icons.clear),
                                                        onPressed: () {
                                                          setState(() {
                                                            _toWarehouseController
                                                                .clear();
                                                            _selectedToWarehouseId =
                                                                null;
                                                          });
                                                        },
                                                      ))
                                                : null),
                                            validator: (value) {
                                              if ((widget.transfer_type < 100 ||
                                                      widget.transfer_type ==
                                                          101) &&
                                                  (value == null ||
                                                      value.isEmpty)) {
                                                return 'الرجاء اختيار المستودع الهدف';
                                              }
                                              if ((widget.transfer_type < 100 ||
                                                      widget.transfer_type ==
                                                          101) &&
                                                  _selectedToWarehouseId ==
                                                      null) {
                                                return 'الرجاء اختيار مستودع صحيح';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: MyTextField(
                                          controller: _customerController,
                                          labelText: 'الحساب',
                                          focusNode: _customerFocusNode,
                                          suffixIcon: (_customerController
                                                  .text.isNotEmpty
                                              ? (state is InventoryLoading
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                                strokeWidth: 2),
                                                      ),
                                                    )
                                                  : IconButton(
                                                      icon: const Icon(
                                                          Icons.clear),
                                                      onPressed: () {
                                                        setState(() {
                                                          _customerController
                                                              .clear();
                                                          _selectedCustomerId =
                                                              null;
                                                        });
                                                      },
                                                    ))
                                              : null),
                                          validator: (value) {
                                            if ((widget.transfer_type < 100 ||
                                                    widget.transfer_type ==
                                                        101) &&
                                                (value == null ||
                                                    value.isEmpty)) {
                                              return 'الرجاء اختيار المستودع الهدف';
                                            }
                                            if ((widget.transfer_type < 100 ||
                                                    widget.transfer_type ==
                                                        101) &&
                                                _selectedToWarehouseId ==
                                                    null) {
                                              return 'الرجاء اختيار مستودع صحيح';
                                            }
                                            return null;
                                          },
                                        ),
                                      )
                                    ],
                                  ),

                                // Warehouse fields in portrait mode
                                if (!_isLandscape)
                                  Column(
                                    children: [
                                      if (widget.transfer_type < 100 ||
                                          widget.transfer_type == 102)
                                        MyTextField(
                                          controller: _fromWarehouseController,
                                          labelText: 'من المستودع',
                                          focusNode: _fromWarehouseFocusNode,
                                          suffixIcon: (_fromWarehouseController
                                                  .text.isNotEmpty
                                              ? (state is InventoryLoading &&
                                                      _lastSearchField == 'from'
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                                strokeWidth: 2),
                                                      ),
                                                    )
                                                  : IconButton(
                                                      icon: const Icon(
                                                          Icons.clear),
                                                      onPressed: () {
                                                        setState(() {
                                                          _fromWarehouseController
                                                              .clear();
                                                          _selectedFromWarehouseId =
                                                              null;
                                                        });
                                                      },
                                                    ))
                                              : null),
                                          validator: (value) {
                                            if ((widget.transfer_type < 100 ||
                                                    widget.transfer_type ==
                                                        102) &&
                                                (value == null ||
                                                    value.isEmpty)) {
                                              return 'الرجاء اختيار المستودع المصدر';
                                            }
                                            if ((widget.transfer_type < 100 ||
                                                    widget.transfer_type ==
                                                        102) &&
                                                _selectedFromWarehouseId ==
                                                    null) {
                                              return 'الرجاء اختيار مستودع صحيح';
                                            }
                                            return null;
                                          },
                                        ),
                                      if (widget.transfer_type < 100 ||
                                          widget.transfer_type == 102)
                                        const SizedBox(height: 7),
                                      if (widget.transfer_type < 100 ||
                                          widget.transfer_type == 101)
                                        MyTextField(
                                          controller: _toWarehouseController,
                                          labelText: 'إلى المستودع',
                                          focusNode: _toWarehouseFocusNode,
                                          suffixIcon: (_toWarehouseController
                                                  .text.isNotEmpty
                                              ? (state is InventoryLoading &&
                                                      _lastSearchField == 'to'
                                                  ? const Padding(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child: SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                                strokeWidth: 2),
                                                      ),
                                                    )
                                                  : IconButton(
                                                      icon: const Icon(
                                                          Icons.clear),
                                                      onPressed: () {
                                                        setState(() {
                                                          _toWarehouseController
                                                              .clear();
                                                          _selectedToWarehouseId =
                                                              null;
                                                        });
                                                      },
                                                    ))
                                              : null),
                                          validator: (value) {
                                            if ((widget.transfer_type < 100 ||
                                                    widget.transfer_type ==
                                                        101) &&
                                                (value == null ||
                                                    value.isEmpty)) {
                                              return 'الرجاء اختيار المستودع الهدف';
                                            }
                                            if ((widget.transfer_type < 100 ||
                                                    widget.transfer_type ==
                                                        101) &&
                                                _selectedToWarehouseId ==
                                                    null) {
                                              return 'الرجاء اختيار مستودع صحيح';
                                            }
                                            return null;
                                          },
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      MyTextField(
                                        controller: _customerController,
                                        labelText: 'الحساب',
                                        focusNode: _customerFocusNode,
                                        suffixIcon: (_customerController
                                                .text.isNotEmpty
                                            ? (state is InventoryLoading
                                                ? const Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                              strokeWidth: 2),
                                                    ),
                                                  )
                                                : IconButton(
                                                    icon:
                                                        const Icon(Icons.clear),
                                                    onPressed: () {
                                                      setState(() {
                                                        _customerController
                                                            .clear();
                                                        _selectedCustomerId =
                                                            null;
                                                      });
                                                    },
                                                  ))
                                            : null),
                                        validator: (value) {
                                          if ((widget.transfer_type < 100 ||
                                                  widget.transfer_type ==
                                                      101) &&
                                              (value == null ||
                                                  value.isEmpty)) {
                                            return 'الرجاء اختيار الحساب';
                                          }
                                          if ((widget.transfer_type < 100 ||
                                                  widget.transfer_type ==
                                                      101) &&
                                              _selectedCustomerId == null) {
                                            return 'الرجاء اختيار حساب صحيح';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),

                                const SizedBox(height: 7),
                                MyTextField(
                                  controller: _noteController,
                                  labelText: 'البيان',
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _isLandscape
                          ? _buildGridView()
                          : ListView(
                              children: [
                                // Portrait mode list view
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _editableItems.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(' ${index + 1}'),
                                                ),
                                                Expanded(
                                                  flex: 12,
                                                  child: MyTextField(
                                                    suffixIcon: SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child: _isSearchingItem &&
                                                              _currentItemSearchIndex ==
                                                                  index
                                                          ? const Center(
                                                              child: SizedBox(
                                                                width: 16,
                                                                height: 16,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      1.5,
                                                                ),
                                                              ),
                                                            )
                                                          : IconButton(
                                                              icon: const Icon(
                                                                  Icons
                                                                      .warehouse,
                                                                  size: 18),
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              constraints:
                                                                  const BoxConstraints(),
                                                              tooltip:
                                                                  'عرض الأرصدة',
                                                              onPressed: () =>
                                                                  _showBalanceDialog(
                                                                      index),
                                                            ),
                                                    ),
                                                    controller:
                                                        _itemNameControllers[
                                                            index],
                                                    labelText: 'المادة',
                                                    validator: (value) {
                                                      if (index ==
                                                              _editableItems
                                                                      .length -
                                                                  1 &&
                                                          (value == null ||
                                                              value.isEmpty)) {
                                                        return null;
                                                      }
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'الرجاء إدخال المادة';
                                                      }

                                                      return null;
                                                    },
                                                    focusNode:
                                                        _itemNameFocusNodes[
                                                            index],
                                                    onSubmitted: (value) {
                                                      _searchForItem(index);
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                if (_editableItems.length > 1)
                                                  Expanded(
                                                    flex: 1,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () =>
                                                          _removeItem(index),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: MyTextField(
                                                    readOnly: true,
                                                    controller:
                                                        _itemUnitControllers[
                                                            index],
                                                    labelText: 'الوحدة',
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  flex: 1,
                                                  child: MyTextField(
                                                    controller:
                                                        _quantityControllers[
                                                            index],
                                                    focusNode:
                                                        _quantityFocusNodes[
                                                            index],
                                                    labelText: 'الكمية',
                                                    onSubmitted: (value) {
                                                      // If this is the last item, add a new one and focus it.
                                                      if (index ==
                                                          _editableItems
                                                                  .length -
                                                              1) {
                                                        _addNewItem();
                                                        _focusOnNewItem();
                                                      } else {
                                                        // Otherwise, move focus to the next item's name field.
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                _itemNameFocusNodes[
                                                                    index + 1]);
                                                      }
                                                    },
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                      decimal: true,
                                                    ),
                                                    validator: (value) {
                                                      if (_itemNameControllers[
                                                              index]
                                                          .text
                                                          .isEmpty) {
                                                        return null;
                                                      }

                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'الرجاء إدخال الكمية';
                                                      }
                                                      if (double.tryParse(
                                                              value.replaceAll(
                                                                  ',', '')) ==
                                                          null) {
                                                        return 'الرجاء إدخال رقم صحيح';
                                                      }

                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                if (groups != null &&
                                                    (groups!.contains(
                                                            'accounting_price') ||
                                                        groups!.contains(
                                                            'admins') ||
                                                        groups!.contains(
                                                            'managers')))
                                                  Expanded(
                                                    flex: 2,
                                                    child: MyTextField(
                                                      controller:
                                                          _priceControllers[
                                                              index],
                                                      labelText: 'السعر',
                                                      keyboardType:
                                                          const TextInputType
                                                              .numberWithOptions(
                                                        decimal: true,
                                                      ),
                                                      suffixIcon: SizedBox(
                                                        width: 24,
                                                        height: 24,
                                                        child: IconButton(
                                                          icon: const Icon(
                                                              Icons
                                                                  .price_change,
                                                              size: 20),
                                                          padding:
                                                              EdgeInsets.zero,
                                                          constraints:
                                                              const BoxConstraints(),
                                                          onPressed: () {
                                                            _showPriceSelectionDialog(
                                                                index);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 6,
                                                  child: MyTextField(
                                                    controller:
                                                        _itemNoteControllers[
                                                            index],
                                                    labelText: 'البيان',
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                if (groups != null &&
                                                    (groups!.contains(
                                                            'accounting_price') ||
                                                        groups!.contains(
                                                            'admins') ||
                                                        groups!.contains(
                                                            'managers')))
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      'الإجمالي: ${_numberFormat.format(_getItemTotal(index))}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: OutlinedButton.icon(
                                    onPressed: _addNewItem,
                                    icon: const Icon(Icons.add_circle_outline),
                                    label: const Text('إضافة مادة جديدة'),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (groups != null &&
                                    (groups!.contains('accounting_price') ||
                                        groups!.contains('admins') ||
                                        groups!.contains('managers')))
                                  _buildTotalsSummary(),
                                const SizedBox(height: 30),
                                state is InventoryLoading
                                    ? const Loader()
                                    : Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Mybutton(
                                                text: 'إضافة',
                                                onPressed: _submitFormAdd,
                                              ),
                                              if (widget.billModel != null &&
                                                  widget.billModel!.transfer!
                                                          .serial !=
                                                      null)
                                                Mybutton(
                                                  text: 'تعديل',
                                                  onPressed: _submitFormUpdate,
                                                ),
                                            ],
                                          ),
                                          if (widget.billModel != null &&
                                              widget.billModel!.transfer!
                                                      .serial !=
                                                  null)
                                            IconButton(
                                              icon: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red
                                                      .withOpacity(0.2),
                                                  border: Border.all(
                                                    color: Colors.red
                                                        .withOpacity(0.5),
                                                    width: 1,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: const FaIcon(
                                                  FontAwesomeIcons.trash,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              ),
                                              tooltip: 'حذف',
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (_) =>
                                                      Directionality(
                                                    textDirection:
                                                        ui.TextDirection.rtl,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Wrap(
                                                        children: [
                                                          const ListTile(
                                                            title: Text(
                                                              'تأكيد الحذف',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            subtitle: Text(
                                                                'هل انت متأكد؟'),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child:
                                                                    const Text(
                                                                        'إلغاء'),
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  backgroundColor: Colors
                                                                      .red
                                                                      .withOpacity(
                                                                          0.1),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .red
                                                                            .withOpacity(0.3)),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  context
                                                                      .read<
                                                                          InventoryBloc>()
                                                                      .add(
                                                                        DeleteOneTransfer(
                                                                            id: widget.billModel!.id!),
                                                                      );
                                                                },
                                                                child: const Text(
                                                                    'حذف',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red)),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                        ],
                                      )
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitFormAdd() {
    if (_formKey.currentState!.validate()) {
      _isSubmitting = true;
      final model = _fillModelFromForm();
      context.read<InventoryBloc>().add(AddBill(billModel: model));
    }
  }

  void _submitFormUpdate() {
    if (_formKey.currentState!.validate()) {
      _isSubmitting = true;
      final model = _fillModelFromForm();
      context.read<InventoryBloc>().add(
            UpdateBill(billModel: model, id: _currentBillId!),
          );
    }
  }

  void _focusToWarehouse() {
    FocusScope.of(context).requestFocus(_toWarehouseFocusNode);
  }

  void _focusCustomer() {
    FocusScope.of(context).requestFocus(_customerFocusNode);
  }

  void _focusToQuantity(int index) {
    if (index >= 0 && index < _quantityFocusNodes.length) {
      FocusScope.of(context).requestFocus(_quantityFocusNodes[index]);
    }
  }

  void _handleFromWarehouseSearchResults(
    BuildContext context,
    List<WarehousesModel> results,
  ) {
    if (results.length == 1) {
      _isSelectingFromWarehouse = true;
      final selectedFromWarehouse = results.first;
      setState(() {
        _fromWarehouseController.text =
            '${selectedFromWarehouse.code ?? ''}-${selectedFromWarehouse.name ?? ''}';
        _selectedFromWarehouseId = selectedFromWarehouse.id;
      });
      FocusScope.of(context).unfocus();
      _isSelectingFromWarehouse = false;
      // Add this line to focus on to warehouse after selection
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusCustomer());
    } else if (results.length > 1) {
      _showFromWarehouseSelectionDialog(context, results);
    } else {
      _fromWarehouseController.clear();
      setState(() {
        _selectedFromWarehouseId = null;
      });
      showSnackBar(
        context: context,
        content: 'لم يتم العثور على مستودعات مطابقة.',
        failure: true,
      );
    }
  }

  void _handleToWarehouseSearchResults(
    BuildContext context,
    List<WarehousesModel> results,
  ) {
    if (results.length == 1) {
      _isSelectingToWarehouse = true;
      final selectedToWarehouse = results.first;
      setState(() {
        _toWarehouseController.text =
            '${selectedToWarehouse.code ?? ''}-${selectedToWarehouse.name ?? ''}';
        _selectedToWarehouseId = selectedToWarehouse.id;
      });
      FocusScope.of(context).unfocus();
      _isSelectingToWarehouse = false;
      // After to warehouse is selected, focus on first item field if exists
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusCustomer());
    } else if (results.length > 1) {
      _showToWarehouseSelectionDialog(context, results);
    } else {
      _toWarehouseController.clear();
      setState(() {
        _selectedToWarehouseId = null;
      });
      showSnackBar(
        context: context,
        content: 'لم يتم العثور على مستودعات مطابقة.',
        failure: true,
      );
    }
  }

  void _showFromWarehouseSelectionDialog(
    BuildContext context,
    List<WarehousesModel> fromWarehouses,
  ) async {
    _isSelectingFromWarehouse = true;

    final selectedFromWarehouse = await showDialog<WarehousesModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر المستودع'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: fromWarehouses.length,
              itemBuilder: (BuildContext context, int index) {
                final fromWarehouse = fromWarehouses[index];
                return ListTile(
                  title: Text(fromWarehouse.name ?? ''),
                  subtitle: Text(fromWarehouse.code ?? ''),
                  onTap: () {
                    Navigator.pop(context, fromWarehouse);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedFromWarehouse != null) {
      setState(() {
        _fromWarehouseController.text =
            '${selectedFromWarehouse.code ?? ''}-${selectedFromWarehouse.name ?? ''}';
        _selectedFromWarehouseId = selectedFromWarehouse.id;
      });
      FocusScope.of(context).unfocus();
      // Add this line to focus on to warehouse after selection
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusCustomer());
    } else {
      setState(() {
        _fromWarehouseController.clear();
        _selectedFromWarehouseId = null;
      });
    }

    _isSelectingFromWarehouse = false;
  }

  void _showToWarehouseSelectionDialog(
    BuildContext context,
    List<WarehousesModel> toWarehouses,
  ) async {
    _isSelectingToWarehouse = true;

    final selectedToWarehouse = await showDialog<WarehousesModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر المستودع'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: toWarehouses.length,
              itemBuilder: (BuildContext context, int index) {
                final toWarehouse = toWarehouses[index];
                return ListTile(
                  title: Text(toWarehouse.name ?? ''),
                  subtitle: Text(toWarehouse.code ?? ''),
                  onTap: () {
                    Navigator.pop(context, toWarehouse);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedToWarehouse != null) {
      setState(() {
        _toWarehouseController.text =
            '${selectedToWarehouse.code ?? ''}-${selectedToWarehouse.name ?? ''}';
        _selectedToWarehouseId = selectedToWarehouse.id;
      });
      FocusScope.of(context).unfocus();
      _isSelectingToWarehouse = false;
      // After to warehouse is selected, focus on first item field if exists
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusCustomer());
    } else {
      setState(() {
        _toWarehouseController.clear();
        _selectedToWarehouseId = null;
      });
    }

    _isSelectingToWarehouse = false;
  }

  void _handleAccountsSearchResults(
    BuildContext context,
    List<AccountsModel> results,
  ) {
    if (results.length == 1) {
      _isSelectingCustomer = true;
      final selectedCustomer = results.first;
      setState(() {
        _customerController.text = selectedCustomer.name ?? '';
        _selectedCustomerId = selectedCustomer.id;
      });
      FocusScope.of(context).unfocus();
      // After to warehouse is selected, focus on first item field if exists
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusCustomer());
    } else if (results.length > 1) {
      _showAccountsSelectionDialog(context, results);
    } else {
      _customerController.clear();
      setState(() {
        _selectedCustomerId = null;
      });
      showSnackBar(
        context: context,
        content: 'لم يتم العثور على حسابات مطابقة.',
        failure: true,
      );
    }
  }

  void _showAccountsSelectionDialog(
    BuildContext context,
    List<AccountsModel> results,
  ) async {
    final selectedCustomer = await showDialog<AccountsModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر الحساب'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (BuildContext context, int index) {
                final customer = results[index];
                return ListTile(
                  title: Text(customer.account_name ?? ''),
                  onTap: () {
                    Navigator.pop(context, customer);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedCustomer != null) {
      setState(() {
        _customerController.text = selectedCustomer.account_name ?? '';
        _selectedCustomerId = selectedCustomer.id;
      });
      FocusScope.of(context).unfocus();

      // After to warehouse is selected, focus on first item field if exists
      if (_itemNameFocusNodes.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).requestFocus(_itemNameFocusNodes[0]);
        });
      }
    } else {
      setState(() {
        _customerController.clear();
        _selectedCustomerId = null;
      });
    }
  }

  void _showPriceSelectionDialog(int index) {
    final item = _selectedItemData[index];
    // Add a check to ensure item is not null before accessing its properties
    if (item == null) {
      showSnackBar(
        context: context,
        content: 'الرجاء اختيار المادة أولاً للحصول على الأسعار.',
        failure: true,
      );
      return;
    }

    // Ensure default_price is not null and is a List
    final prices = item.default_price ?? [];

    if (prices.isEmpty) {
      showSnackBar(
        context: context,
        content: 'لا توجد أسعار متاحة لهذه المادة.',
        failure: true,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختر السعر'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: prices.map<Widget>((price) {
                // Ensure 'price' is a Map and contains 'list_name' and 'price' keys
                if (price is Map<String, dynamic> &&
                    price.containsKey('list_name') &&
                    price.containsKey('price')) {
                  return ListTile(
                    title: Text('${price['list_name']}'),
                    trailing: Text('${price['price']}'),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _priceControllers[index].text =
                            price['price'].toString();
                      });
                    },
                  );
                }
                return const SizedBox.shrink(); // Hide invalid entries
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showBalanceDialog(int index) {
    final item = _selectedItemData[index];
    if (item == null) {
      showSnackBar(
        context: context,
        content: 'الرجاء اختيار المادة أولاً للحصول على الأرصدة.',
        failure: true,
      );
      return;
    }

    final balances = item.balances ?? [];

    if (balances.isEmpty) {
      showSnackBar(
        context: context,
        content: 'لا توجد أرصدة متاحة لهذه المادة.',
        failure: true,
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text(
              'جرد المادة',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: balances.map<Widget>((balance) {
                  if (balance is Map<String, dynamic> &&
                      balance.containsKey('warehouse_name') &&
                      balance.containsKey('quantity')) {
                    // Parse quantity and check if negative
                    final quantity =
                        double.tryParse(balance['quantity'].toString()) ?? 0;
                    final isNegative = quantity < 0;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              balance['warehouse_name'].toString(),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          Text(
                            balance['quantity'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isNegative ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }).toList(),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          ),
        );
      },
    );
  }

// Helper to focus on the item name field of the newest row
  void _focusOnNewItem() {
    // Use a post frame callback to ensure the new field is in the widget tree.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted && _itemNameFocusNodes.isNotEmpty) {
        FocusScope.of(context).requestFocus(_itemNameFocusNodes.last);
      }
    });
  }

  BillModel _fillModelFromForm() {
    List<Map<String, dynamic>> itemsData = [];
    for (int i = 0; i < _editableItems.length; i++) {
      final itemId = _selectedItemData[i]?.id ?? _editableItems[i]['item'];
      final quantity =
          double.tryParse(_quantityControllers[i].text.replaceAll(',', '')) ??
              0;

      if (itemId != null && quantity > 0) {
        itemsData.add({
          'item': itemId,
          'quantity': quantity,
          'price':
              double.tryParse(_priceControllers[i].text.replaceAll(',', '')) ??
                  0,
          'note': _itemNoteControllers[i].text,
        });
      }
    }

    final transferData = TransferModel(
      id: widget.billModel?.transfer?.id ?? 0,
      serial: int.tryParse(_serialController.text),
      transfer_type: widget.transfer_type,
      date: _dateController.text,
      note: _noteController.text,
      items: itemsData,
      from_warehouse:
          (widget.transfer_type < 100 || widget.transfer_type == 102)
              ? _selectedFromWarehouseId
              : null,
      to_warehouse: (widget.transfer_type < 100 || widget.transfer_type == 101)
          ? _selectedToWarehouseId
          : null,
    );

    return BillModel(
      id: widget.billModel?.id,
      bill_type: widget.bill_type,
      transfer: transferData,
      customer_id: _selectedCustomerId,
      discount_rate:
          double.tryParse(_discountRateController.text.replaceAll(',', '')) ??
              0,
    );
  }

  final _numberFormat = NumberFormat('#,##0.##');

  double _getItemTotal(int index) {
    final quantityText = _quantityControllers[index].text.replaceAll(',', '');
    final priceText = _priceControllers[index].text.replaceAll(',', '');
    final quantity = double.tryParse(quantityText) ?? 0;
    final price = double.tryParse(priceText) ?? 0;
    return quantity * price;
  }

  double get _totalBeforeDiscount {
    double total = 0;
    for (int i = 0; i < _editableItems.length; i++) {
      total += _getItemTotal(i);
    }
    return total;
  }

  double get _discountRate {
    return double.tryParse(_discountRateController.text.replaceAll(',', '')) ??
        0;
  }

  double get _discountAmount {
    return _totalBeforeDiscount * (_discountRate / 100);
  }

  double get _totalAfterDiscount {
    return _totalBeforeDiscount - _discountAmount;
  }

  Widget _buildTotalsSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الإجمالي قبل الخصم:',
                      style: TextStyle(fontSize: 16)),
                  Text(
                    _numberFormat.format(_totalBeforeDiscount),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('نسبة الخصم (%):', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: MyTextField(
                      controller: _discountRateController,
                      labelText: 'الخصم',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('قيمة الخصم:', style: TextStyle(fontSize: 16)),
                  Text(
                    _numberFormat.format(_discountAmount),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('الإجمالي النهائي:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    _numberFormat.format(_totalAfterDiscount),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Column(
      children: [
        // Items list
        Expanded(
          child: ListView.builder(
            itemCount: _editableItems.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Item number and remove button
                      Column(
                        children: [
                          Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (_editableItems.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => _removeItem(index),
                            ),
                        ],
                      ),
                      const SizedBox(width: 8),

                      // Item name field
                      Expanded(
                        flex: 3,
                        child: MyTextField(
                          suffixIcon: SizedBox(
                            width: 20,
                            height: 20,
                            child: _isSearchingItem &&
                                    _currentItemSearchIndex == index
                                ? const Center(
                                    child: SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1.5),
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.warehouse, size: 16),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    tooltip: 'عرض الأرصدة',
                                    onPressed: () => _showBalanceDialog(index),
                                  ),
                          ),
                          controller: _itemNameControllers[index],
                          labelText: 'المادة',
                          validator: (value) {
                            if (index == _editableItems.length - 1 &&
                                (value == null || value.isEmpty)) {
                              return null;
                            }
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال المادة';
                            }

                            return null;
                          },
                          focusNode: _itemNameFocusNodes[index],
                          onSubmitted: (value) => _searchForItem(index),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Unit field
                      Expanded(
                        flex: 1,
                        child: MyTextField(
                          readOnly: true,
                          controller: _itemUnitControllers[index],
                          labelText: 'الوحدة',
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Quantity field
                      Expanded(
                        flex: 1,
                        child: MyTextField(
                          controller: _quantityControllers[index],
                          focusNode: _quantityFocusNodes[index],
                          labelText: 'الكمية',
                          onSubmitted: (value) {
                            // If this is the last item, add a new one and focus it.
                            if (index == _editableItems.length - 1) {
                              _addNewItem();
                              _focusOnNewItem();
                            } else {
                              // Otherwise, move focus to the next item's name field.
                              FocusScope.of(context)
                                  .requestFocus(_itemNameFocusNodes[index + 1]);
                            }
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (value) {
                            if (_itemNameControllers[index].text.isEmpty) {
                              return null;
                            }

                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال الكمية';
                            }
                            if (double.tryParse(value.replaceAll(',', '')) ==
                                null) {
                              return 'الرجاء إدخال رقم صحيح';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      // Price and total section (if user has permissions)
                      if (groups != null &&
                          (groups!.contains('accounting_price') ||
                              groups!.contains('admins') ||
                              groups!.contains('managers')))
                        Expanded(
                          flex: 2,
                          child: MyTextField(
                            controller: _priceControllers[index],
                            labelText: 'السعر',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            suffixIcon: SizedBox(
                              width: 20,
                              height: 20,
                              child: IconButton(
                                icon: const Icon(Icons.price_change, size: 16),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () =>
                                    _showPriceSelectionDialog(index),
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(width: 8),

                      // Note field
                      Expanded(
                        flex: 2,
                        child: MyTextField(
                          controller: _itemNoteControllers[index],
                          labelText: 'البيان',
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (groups != null &&
                          (groups!.contains('accounting_price') ||
                              groups!.contains('admins') ||
                              groups!.contains('managers')))
                        Column(
                          children: [
                            const Text(
                              'الإجمالي',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _numberFormat.format(_getItemTotal(index)),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Add new item button
        Center(
          child: OutlinedButton.icon(
            onPressed: _addNewItem,
            icon: const Icon(Icons.add_circle_outline),
            label: const Text('إضافة مادة جديدة'),
          ),
        ),
        const SizedBox(height: 10),

        // Grand total (if user has permissions)
        if (groups != null &&
            (groups!.contains('accounting_price') ||
                groups!.contains('admins') ||
                groups!.contains('managers')))
          _buildTotalsSummary(),
        const SizedBox(height: 10),

        // Action buttons (Add, Edit, Delete)
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Mybutton(
                  text: 'إضافة',
                  onPressed: _submitFormAdd,
                ),
                if (widget.billModel != null)
                  Mybutton(
                    text: 'تعديل',
                    onPressed: _submitFormUpdate,
                  ),
              ],
            ),
            if (widget.billModel != null)
              IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                tooltip: 'حذف',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Wrap(
                          children: [
                            const ListTile(
                              title: Text(
                                'تأكيد الحذف',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('هل انت متأكد؟'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('إلغاء'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.red.withOpacity(0.1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: Colors.red.withOpacity(0.3)),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context.read<InventoryBloc>().add(
                                          DeleteOneBill(
                                              id: widget.billModel!.id!),
                                        );
                                  },
                                  child: const Text('حذف',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
          ],
        )
      ],
    );
  }
}
