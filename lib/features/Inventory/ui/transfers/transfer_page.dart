import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/models/transfer_model.dart';
import 'package:gmcappclean/features/Inventory/models/warehouses_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/transfers/transfers_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // This import seems unused based on the provided code.

class TransferPage extends StatelessWidget {
  final TransferModel? transferModel;
  final int transfer_type;
  const TransferPage({
    super.key,
    this.transferModel,
    required this.transfer_type,
  });

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
          return TransferPageChild(
            transferModel: transferModel,
            transfer_type: transfer_type,
          );
        },
      ),
    );
  }
}

class TransferPageChild extends StatefulWidget {
  final TransferModel? transferModel;
  final int transfer_type;
  const TransferPageChild({
    super.key,
    this.transferModel,
    required this.transfer_type,
  });

  @override
  State<TransferPageChild> createState() => _TransferPageChildState();
}

class _TransferPageChildState extends State<TransferPageChild> {
  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();
    final arabicFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Cairo-Regular.ttf'),
    );

    // Calculate how many items can fit per page
    const itemsPerPage = 15; // Adjust this based on your testing
    final totalPages = (_editableItems.length / itemsPerPage).ceil();

    for (var pageNum = 0; pageNum < totalPages; pageNum++) {
      final startIndex = pageNum * itemsPerPage;
      final endIndex = min((pageNum + 1) * itemsPerPage, _editableItems.length);
      final pageItems = _editableItems.sublist(startIndex, endIndex);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a5,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header section (same for all pages)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'الرقم: ${_idController.text}',
                      style: pw.TextStyle(font: arabicFont),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.Text(
                      'التاريخ: ${_dateController.text}',
                      style: pw.TextStyle(font: arabicFont),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'من المستودع: ${_fromWarehouseController.text}',
                      style: pw.TextStyle(font: arabicFont, fontSize: 10),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.Text(
                      'إلى المستودع: ${_toWarehouseController.text}',
                      style: pw.TextStyle(font: arabicFont, fontSize: 10),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Text(
                    'البيان: ${_noteController.text}',
                    style: pw.TextStyle(font: arabicFont),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Text(
                    'تفاصيل المواد',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      font: arabicFont,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ),
                pw.SizedBox(height: 10),

                // Table with current page items
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2), // Total
                    1: const pw.FlexColumnWidth(2), // Price
                    2: const pw.FlexColumnWidth(1.5), // Quantity
                    3: const pw.FlexColumnWidth(1.5), // Unit
                    4: const pw.FlexColumnWidth(5), // Item
                    5: const pw.FlexColumnWidth(1), // No.
                  },
                  children: [
                    // Table header
                    pw.TableRow(
                      verticalAlignment: pw.TableCellVerticalAlignment.middle,
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Center(
                            child: pw.Text(
                              'الإجمالي',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: arabicFont,
                                fontSize: 9,
                              ),
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Center(
                            child: pw.Text(
                              'السعر',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: arabicFont,
                                fontSize: 9,
                              ),
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Center(
                            child: pw.Text(
                              'الكمية',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: arabicFont,
                                fontSize: 9,
                              ),
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Center(
                            child: pw.Text(
                              'الوحدة',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: arabicFont,
                                fontSize: 9,
                              ),
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Center(
                            child: pw.Text(
                              'المادة',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: arabicFont,
                                fontSize: 9,
                              ),
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Center(
                            child: pw.Text(
                              '.',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                font: arabicFont,
                                fontSize: 9,
                              ),
                              textDirection: pw.TextDirection.rtl,
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Table data rows
                    for (var i = 0; i < pageItems.length; i++)
                      pw.TableRow(
                        verticalAlignment: pw.TableCellVerticalAlignment.middle,
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Center(
                              child: pw.Text(
                                _numberFormat.format(
                                  _getItemTotal(startIndex + i),
                                ),
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 7,
                                ),
                                textDirection: pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Center(
                              child: pw.Text(
                                _priceControllers[startIndex + i].text,
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 7,
                                ),
                                textDirection: pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Center(
                              child: pw.Text(
                                _quantityControllers[startIndex + i].text,
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 7,
                                ),
                                textDirection: pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Center(
                              child: pw.Text(
                                _itemUnitControllers[startIndex + i].text,
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 7,
                                ),
                                textDirection: pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Center(
                              child: pw.Text(
                                _itemNameControllers[startIndex + i].text
                                    .split('-')
                                    .last
                                    .trim(), // This will split by '-' and take the last part
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 7,
                                ),
                                textDirection: pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Center(
                              child: pw.Text(
                                (startIndex + i + 1).toString(),
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 7,
                                ),
                                textDirection: pw.TextDirection.rtl,
                                textAlign: pw.TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // Footer section
                pw.SizedBox(height: 10),
                if (pageNum ==
                    totalPages - 1) // Show grand total only on last page
                  pw.Align(
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text(
                      'الإجمالي الكلي: ${_numberFormat.format(_grandTotal)}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        font: arabicFont,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ),
                pw.Align(
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Text(
                    ' (صفحة ${pageNum + 1} من $totalPages)',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      font: arabicFont,
                    ),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  void _printTransfer() async {
    try {
      await Printing.layoutPdf(onLayout: _generatePdf);
    } catch (e) {
      showSnackBar(
        context: context,
        content: 'فشل في إنشاء وثيقة الطباعة: $e',
        failure: true,
      );
    }
  }

  final _fromWarehouseController = TextEditingController();
  final _fromWarehouseFocusNode = FocusNode();
  bool _isSelectingFromWarehouse = false;
  int? _selectedFromWarehouseId;

  final _toWarehouseController = TextEditingController();
  final _toWarehouseFocusNode = FocusNode();
  bool _isSelectingToWarehouse = false;
  int? _selectedToWarehouseId;

  final bool _isFormSubmitting =
      false; // This variable is declared but not used to prevent submission state.
  String? _lastSearchField;

  int currentItemSearchPage = 1;
  final ScrollController _scrollController = ScrollController();
  List<ItemsModel> _itemsList = []; // Stores search results for items
  final _idController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _editableItems = [];
  final List<TextEditingController> _itemNameControllers = [];
  final List<TextEditingController> _itemUnitControllers = [];
  final List<TextEditingController> _quantityControllers = [];
  final List<TextEditingController> _priceControllers = [];
  final List<TextEditingController> _itemNoteControllers = [];
  final List<FocusNode> _itemNameFocusNodes = [];
  final List<FocusNode> _quantityFocusNodes = [];
  // Stores the full ItemsModel data for each selected item, crucial for balances and prices
  final List<ItemsModel?> _selectedItemData = [];

  bool _isSelectingItem = false; // Flag to prevent multiple item search dialogs

  int?
  _currentItemSearchIndex; // Index of the item text field currently being searched
  bool _isSearchingItem = false; // Flag for general item search loading
  bool isLoadingMore = false; // Flag for loading more items in search dialog

  @override
  void initState() {
    super.initState();

    if (widget.transferModel != null) {
      // Populate fields from existing transfer model
      _idController.text = widget.transferModel!.serial.toString();
      _dateController.text = widget.transferModel!.date ?? '';
      _noteController.text = widget.transferModel!.note ?? '';
      _fromWarehouseController.text =
          widget.transferModel!.from_warehouse_name ?? '';
      _toWarehouseController.text =
          widget.transferModel!.to_warehouse_name ?? '';
      _selectedFromWarehouseId = widget.transferModel!.from_warehouse;
      _selectedToWarehouseId = widget.transferModel!.to_warehouse;

      if (widget.transferModel!.items != null) {
        // Initialize lists with existing item data
        for (int i = 0; i < widget.transferModel!.items!.length; i++) {
          var item = widget.transferModel!.items![i];

          _editableItems.add(Map<String, dynamic>.from(item));
          _itemNameControllers.add(
            TextEditingController(text: item['item_name']?.toString() ?? ''),
          );
          _itemUnitControllers.add(
            TextEditingController(text: item['item_unit']?.toString() ?? ''),
          );
          _quantityControllers.add(
            TextEditingController(text: item['quantity']?.toString() ?? ''),
          );
          _priceControllers.add(
            TextEditingController(text: item['price']?.toString() ?? ''),
          );
          _itemNoteControllers.add(
            TextEditingController(text: item['note']?.toString() ?? ''),
          );

          // Add quantity focus node
          final quantityFocusNode = FocusNode();
          quantityFocusNode.addListener(
            () => _onQuantityFocusChange(
              _quantityFocusNodes.indexOf(quantityFocusNode),
            ),
          );
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
                Map<String, dynamic>.from(item['item_details'] as Map),
              );
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
      _addNewItem();
    }

    _fromWarehouseFocusNode.addListener(_onFromWarehouseFocusChange);
    _toWarehouseFocusNode.addListener(_onToWarehouseFocusChange);
  }

  @override
  void dispose() {
    _idController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    _disposeItemControllers(); // Dispose all item-related controllers
    _scrollController.dispose(); // Dispose scroll controller

    // Remove listeners and dispose focus nodes for warehouses
    _fromWarehouseFocusNode.removeListener(_onFromWarehouseFocusChange);
    _fromWarehouseFocusNode.dispose();
    _toWarehouseFocusNode.removeListener(_onToWarehouseFocusChange);
    _toWarehouseFocusNode.dispose();

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
      controller.removeListener(
        _updateTotals,
      ); // Remove listener before disposing
      controller.dispose();
    }
    for (var controller in _priceControllers) {
      controller.removeListener(
        _updateTotals,
      ); // Remove listener before disposing
      controller.dispose();
    }
    for (var controller in _itemNoteControllers) {
      controller.dispose();
    }
    for (var node in _itemNameFocusNodes) {
      node.removeListener(
        () {},
      ); // Remove all listeners before disposing, safer than specific one
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
      quantityFocusNode.addListener(
        () => _onQuantityFocusChange(
          _quantityFocusNodes.indexOf(quantityFocusNode),
        ),
      );

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
    if (index >= 0 && index < _quantityFocusNodes.length) {
      if (!_quantityFocusNodes[index].hasFocus) {
        _validateQuantityAgainstInventory(index);
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
      _itemNameFocusNodes[index].removeListener(
        () {},
      ); // Remove all listeners before disposing
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
    // Calling setState here rebuilds the widget and updates the grand total.
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
        _selectedItemData[index] = null; // Clear selected item data
      });
      _updateTotals();
      return;
    }

    setState(() {
      _isSearchingItem = true;
      _currentItemSearchIndex = index;
      _itemsList.clear(); // Clear previous search results for a new search
      currentItemSearchPage = 1; // Reset page for a new search
      isLoadingMore = false; // Reset loading state
    });

    context.read<InventoryBloc>().add(
      SearchItems(search: _itemNameControllers[index].text, page: 1),
    );
  }

  void _onScroll() {
    // Load more items when near the end of the scroll
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.8 &&
        !isLoadingMore) {
      _nextPage();
    }
  }

  void _nextPage() {
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

  Future<void> _showItemSearchDialog(int index) async {
    _scrollController.addListener(_onScroll);

    final selectedItem = await showDialog<ItemsModel?>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: ui.TextDirection.rtl, // Force RTL direction
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
                        // Display items list
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
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
                  actionsAlignment:
                      MainAxisAlignment.start, // Align actions to the right
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(null);
                      },
                      child: const Text(
                        'إلغاء',
                        textDirection: ui.TextDirection.rtl,
                      ),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.centerRight, // Align dialog to right
                );
              },
            ),
          ),
        );
      },
    );

    _scrollController.removeListener(_onScroll);
    setState(() {
      _isSearchingItem = false;
      _currentItemSearchIndex = null;

      if (selectedItem != null) {
        _editableItems[index]['item'] = selectedItem.id;
        _itemNameControllers[index].text =
            '${selectedItem.code ?? ''}-${selectedItem.name ?? ''}';
        _itemUnitControllers[index].text = selectedItem.unit ?? '';
        _selectedItemData[index] = selectedItem;

        // Set the price from "A" list if available
        final defaultPriceA = selectedItem.default_price?.firstWhere(
          (price) => price['list_name'] == 'A',
          orElse: () => <String, dynamic>{},
        );
        if (defaultPriceA.isNotEmpty && defaultPriceA.containsKey('price')) {
          _priceControllers[index].text = defaultPriceA['price'].toString();
        } else {
          _priceControllers[index].clear();
        }
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.transferModel == null ? 'إضافة المناقلة' : 'تعديل المناقلة',
          ),
          actions: [
            IconButton(
              onPressed: _printTransfer,
              icon: const Icon(Icons.print),
            ),
          ],
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess<TransferModel>) {
              showSnackBar(context: context, content: 'تم', failure: false);
              Navigator.pop(context); // Pop current page
              // Navigate to transfers list and replace the current route
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return TransfersListPage(
                      transfer_type: widget.transfer_type,
                    );
                  },
                ),
              );
            } else if (state is InventoryError) {
              setState(() {
                _isSearchingItem = false;
                _currentItemSearchIndex = null;
                // Only clear fields if the error is related to the current item search
                // and the field is still associated with that search.
                if (_currentItemSearchIndex != null &&
                    _itemNameControllers[_currentItemSearchIndex!]
                        .text
                        .isNotEmpty) {
                  _itemNameControllers[_currentItemSearchIndex!].clear();
                  _editableItems[_currentItemSearchIndex!]['item'] = null;
                  _itemUnitControllers[_currentItemSearchIndex!].clear();
                  _quantityControllers[_currentItemSearchIndex!].clear();
                  _priceControllers[_currentItemSearchIndex!].clear();
                  _itemNoteControllers[_currentItemSearchIndex!].clear();
                  _selectedItemData[_currentItemSearchIndex!] =
                      null; // Clear selected item data
                }
              });
              _updateTotals();
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
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
                    // Clear fields if no results found for initial search
                    _itemNameControllers[_currentItemSearchIndex!].clear();
                    _editableItems[_currentItemSearchIndex!]['item'] = null;
                    _itemUnitControllers[_currentItemSearchIndex!].clear();
                    _quantityControllers[_currentItemSearchIndex!].clear();
                    _priceControllers[_currentItemSearchIndex!].clear();
                    _itemNoteControllers[_currentItemSearchIndex!].clear();
                    _selectedItemData[_currentItemSearchIndex!] =
                        null; // Clear selected item data
                  } else if (_itemsList.length == 1 &&
                      currentItemSearchPage == 1) {
                    final item = _itemsList.first;
                    _editableItems[_currentItemSearchIndex!]['item'] = item.id;
                    _itemNameControllers[_currentItemSearchIndex!].text =
                        '${item.code ?? ''}-${item.name ?? ''}';
                    _itemUnitControllers[_currentItemSearchIndex!].text =
                        item.unit ?? '';
                    _selectedItemData[_currentItemSearchIndex!] =
                        item; // Store the single found item

                    // Set the price from "A" list if available
                    final defaultPriceA = item.default_price?.firstWhere(
                      (price) => price['list_name'] == 'A',
                      orElse: () =>
                          <String, dynamic>{}, // Provide a default empty map
                    );
                    // Only update price if it's currently empty, or if specifically triggered
                    if (_priceControllers[_currentItemSearchIndex!]
                        .text
                        .isEmpty) {
                      if (defaultPriceA.isNotEmpty &&
                          defaultPriceA.containsKey('price')) {
                        _priceControllers[_currentItemSearchIndex!].text =
                            defaultPriceA['price'].toString();
                      } else {
                        _priceControllers[_currentItemSearchIndex!].clear();
                      }
                    }
                  } else if (_itemsList.length > 1 &&
                      currentItemSearchPage == 1) {
                    if (!_isSelectingItem) {
                      _isSelectingItem =
                          true; // Set flag to indicate dialog is opening
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          _showItemSearchDialog(_currentItemSearchIndex!).then((
                            _,
                          ) {
                            _isSelectingItem =
                                false; // Reset flag after dialog closes
                          });
                        }
                      });
                    }
                  }
                }
              });
              _updateTotals(); // Recalculate total after item search results
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
              // Clear warehouse fields if search failed and they are empty
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
            }
          },
          builder: (context, state) {
            bool isLoadingSearch = state is InventoryLoading;
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
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 7,
                                      child: MyTextField(
                                        readOnly: true,
                                        controller: _dateController,
                                        labelText: 'تاريخ المناقلة',
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
                                              _dateController.text = DateFormat(
                                                'yyyy-MM-dd',
                                              ).format(pickedDate);
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
                                    const SizedBox(width: 7),
                                    Expanded(
                                      flex: 3,
                                      child: MyTextField(
                                        readOnly: true,
                                        controller: _idController,
                                        labelText: 'الرقم',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                MyTextField(
                                  controller: _fromWarehouseController,
                                  labelText: 'من المستودع',
                                  focusNode: _fromWarehouseFocusNode,
                                  suffixIcon:
                                      (_fromWarehouseController.text.isNotEmpty
                                      ? (isLoadingSearch &&
                                                _lastSearchField == 'from'
                                            ? const Padding(
                                                padding: EdgeInsets.all(10),
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              )
                                            : IconButton(
                                                icon: const Icon(Icons.clear),
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
                                ),
                                const SizedBox(height: 7),
                                MyTextField(
                                  controller: _toWarehouseController,
                                  labelText: 'إلى المستودع',
                                  focusNode: _toWarehouseFocusNode,
                                  suffixIcon:
                                      (_toWarehouseController.text.isNotEmpty
                                      ? (isLoadingSearch &&
                                                _lastSearchField == 'to'
                                            ? const Padding(
                                                padding: EdgeInsets.all(10),
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                ),
                                              )
                                            : IconButton(
                                                icon: const Icon(Icons.clear),
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
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _editableItems.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
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
                                                width: 24, // Single space width
                                                height: 24, // Fixed height
                                                child:
                                                    _isSearchingItem &&
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
                                                          Icons.warehouse,
                                                          size: 18,
                                                        ),
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(),
                                                        tooltip: 'عرض الأرصدة',
                                                        onPressed: () =>
                                                            _showBalanceDialog(
                                                              index,
                                                            ),
                                                      ),
                                              ),
                                              controller:
                                                  _itemNameControllers[index],
                                              labelText: 'المادة',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'الرجاء إدخال المادة';
                                                }
                                                return null;
                                              },
                                              focusNode:
                                                  _itemNameFocusNodes[index],
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
                                            flex: 2,
                                            child: MyTextField(
                                              readOnly: true,
                                              controller:
                                                  _itemUnitControllers[index],
                                              labelText: 'الوحدة',
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            flex: 1,
                                            child: MyTextField(
                                              controller:
                                                  _quantityControllers[index],
                                              focusNode:
                                                  _quantityFocusNodes[index], // Add this line
                                              labelText: 'الكمية',
                                              keyboardType:
                                                  const TextInputType.numberWithOptions(
                                                    decimal: true,
                                                  ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'الرجاء إدخال الكمية';
                                                }
                                                if (double.tryParse(
                                                      value.replaceAll(',', ''),
                                                    ) ==
                                                    null) {
                                                  return 'الرجاء إدخال رقم صحيح';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            flex: 2,
                                            child: MyTextField(
                                              controller:
                                                  _priceControllers[index],
                                              labelText: 'السعر',
                                              keyboardType:
                                                  const TextInputType.numberWithOptions(
                                                    decimal: true,
                                                  ),
                                              suffixIcon: SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.price_change,
                                                    size: 20,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () {
                                                    _showPriceSelectionDialog(
                                                      index,
                                                    );
                                                  },
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'الرجاء إدخال السعر';
                                                }
                                                if (double.tryParse(
                                                      value.replaceAll(',', ''),
                                                    ) ==
                                                    null) {
                                                  return 'الرجاء إدخال رقم صحيح';
                                                }
                                                return null;
                                              },
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
                                                  _itemNoteControllers[index],
                                              labelText: 'البيان',
                                              maxLines: 2,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              'الإجمالي: ${_numberFormat.format(_getItemTotal(index))}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
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
                          Text(
                            'الإجمالي الكلي: ${_numberFormat.format(_grandTotal)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          state is InventoryLoading
                              ? const Loader()
                              : Mybutton(
                                  text: widget.transferModel == null
                                      ? 'إضافة المناقلة'
                                      : 'تعديل المناقلة',
                                  onPressed: _submitForm,
                                ),
                          const SizedBox(height: 30),
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
    } else {
      setState(() {
        _toWarehouseController.clear();
        _selectedToWarehouseId = null;
      });
    }

    _isSelectingToWarehouse = false;
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
                        _priceControllers[index].text = price['price']
                            .toString();
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
                        vertical: 8,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Row(
                        spacing: 20,
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

  void _submitForm() {
    // Validate the form. If any field's validator returns a string (error), it will be caught here.
    if (_formKey.currentState!.validate()) {
      final model = _fillModelFromForm();
      if (widget.transferModel == null) {
        context.read<InventoryBloc>().add(AddTransfer(transferModel: model));
      } else {
        context.read<InventoryBloc>().add(
          UpdateTransfer(transferModel: model, id: widget.transferModel!.id),
        );
      }
    }
  }

  TransferModel _fillModelFromForm() {
    List<Map<String, dynamic>> itemsData = [];
    for (int i = 0; i < _editableItems.length; i++) {
      // Ensure 'item' ID is taken from _selectedItemData or _editableItems
      final itemId = _selectedItemData[i]?.id ?? _editableItems[i]['item'];

      itemsData.add({
        'item':
            itemId, // Use the ID from the selected ItemsModel or existing item data
        'quantity':
            double.tryParse(_quantityControllers[i].text.replaceAll(',', '')) ??
            0,
        'price':
            double.tryParse(_priceControllers[i].text.replaceAll(',', '')) ?? 0,
        'note': _itemNoteControllers[i].text,
        // No need to send item_name, item_unit, item_details back to API for submission if 'item' ID is enough
      });
    }

    return TransferModel(
      id: widget.transferModel?.id ?? 0, // Keep existing ID for update
      transfer_type: widget.transfer_type,
      date: _dateController.text,
      note: _noteController.text,
      items: itemsData,
      serial: widget.transferModel?.serial, // Keep existing serial for update
      from_warehouse: _selectedFromWarehouseId, // Use selected ID
      to_warehouse: _selectedToWarehouseId, // Use selected ID
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

  double get _grandTotal {
    double total = 0;
    for (int i = 0; i < _editableItems.length; i++) {
      total += _getItemTotal(i);
    }
    return total;
  }
}
