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
import 'package:gmcappclean/features/Inventory/models/manufacturing/finished_items_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/finished_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/main_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/raw_items_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/manufacturing/raw_manufacturing_model.dart';
import 'package:gmcappclean/features/Inventory/models/warehouses_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/manufacturing/manufacturing_list_page.dart';
import 'package:gmcappclean/features/production_management/production/bloc/production_bloc.dart';
import 'package:gmcappclean/features/production_management/production/models/brief_production_model.dart';
import 'package:gmcappclean/features/production_management/production/models/full_production_model.dart';
import 'package:gmcappclean/features/production_management/production/services/production_services.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_full_data_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

class ManufacturingPage extends StatelessWidget {
  final MainManufacturingModel? mainModel;
  const ManufacturingPage({
    super.key,
    this.mainModel,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InventoryBloc(
            InventoryServices(
              apiClient: getIt<ApiClient>(),
              authInteractor: getIt<AuthInteractor>(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProductionBloc(
            ProductionServices(
              apiClient: getIt<ApiClient>(),
              authInteractor: getIt<AuthInteractor>(),
            ),
          ),
        ),
      ],
      child: ManufacturingPageChild(
        mainModel: mainModel,
      ),
    );
  }
}

class ManufacturingPageChild extends StatefulWidget {
  final MainManufacturingModel? mainModel;
  const ManufacturingPageChild({super.key, this.mainModel});

  @override
  State<ManufacturingPageChild> createState() => _ManufacturingPageChildState();
}

class _ManufacturingPageChildState extends State<ManufacturingPageChild> {
  BriefProductionModel? _selectedProduction;
  bool _isLoadingProduction = false;
  int? _currentId;
  final _fromWarehouseController = TextEditingController();
  final _fromWarehouseFocusNode = FocusNode();
  bool _isSelectingFromWarehouse = false;
  int? _selectedFromWarehouseId;
  final _batchLevelController = TextEditingController();
  final _toWarehouseController = TextEditingController();
  final _toWarehouseFocusNode = FocusNode();
  bool _isSelectingToWarehouse = false;
  int? _selectedToWarehouseId;
  final _serialFocusNode = FocusNode();
  String? _lastSearchField;
  int currentItemSearchPage = 1;
  final ScrollController _scrollController = ScrollController();
  final _serialController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // For raw materials (input items)
  final List<Map<String, dynamic>> _rawItems = [];
  final List<TextEditingController> _rawItemNameControllers = [];
  final List<TextEditingController> _rawItemUnitControllers = [];
  final List<TextEditingController> _rawQuantityControllers = [];
  final List<TextEditingController> _rawItemNoteControllers = [];
  final List<FocusNode> _rawItemNameFocusNodes = [];
  final List<FocusNode> _rawQuantityFocusNodes = [];
  final List<ItemsModel?> _rawSelectedItemData = [];

  // For finished products (output items)
  final List<Map<String, dynamic>> _finishedItems = [];
  final List<TextEditingController> _finishedItemNameControllers = [];
  final List<TextEditingController> _finishedItemUnitControllers = [];
  final List<TextEditingController> _finishedQuantityControllers = [];
  final List<TextEditingController> _finishedItemNoteControllers = [];
  final List<FocusNode> _finishedItemNameFocusNodes = [];
  final List<FocusNode> _finishedQuantityFocusNodes = [];
  final List<ItemsModel?> _finishedSelectedItemData = [];

  final List<TextEditingController> _rawWarehouseControllers = [];
  final List<FocusNode> _rawWarehouseFocusNodes = [];
  final List<int?> _rawSelectedWarehouseIds = [];
  final List<bool> _isSelectingRawWarehouse = [];

  final List<TextEditingController> _finishedWarehouseControllers = [];
  final List<FocusNode> _finishedWarehouseFocusNodes = [];
  final List<int?> _finishedSelectedWarehouseIds = [];
  final List<bool> _isSelectingFinishedWarehouse = [];
  bool _isLoading = false;
  bool _isSelectingItem = false;
  int? _currentItemSearchIndex;
  bool _isSearchingItem = false;
  bool isLoadingMore = false;
  List<ItemsModel> _itemsList = [];
  bool _isRawItem =
      true; // Flag to track if we're editing raw or finished items

  @override
  void initState() {
    super.initState();
    _serialFocusNode.addListener(_onSerialFocusChange);
    if (widget.mainModel != null) {
      // Populate fields from existing manufacturing model
      _currentId = widget.mainModel?.id;
      _serialController.text = widget.mainModel!.serial.toString();
      _dateController.text = widget.mainModel!.date ?? '';
      _noteController.text = widget.mainModel!.note ?? '';
      _fromWarehouseController.text =
          widget.mainModel!.raw_warehouse_name ?? '';
      _toWarehouseController.text =
          widget.mainModel!.finished_warehouse_name ?? '';
      _selectedFromWarehouseId = widget.mainModel!.raw_warehouse;
      _selectedToWarehouseId = widget.mainModel!.finished_warehouse;
      _batchLevelController.text =
          widget.mainModel!.batch_level?.toString() ?? "";

      if (widget.mainModel!.batch_number != null) {
        _selectedProduction = BriefProductionModel(
          id: widget.mainModel!.batch_number!,
          batch_number: widget.mainModel!.batch_code ?? '',
        );
      } else {
        _selectedProduction = null; // Ensure it's null if no batch
      }
      // Initialize raw materials (input items)
      if (widget.mainModel?.rawManufacturingModel?.items != null) {
        for (var item in widget.mainModel!.rawManufacturingModel!.items!) {
          _rawItems.add(Map<String, dynamic>.from(item.toMap()));

          _rawItemNameControllers.add(
              TextEditingController(text: item.item_name?.toString() ?? ''));
          _rawItemUnitControllers.add(
              TextEditingController(text: item.item_unit?.toString() ?? ''));
          _rawQuantityControllers.add(
              TextEditingController(text: item.quantity?.toString() ?? ''));
          _rawItemNoteControllers
              .add(TextEditingController(text: item.note?.toString() ?? ''));
          _rawWarehouseControllers.add(
            TextEditingController(
                text: item.from_warehouse_name?.toString() ??
                    widget.mainModel!.raw_warehouse_name ??
                    ''),
          );
          final rawWarehouseFocusNode = FocusNode();
          rawWarehouseFocusNode.addListener(() => _onRawWarehouseFocusChange(
              _rawWarehouseFocusNodes.indexOf(rawWarehouseFocusNode)));
          _rawWarehouseFocusNodes.add(rawWarehouseFocusNode);
          _rawSelectedWarehouseIds.add(item.from_warehouse);
          _isSelectingRawWarehouse.add(false);
          final rawFocusNode = FocusNode();
          rawFocusNode.addListener(() => _onRawItemFocusNodeChange(
              _rawItemNameFocusNodes.indexOf(rawFocusNode)));
          _rawItemNameFocusNodes.add(rawFocusNode);

          final rawQuantityFocusNode = FocusNode();
          rawQuantityFocusNode.addListener(() => _onRawQuantityFocusChange(
              _rawQuantityFocusNodes.indexOf(rawQuantityFocusNode)));
          _rawQuantityFocusNodes.add(rawQuantityFocusNode);

          // Parse item details if available
          ItemsModel? selectedItem;
          if (item.item_details != null) {
            try {
              // Check if item_details is already an ItemsModel
              if (item.item_details is ItemsModel) {
                selectedItem = item.item_details as ItemsModel;
              } else {
                selectedItem = ItemsModel.fromMap(
                    Map<String, dynamic>.from(item.item_details as Map));
              }
            } catch (e) {
              debugPrint('Error parsing raw item_details: $e');
            }
          }
          _rawSelectedItemData.add(selectedItem);
        }
      }

      // Initialize finished products (output items)
      if (widget.mainModel?.finishedItemsManufacturingModel?.items != null) {
        for (var item
            in widget.mainModel!.finishedItemsManufacturingModel!.items!) {
          _finishedItems.add(Map<String, dynamic>.from(item.toMap()));
          _finishedItemNameControllers.add(
              TextEditingController(text: item.item_name?.toString() ?? ''));
          _finishedItemUnitControllers.add(
              TextEditingController(text: item.item_unit?.toString() ?? ''));
          _finishedQuantityControllers.add(
              TextEditingController(text: item.quantity?.toString() ?? ''));
          _finishedItemNoteControllers
              .add(TextEditingController(text: item.note?.toString() ?? ''));
          _finishedWarehouseControllers.add(
            TextEditingController(
                text: item.to_warehouse_name?.toString() ??
                    widget.mainModel!.finished_warehouse_name ??
                    ''),
          );
          final finishedWarehouseFocusNode = FocusNode();
          finishedWarehouseFocusNode.addListener(() =>
              _onFinishedWarehouseFocusChange(_finishedWarehouseFocusNodes
                  .indexOf(finishedWarehouseFocusNode)));
          _finishedWarehouseFocusNodes.add(finishedWarehouseFocusNode);
          _finishedSelectedWarehouseIds.add(item.to_warehouse);
          _isSelectingFinishedWarehouse.add(false);
          final finishedFocusNode = FocusNode();
          finishedFocusNode.addListener(() => _onFinishedItemFocusNodeChange(
              _finishedItemNameFocusNodes.indexOf(finishedFocusNode)));
          _finishedItemNameFocusNodes.add(finishedFocusNode);

          final finishedQuantityFocusNode = FocusNode();
          finishedQuantityFocusNode.addListener(() =>
              _onFinishedQuantityFocusChange(_finishedQuantityFocusNodes
                  .indexOf(finishedQuantityFocusNode)));
          _finishedQuantityFocusNodes.add(finishedQuantityFocusNode);

          // Parse item details if available
          ItemsModel? selectedItem;
          if (item.item_details != null) {
            try {
              // Check if item_details is already an ItemsModel
              if (item.item_details is ItemsModel) {
                selectedItem = item.item_details as ItemsModel;
              } else {
                selectedItem = ItemsModel.fromMap(
                    Map<String, dynamic>.from(item.item_details as Map));
              }
            } catch (e) {
              debugPrint('Error parsing finished item_details: $e');
            }
          }
          _finishedSelectedItemData.add(selectedItem);
        }
      }
    } else {
      // For new manufacturing, set current date and add one empty row for each
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _addNewRawItem();
      _addNewFinishedItem();
    }

    _fromWarehouseFocusNode.addListener(_onFromWarehouseFocusChange);
    _toWarehouseFocusNode.addListener(_onToWarehouseFocusChange);
  }

  @override
  void dispose() {
    _serialController.dispose();
    _serialFocusNode.dispose();
    _dateController.dispose();
    _noteController.dispose();
    _disposeRawItemControllers();
    _disposeFinishedItemControllers();
    _scrollController.dispose();

    _fromWarehouseFocusNode.removeListener(_onFromWarehouseFocusChange);
    _fromWarehouseFocusNode.dispose();
    _toWarehouseFocusNode.removeListener(_onToWarehouseFocusChange);
    _toWarehouseFocusNode.dispose();

    super.dispose();
  }

  void _disposeRawItemControllers() {
    for (var controller in _rawItemNameControllers) {
      controller.dispose();
    }
    for (var controller in _rawItemUnitControllers) {
      controller.dispose();
    }
    for (var controller in _rawQuantityControllers) {
      controller.dispose();
    }
    for (var controller in _rawItemNoteControllers) {
      controller.dispose();
    }
    for (var node in _rawItemNameFocusNodes) {
      node.dispose();
    }
    for (var node in _rawQuantityFocusNodes) {
      node.dispose();
    }
    for (var controller in _rawWarehouseControllers) {
      controller.dispose();
    }
    for (var node in _rawWarehouseFocusNodes) {
      node.dispose();
    }
    _rawItems.clear();
    _rawItemNameControllers.clear();
    _rawItemUnitControllers.clear();
    _rawQuantityControllers.clear();
    _rawItemNoteControllers.clear();
    _rawItemNameFocusNodes.clear();
    _rawQuantityFocusNodes.clear();
    _rawSelectedItemData.clear();
    _rawWarehouseControllers.clear();
    _rawWarehouseFocusNodes.clear();
    _rawSelectedWarehouseIds.clear();
    _isSelectingRawWarehouse.clear();
  }

  void _disposeFinishedItemControllers() {
    for (var controller in _finishedItemNameControllers) {
      controller.dispose();
    }
    for (var controller in _finishedItemUnitControllers) {
      controller.dispose();
    }
    for (var controller in _finishedQuantityControllers) {
      controller.dispose();
    }
    for (var controller in _finishedItemNoteControllers) {
      controller.dispose();
    }
    for (var node in _finishedItemNameFocusNodes) {
      node.dispose();
    }
    for (var node in _finishedQuantityFocusNodes) {
      node.dispose();
    }
    for (var controller in _finishedWarehouseControllers) {
      controller.dispose();
    }
    for (var node in _finishedWarehouseFocusNodes) {
      node.dispose();
    }
    _finishedItems.clear();
    _finishedItemNameControllers.clear();
    _finishedItemUnitControllers.clear();
    _finishedQuantityControllers.clear();
    _finishedItemNoteControllers.clear();
    _finishedItemNameFocusNodes.clear();
    _finishedQuantityFocusNodes.clear();
    _finishedSelectedItemData.clear();
    _finishedWarehouseControllers.clear();
    _finishedWarehouseFocusNodes.clear();
    _finishedSelectedWarehouseIds.clear();
    _isSelectingFinishedWarehouse.clear();
  }

  void _addNewRawItem() {
    setState(() {
      _rawItems.add({
        'item': null,
        'item_name': '',
        'item_unit': '',
        'quantity': '',
        'note': '',
        'warehouse': null,
        'warehouse_name': '',
      });
      _rawItemNameControllers.add(TextEditingController());
      _rawItemUnitControllers.add(TextEditingController());
      _rawQuantityControllers.add(TextEditingController());
      _rawItemNoteControllers.add(TextEditingController());

      final newFocusNode = FocusNode();
      newFocusNode.addListener(() => _onRawItemFocusNodeChange(
          _rawItemNameFocusNodes.indexOf(newFocusNode)));
      _rawItemNameFocusNodes.add(newFocusNode);

      final newQuantityFocusNode = FocusNode();
      newQuantityFocusNode.addListener(() => _onRawQuantityFocusChange(
          _rawQuantityFocusNodes.indexOf(newQuantityFocusNode)));
      _rawQuantityFocusNodes.add(newQuantityFocusNode);

      _rawSelectedItemData.add(null);

      _rawWarehouseControllers.add(TextEditingController());
      final newWarehouseFocusNode = FocusNode();
      newWarehouseFocusNode.addListener(() => _onRawWarehouseFocusChange(
          _rawWarehouseFocusNodes.indexOf(newWarehouseFocusNode)));
      _rawWarehouseFocusNodes.add(newWarehouseFocusNode);
      _rawSelectedWarehouseIds.add(null);
      _isSelectingRawWarehouse.add(false);
    });
  }

  void _addNewFinishedItem() {
    setState(() {
      _finishedItems.add({
        'item': null,
        'item_name': '',
        'item_unit': '',
        'quantity': '',
        'note': '',
        'warehouse': null,
        'warehouse_name': '',
      });
      _finishedItemNameControllers.add(TextEditingController());
      _finishedItemUnitControllers.add(TextEditingController());
      _finishedQuantityControllers.add(TextEditingController());
      _finishedItemNoteControllers.add(TextEditingController());

      final newFocusNode = FocusNode();
      newFocusNode.addListener(() => _onFinishedItemFocusNodeChange(
          _finishedItemNameFocusNodes.indexOf(newFocusNode)));
      _finishedItemNameFocusNodes.add(newFocusNode);

      final newQuantityFocusNode = FocusNode();
      newQuantityFocusNode.addListener(() => _onFinishedQuantityFocusChange(
          _finishedQuantityFocusNodes.indexOf(newQuantityFocusNode)));
      _finishedQuantityFocusNodes.add(newQuantityFocusNode);

      _finishedSelectedItemData.add(null);
      _finishedWarehouseControllers.add(TextEditingController());
      final newWarehouseFocusNode = FocusNode();
      newWarehouseFocusNode.addListener(() => _onFinishedWarehouseFocusChange(
          _finishedWarehouseFocusNodes.indexOf(newWarehouseFocusNode)));
      _finishedWarehouseFocusNodes.add(newWarehouseFocusNode);
      _finishedSelectedWarehouseIds.add(null);
      _isSelectingFinishedWarehouse.add(false);
    });
  }

  void _onRawWarehouseFocusChange(int index) {
    if (!_rawWarehouseFocusNodes[index].hasFocus &&
        _rawWarehouseControllers[index].text.isNotEmpty &&
        !_isSelectingRawWarehouse[index]) {
      _searchForRawWarehouse(index);
    } else if (!_rawWarehouseFocusNodes[index].hasFocus &&
        _rawWarehouseControllers[index].text.isEmpty) {
      setState(() {
        _rawSelectedWarehouseIds[index] = null;
        _rawItems[index]['warehouse'] = null;
        _rawItems[index]['warehouse_name'] = '';
      });
    }
  }

  void _onFinishedWarehouseFocusChange(int index) {
    if (!_finishedWarehouseFocusNodes[index].hasFocus &&
        _finishedWarehouseControllers[index].text.isNotEmpty &&
        !_isSelectingFinishedWarehouse[index]) {
      _searchForFinishedWarehouse(index);
    } else if (!_finishedWarehouseFocusNodes[index].hasFocus &&
        _finishedWarehouseControllers[index].text.isEmpty) {
      setState(() {
        _finishedSelectedWarehouseIds[index] = null;
        _finishedItems[index]['warehouse'] = null;
        _finishedItems[index]['warehouse_name'] = '';
      });
    }
  }

  void _searchForRawWarehouse(int index) {
    if (_rawWarehouseControllers[index].text.isEmpty) {
      setState(() {
        _rawSelectedWarehouseIds[index] = null;
        _rawItems[index]['warehouse'] = null;
        _rawItems[index]['warehouse_name'] = '';
      });
      return;
    }

    setState(() {
      _isSelectingRawWarehouse[index] = true;
    });

    context.read<InventoryBloc>().add(
          SearchWarehouse(
            search: _rawWarehouseControllers[index].text,
            page: 1,
          ),
        );
  }

  void _searchForFinishedWarehouse(int index) {
    if (_finishedWarehouseControllers[index].text.isEmpty) {
      setState(() {
        _finishedSelectedWarehouseIds[index] = null;
        _finishedItems[index]['warehouse'] = null;
        _finishedItems[index]['warehouse_name'] = '';
      });
      return;
    }

    setState(() {
      _isSelectingFinishedWarehouse[index] = true;
    });

    context.read<InventoryBloc>().add(
          SearchWarehouse(
            search: _finishedWarehouseControllers[index].text,
            page: 1,
          ),
        );
  }

  Future<void> _showRawWarehouseSelectionDialog(
      int index, List<WarehousesModel> warehouses) async {
    _isSelectingRawWarehouse[index] = true;

    final selectedWarehouse = await showDialog<WarehousesModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر المستودع'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: warehouses.length,
              itemBuilder: (BuildContext context, int i) {
                final warehouse = warehouses[i];
                return ListTile(
                  title: Text(warehouse.name ?? ''),
                  subtitle: Text(warehouse.code ?? ''),
                  onTap: () {
                    Navigator.pop(context, warehouse);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedWarehouse != null) {
      setState(() {
        _rawWarehouseControllers[index].text =
            '${selectedWarehouse.code ?? ''}-${selectedWarehouse.name ?? ''}';
        _rawSelectedWarehouseIds[index] = selectedWarehouse.id;
        _rawItems[index]['warehouse'] = selectedWarehouse.id;
        _rawItems[index]['warehouse_name'] = selectedWarehouse.name;
      });
    }

    _isSelectingRawWarehouse[index] = false;
  }

  Future<void> _showFinishedWarehouseSelectionDialog(
      int index, List<WarehousesModel> warehouses) async {
    _isSelectingFinishedWarehouse[index] = true;

    final selectedWarehouse = await showDialog<WarehousesModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر المستودع'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: warehouses.length,
              itemBuilder: (BuildContext context, int i) {
                final warehouse = warehouses[i];
                return ListTile(
                  title: Text(warehouse.name ?? ''),
                  subtitle: Text(warehouse.code ?? ''),
                  onTap: () {
                    Navigator.pop(context, warehouse);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedWarehouse != null) {
      setState(() {
        _finishedWarehouseControllers[index].text =
            '${selectedWarehouse.code ?? ''}-${selectedWarehouse.name ?? ''}';
        _finishedSelectedWarehouseIds[index] = selectedWarehouse.id;
        _finishedItems[index]['warehouse'] = selectedWarehouse.id;
        _finishedItems[index]['warehouse_name'] = selectedWarehouse.name;
      });
    }

    _isSelectingFinishedWarehouse[index] = false;
  }

  void _removeRawItem(int index) {
    setState(() {
      _rawItemNameControllers[index].dispose();
      _rawItemUnitControllers[index].dispose();
      _rawQuantityControllers[index].dispose();
      _rawItemNoteControllers[index].dispose();
      _rawItemNameFocusNodes[index].dispose();
      _rawQuantityFocusNodes[index].dispose();

      _rawItems.removeAt(index);
      _rawItemNameControllers.removeAt(index);
      _rawItemUnitControllers.removeAt(index);
      _rawQuantityControllers.removeAt(index);
      _rawItemNoteControllers.removeAt(index);
      _rawItemNameFocusNodes.removeAt(index);
      _rawQuantityFocusNodes.removeAt(index);
      _rawSelectedItemData.removeAt(index);
    });
  }

  void _removeFinishedItem(int index) {
    setState(() {
      _finishedItemNameControllers[index].dispose();
      _finishedItemUnitControllers[index].dispose();
      _finishedQuantityControllers[index].dispose();
      _finishedItemNoteControllers[index].dispose();
      _finishedItemNameFocusNodes[index].dispose();
      _finishedQuantityFocusNodes[index].dispose();

      _finishedItems.removeAt(index);
      _finishedItemNameControllers.removeAt(index);
      _finishedItemUnitControllers.removeAt(index);
      _finishedQuantityControllers.removeAt(index);
      _finishedItemNoteControllers.removeAt(index);
      _finishedItemNameFocusNodes.removeAt(index);
      _finishedQuantityFocusNodes.removeAt(index);
      _finishedSelectedItemData.removeAt(index);
    });
  }

  void _onRawItemFocusNodeChange(int index) {
    if (!_rawItemNameFocusNodes[index].hasFocus &&
        _rawItemNameControllers[index].text.isEmpty) {
      setState(() {
        _rawItems[index]['item'] = null;
        _rawItemUnitControllers[index].clear();
        _rawQuantityControllers[index].clear();
        _rawItemNoteControllers[index].clear();
        _rawSelectedItemData[index] = null;
      });
    } else if (!_rawItemNameFocusNodes[index].hasFocus &&
        _rawItemNameControllers[index].text.isNotEmpty &&
        !_isSelectingItem) {
      _searchForRawItem(index);
    }
  }

  void _onFinishedItemFocusNodeChange(int index) {
    if (!_finishedItemNameFocusNodes[index].hasFocus &&
        _finishedItemNameControllers[index].text.isEmpty) {
      setState(() {
        _finishedItems[index]['item'] = null;
        _finishedItemUnitControllers[index].clear();
        _finishedQuantityControllers[index].clear();
        _finishedItemNoteControllers[index].clear();
        _finishedSelectedItemData[index] = null;
      });
    } else if (!_finishedItemNameFocusNodes[index].hasFocus &&
        _finishedItemNameControllers[index].text.isNotEmpty &&
        !_isSelectingItem) {
      _searchForFinishedItem(index);
    }
  }

  void _onRawQuantityFocusChange(int index) {
    // if (index >= 0 && index < _rawQuantityFocusNodes.length) {
    //   if (!_rawQuantityFocusNodes[index].hasFocus) {
    //     _validateRawQuantityAgainstInventory(index);
    //   }
    // }
  }

  void _onFinishedQuantityFocusChange(int index) {
    // You might want to add validation for finished products too
  }

  // void _validateRawQuantityAgainstInventory(int index) async {
  //   if (_selectedFromWarehouseId == null ||
  //       _rawSelectedItemData[index] == null) {
  //     return;
  //   }

  //   final quantityText =
  //       _rawQuantityControllers[index].text.replaceAll(',', '');
  //   final enteredQuantity = double.tryParse(quantityText) ?? 0;

  //   if (enteredQuantity <= 0) {
  //     return;
  //   }

  //   final item = _rawSelectedItemData[index]!;
  //   final balance = item.balances?.firstWhere(
  //     (b) => b['warehouse_id'] == _selectedFromWarehouseId,
  //     orElse: () => {'quantity': 0},
  //   );

  //   final availableQuantity = balance != null
  //       ? (balance['quantity'] is String
  //           ? double.tryParse(balance['quantity']) ?? 0
  //           : (balance['quantity'] as num?)?.toDouble() ?? 0)
  //       : 0;

  //   if (enteredQuantity > availableQuantity) {
  //     showSnackBar(
  //       context: context,
  //       content:
  //           'الكمية المدخلة (${_rawQuantityControllers[index].text}) تتجاوز الكمية المتاحة ($availableQuantity) في المستودع المصدر',
  //       failure: true,
  //     );

  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _rawQuantityControllers[index].clear();
  //       _rawQuantityFocusNodes[index].requestFocus();
  //     });
  //   }
  // }

  void _searchForRawItem(int index) {
    if (_rawItemNameControllers[index].text.isEmpty) {
      setState(() {
        _rawItems[index]['item'] = null;
        _rawItemUnitControllers[index].clear();
        _rawQuantityControllers[index].clear();
        _rawItemNoteControllers[index].clear();
        _rawSelectedItemData[index] = null;
      });
      return;
    }

    setState(() {
      _isSearchingItem = true;
      _currentItemSearchIndex = index;
      _isRawItem = true;
      _itemsList.clear();
      currentItemSearchPage = 1;
      isLoadingMore = false;
    });

    context.read<InventoryBloc>().add(
          SearchItems(search: _rawItemNameControllers[index].text, page: 1),
        );
  }

  void _searchForFinishedItem(int index) {
    if (_finishedItemNameControllers[index].text.isEmpty) {
      setState(() {
        _finishedItems[index]['item'] = null;
        _finishedItemUnitControllers[index].clear();
        _finishedQuantityControllers[index].clear();
        _finishedItemNoteControllers[index].clear();
        _finishedSelectedItemData[index] = null;
      });
      return;
    }

    setState(() {
      _isSearchingItem = true;
      _currentItemSearchIndex = index;
      _isRawItem = false;
      _itemsList.clear();
      currentItemSearchPage = 1;
      isLoadingMore = false;
    });

    context.read<InventoryBloc>().add(
          SearchItems(
              search: _finishedItemNameControllers[index].text, page: 1),
        );
  }

  Future<void> _showItemSearchDialog(int index) async {
    _scrollController.addListener(_onScroll);

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

    _scrollController.removeListener(_onScroll);
    setState(() {
      _isSearchingItem = false;
      _currentItemSearchIndex = null;

      if (selectedItem != null) {
        if (_isRawItem) {
          _rawItems[index]['item'] = selectedItem.id;
          _rawItemNameControllers[index].text =
              '${selectedItem.code ?? ''}-${selectedItem.name ?? ''}';
          _rawItemUnitControllers[index].text = selectedItem.unit ?? '';
          _rawSelectedItemData[index] = selectedItem;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _focusToRawQuantity(index));
        } else {
          _finishedItems[index]['item'] = selectedItem.id;
          _finishedItemNameControllers[index].text =
              '${selectedItem.code ?? ''}-${selectedItem.name ?? ''}';
          _finishedItemUnitControllers[index].text = selectedItem.unit ?? '';
          _finishedSelectedItemData[index] = selectedItem;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _focusToFinishedQuantity(index));
        }
      } else {
        if (_isRawItem) {
          if (_rawItemNameControllers[index].text.isNotEmpty) {
            _rawItemNameControllers[index].clear();
            _rawItems[index]['item'] = null;
            _rawItemUnitControllers[index].clear();
            _rawQuantityControllers[index].clear();
            _rawItemNoteControllers[index].clear();
            _rawSelectedItemData[index] = null;
          }
        } else {
          if (_finishedItemNameControllers[index].text.isNotEmpty) {
            _finishedItemNameControllers[index].clear();
            _finishedItems[index]['item'] = null;
            _finishedItemUnitControllers[index].clear();
            _finishedQuantityControllers[index].clear();
            _finishedItemNoteControllers[index].clear();
            _finishedSelectedItemData[index] = null;
          }
        }
      }
    });
  }

  void _onScroll() {
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
    _runBlocItemSearch();
  }

  void _runBlocItemSearch() {
    if (_currentItemSearchIndex == null) return;

    if (_isRawItem) {
      context.read<InventoryBloc>().add(
            SearchItems(
              page: currentItemSearchPage,
              search: _rawItemNameControllers[_currentItemSearchIndex!].text,
            ),
          );
    } else {
      context.read<InventoryBloc>().add(
            SearchItems(
              page: currentItemSearchPage,
              search:
                  _finishedItemNameControllers[_currentItemSearchIndex!].text,
            ),
          );
    }
  }

  void _focusToRawQuantity(int index) {
    if (index >= 0 && index < _rawQuantityFocusNodes.length) {
      FocusScope.of(context).requestFocus(_rawQuantityFocusNodes[index]);
    }
  }

  void _focusToFinishedQuantity(int index) {
    if (index >= 0 && index < _finishedQuantityFocusNodes.length) {
      FocusScope.of(context).requestFocus(_finishedQuantityFocusNodes[index]);
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
            ),
          );
    } else if (!_toWarehouseFocusNode.hasFocus &&
        _toWarehouseController.text.isEmpty) {
      setState(() {
        _selectedToWarehouseId = null;
      });
    }
  }

  void _showItemDetailsDialog(ItemsModel? details) {
    if (details == null) return;

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: ui.TextDirection.rtl,
        child: AlertDialog(
          title: Text('${details.name}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('الرمز: ${details.code ?? 'غير محدد'}'),
                Text('المجموعة: ${details.group_code_name ?? 'غير محدد'}'),
                Text('الوحدة: ${details.unit ?? 'غير محدد'}'),
                Text('حد الأدنى: ${details.min_limit ?? 'غير محدد'}'),
                Text('حد الأقصى: ${details.max_limit ?? 'غير محدد'}'),
                const SizedBox(height: 10),
                const Text('الأسعار:'),
                if (details.default_price != null)
                  ...details.default_price!.map((price) => Text(
                        '${price['list_name']}: ${price['price']}',
                      )),
                if (details.default_price == null) const Text('لا توجد أسعار'),
                const SizedBox(height: 10),
                const Text('الرصيد:'),
                if (details.balances != null)
                  ...details.balances!.map((balance) {
                    // Parse the quantity to determine if it's positive
                    final quantity = double.tryParse(
                            balance['quantity']?.toString() ?? '0') ??
                        0;
                    return Text(
                      '${balance['warehouse_name']}: ${balance['quantity']}',
                      style: TextStyle(
                        color: quantity < 0 ? Colors.red : null,
                      ),
                    );
                  }),
                if (details.balances == null) const Text('لا توجد أرصدة'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      ),
    );
  }

  void _focusToWarehouse() {
    FocusScope.of(context).requestFocus(_toWarehouseFocusNode);
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
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusToWarehouse());
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
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusToWarehouse());
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
    } else {
      setState(() {
        _toWarehouseController.clear();
        _selectedToWarehouseId = null;
      });
    }

    _isSelectingToWarehouse = false;
  }

  Future<void> _showBatchCodeSearchDialog() async {
    final selectedProduction = await showDialog<BriefProductionModel>(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Directionality(
              textDirection: ui.TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('بحث عن طبخة إنتاج'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                body: BlocProvider(
                  create: (context) => ProductionBloc(
                    ProductionServices(
                      apiClient: getIt<ApiClient>(),
                      authInteractor: getIt<AuthInteractor>(),
                    ),
                  )..add(AllProduction(page: 1, search: '')),
                  child: const _ProductionSearchDialogContent(),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (selectedProduction != null) {
      setState(() {
        _selectedProduction = selectedProduction;
        widget.mainModel?.batch_number = selectedProduction.id;
        widget.mainModel?.batch_code = selectedProduction.batch_number;
      });
    }
  }

  void _onSerialFocusChange() {
    if (!_serialFocusNode.hasFocus && _serialController.text.isNotEmpty) {
      _fetchManufacturingBySerial();
    }
  }

  void _fetchManufacturingBySerial() async {
    if (_serialController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });
    final serialNumber = int.tryParse(_serialController.text);
    context.read<InventoryBloc>().add(
          GetOneManufacturingBySerial(
            serial: serialNumber!,
          ),
        );
  }

  void _populateFormWithManufacturingData(
      MainManufacturingModel manufacturing) {
    setState(() {
      // Clear existing data
      _disposeRawItemControllers();
      _disposeFinishedItemControllers();

      // Set basic info
      _currentId = manufacturing.id;
      _dateController.text = manufacturing.date ?? '';
      _noteController.text = manufacturing.note ?? '';
      _fromWarehouseController.text = manufacturing.raw_warehouse_name ?? '';
      _toWarehouseController.text = manufacturing.finished_warehouse_name ?? '';
      _selectedFromWarehouseId = manufacturing.raw_warehouse;
      _selectedToWarehouseId = manufacturing.finished_warehouse;
      _batchLevelController.text = manufacturing.batch_level?.toString() ?? '';
      if (manufacturing.batch_number != null) {
        _selectedProduction = BriefProductionModel(
          id: manufacturing.batch_number!,
          batch_number: manufacturing.batch_code ?? '',
        );
      } else {
        _selectedProduction = null;
      }
      // Set raw items
      if (manufacturing.rawManufacturingModel?.items != null) {
        for (var item in manufacturing.rawManufacturingModel!.items!) {
          _rawItems.add(Map<String, dynamic>.from(item.toMap()));

          _rawItemNameControllers.add(
              TextEditingController(text: item.item_name?.toString() ?? ''));
          _rawItemUnitControllers.add(
              TextEditingController(text: item.item_unit?.toString() ?? ''));
          _rawQuantityControllers.add(
              TextEditingController(text: item.quantity?.toString() ?? ''));
          _rawItemNoteControllers
              .add(TextEditingController(text: item.note?.toString() ?? ''));
          _rawWarehouseControllers.add(
            TextEditingController(
                text: item.from_warehouse_name?.toString() ??
                    manufacturing.raw_warehouse_name ??
                    ''),
          );

          final rawWarehouseFocusNode = FocusNode();
          rawWarehouseFocusNode.addListener(() => _onRawWarehouseFocusChange(
              _rawWarehouseFocusNodes.indexOf(rawWarehouseFocusNode)));
          _rawWarehouseFocusNodes.add(rawWarehouseFocusNode);
          _rawSelectedWarehouseIds.add(item.from_warehouse);
          _isSelectingRawWarehouse.add(false);

          final rawFocusNode = FocusNode();
          rawFocusNode.addListener(() => _onRawItemFocusNodeChange(
              _rawItemNameFocusNodes.indexOf(rawFocusNode)));
          _rawItemNameFocusNodes.add(rawFocusNode);

          final rawQuantityFocusNode = FocusNode();
          rawQuantityFocusNode.addListener(() => _onRawQuantityFocusChange(
              _rawQuantityFocusNodes.indexOf(rawQuantityFocusNode)));
          _rawQuantityFocusNodes.add(rawQuantityFocusNode);

          ItemsModel? selectedItem;
          if (item.item_details != null) {
            try {
              if (item.item_details is ItemsModel) {
                selectedItem = item.item_details as ItemsModel;
              } else {
                selectedItem = ItemsModel.fromMap(
                    Map<String, dynamic>.from(item.item_details as Map));
              }
            } catch (e) {
              debugPrint('Error parsing raw item_details: $e');
            }
          }
          _rawSelectedItemData.add(selectedItem);
        }
      }

      // Set finished items
      if (manufacturing.finishedItemsManufacturingModel?.items != null) {
        for (var item
            in manufacturing.finishedItemsManufacturingModel!.items!) {
          _finishedItems.add(Map<String, dynamic>.from(item.toMap()));

          _finishedItemNameControllers.add(
              TextEditingController(text: item.item_name?.toString() ?? ''));
          _finishedItemUnitControllers.add(
              TextEditingController(text: item.item_unit?.toString() ?? ''));
          _finishedQuantityControllers.add(
              TextEditingController(text: item.quantity?.toString() ?? ''));
          _finishedItemNoteControllers
              .add(TextEditingController(text: item.note?.toString() ?? ''));
          _finishedWarehouseControllers.add(
            TextEditingController(
                text: item.to_warehouse_name?.toString() ??
                    manufacturing.finished_warehouse_name ??
                    ''),
          );

          final finishedWarehouseFocusNode = FocusNode();
          finishedWarehouseFocusNode.addListener(() =>
              _onFinishedWarehouseFocusChange(_finishedWarehouseFocusNodes
                  .indexOf(finishedWarehouseFocusNode)));
          _finishedWarehouseFocusNodes.add(finishedWarehouseFocusNode);
          _finishedSelectedWarehouseIds.add(item.to_warehouse);
          _isSelectingFinishedWarehouse.add(false);

          final finishedFocusNode = FocusNode();
          finishedFocusNode.addListener(() => _onFinishedItemFocusNodeChange(
              _finishedItemNameFocusNodes.indexOf(finishedFocusNode)));
          _finishedItemNameFocusNodes.add(finishedFocusNode);

          final finishedQuantityFocusNode = FocusNode();
          finishedQuantityFocusNode.addListener(() =>
              _onFinishedQuantityFocusChange(_finishedQuantityFocusNodes
                  .indexOf(finishedQuantityFocusNode)));
          _finishedQuantityFocusNodes.add(finishedQuantityFocusNode);

          ItemsModel? selectedItem;
          if (item.item_details != null) {
            try {
              if (item.item_details is ItemsModel) {
                selectedItem = item.item_details as ItemsModel;
              } else {
                selectedItem = ItemsModel.fromMap(
                    Map<String, dynamic>.from(item.item_details as Map));
              }
            } catch (e) {
              debugPrint('Error parsing finished item_details: $e');
            }
          }
          _finishedSelectedItemData.add(selectedItem);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.mainModel == null
                ? 'إضافة عملية تصنيع'
                : 'تعديل عملية تصنيع',
          ),
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess<MainManufacturingModel>) {
              if (state.result.serial.toString() == _serialController.text) {
                // Populate the form with the fetched data
                _populateFormWithManufacturingData(state.result);
                setState(() {
                  _isLoading = false;
                });
              }
            } else if (state is InventorySuccessAddManufacturing) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.mainModel == null ? 'إضافة' : 'تعديل'} عملية التصنيع',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ManufacturingListPage();
                  },
                ),
              );
            } else if (state is InventorySuccessUpdateManufacturing) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.mainModel == null ? 'إضافة' : 'تعديل'} عملية التصنيع',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ManufacturingListPage();
                  },
                ),
              );
            } else if (state is InventoryError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
            } else if (state is InventorySuccess<List<WarehousesModel>>) {
              // Correctly placed
              // Check if this is for a raw item warehouse
              for (int i = 0; i < _isSelectingRawWarehouse.length; i++) {
                if (_isSelectingRawWarehouse[i]) {
                  if (state.result.length == 1) {
                    final selectedWarehouse = state.result.first;
                    setState(() {
                      _rawWarehouseControllers[i].text =
                          '${selectedWarehouse.code ?? ''}-${selectedWarehouse.name ?? ''}';
                      _rawSelectedWarehouseIds[i] = selectedWarehouse.id;
                      _rawItems[i]['warehouse'] = selectedWarehouse.id;
                      _rawItems[i]['warehouse_name'] = selectedWarehouse.name;
                      _isSelectingRawWarehouse[i] = false;
                    });
                  } else if (state.result.length > 1) {
                    _showRawWarehouseSelectionDialog(i, state.result);
                  } else {
                    setState(() {
                      _rawWarehouseControllers[i].clear();
                      _rawSelectedWarehouseIds[i] = null;
                      _rawItems[i]['warehouse'] = null;
                      _rawItems[i]['warehouse_name'] = '';
                      _isSelectingRawWarehouse[i] = false;
                    });
                    showSnackBar(
                      context: context,
                      content: 'لم يتم العثور على مستودعات مطابقة.',
                      failure: true,
                    );
                  }
                  return;
                }
              }

              // Check if this is for a finished item warehouse
              for (int i = 0; i < _isSelectingFinishedWarehouse.length; i++) {
                if (_isSelectingFinishedWarehouse[i]) {
                  if (state.result.length == 1) {
                    final selectedWarehouse = state.result.first;
                    setState(() {
                      _finishedWarehouseControllers[i].text =
                          '${selectedWarehouse.code ?? ''}-${selectedWarehouse.name ?? ''}';
                      _finishedSelectedWarehouseIds[i] = selectedWarehouse.id;
                      _finishedItems[i]['warehouse'] = selectedWarehouse.id;
                      _finishedItems[i]['warehouse_name'] =
                          selectedWarehouse.name;
                      _isSelectingFinishedWarehouse[i] = false;
                    });
                  } else if (state.result.length > 1) {
                    _showFinishedWarehouseSelectionDialog(i, state.result);
                  } else {
                    setState(() {
                      _finishedWarehouseControllers[i].clear();
                      _finishedSelectedWarehouseIds[i] = null;
                      _finishedItems[i]['warehouse'] = null;
                      _finishedItems[i]['warehouse_name'] = '';
                      _isSelectingFinishedWarehouse[i] = false;
                    });
                    showSnackBar(
                      context: context,
                      content: 'لم يتم العثور على مستودعات مطابقة.',
                      failure: true,
                    );
                  }
                  return;
                }
              }

              // Handle main from/to warehouse search if needed
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
            } else if (state is InventorySuccess<List<ItemsModel>>) {
              // Correctly placed
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
                    if (_isRawItem) {
                      _rawItemNameControllers[_currentItemSearchIndex!].clear();
                      _rawItems[_currentItemSearchIndex!]['item'] = null;
                      _rawItemUnitControllers[_currentItemSearchIndex!].clear();
                      _rawQuantityControllers[_currentItemSearchIndex!].clear();
                      _rawItemNoteControllers[_currentItemSearchIndex!].clear();
                      _rawSelectedItemData[_currentItemSearchIndex!] = null;
                    } else {
                      _finishedItemNameControllers[_currentItemSearchIndex!]
                          .clear();
                      _finishedItems[_currentItemSearchIndex!]['item'] = null;
                      _finishedItemUnitControllers[_currentItemSearchIndex!]
                          .clear();
                      _finishedQuantityControllers[_currentItemSearchIndex!]
                          .clear();
                      _finishedItemNoteControllers[_currentItemSearchIndex!]
                          .clear();
                      _finishedSelectedItemData[_currentItemSearchIndex!] =
                          null;
                    }
                  } else if (_itemsList.length == 1 &&
                      currentItemSearchPage == 1) {
                    final item = _itemsList.first;
                    if (_isRawItem) {
                      _rawItems[_currentItemSearchIndex!]['item'] = item.id;
                      _rawItemNameControllers[_currentItemSearchIndex!].text =
                          '${item.code ?? ''}-${item.name ?? ''}';
                      _rawItemUnitControllers[_currentItemSearchIndex!].text =
                          item.unit ?? '';
                      _rawSelectedItemData[_currentItemSearchIndex!] = item;
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _focusToRawQuantity(_currentItemSearchIndex!));
                    } else {
                      _finishedItems[_currentItemSearchIndex!]['item'] =
                          item.id;
                      _finishedItemNameControllers[_currentItemSearchIndex!]
                          .text = '${item.code ?? ''}-${item.name ?? ''}';
                      _finishedItemUnitControllers[_currentItemSearchIndex!]
                          .text = item.unit ?? '';
                      _finishedSelectedItemData[_currentItemSearchIndex!] =
                          item;
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          _focusToFinishedQuantity(_currentItemSearchIndex!));
                    }
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
            }
          },
          builder: (context, state) {
            return BlocListener<ProductionBloc, ProductionState>(
              listener: (context, state) {
                if (state is ProductionError) {
                  showSnackBar(
                    context: context,
                    content: state.errorMessage,
                    failure: true,
                  );
                } else if (state is ProductionSuccess<FullProductionModel>) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductionFullDataPage(
                          fullProductionModel: state.result,
                          type: 'Production',
                        );
                      },
                    ),
                  );
                }
              },
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
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
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'الرجاء تحديد تاريخ';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          flex: 3,
                                          child: MyTextField(
                                            controller: _serialController,
                                            focusNode: _serialFocusNode,
                                            labelText: 'الرقم',
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d*$')),
                                            ],
                                            suffixIcon: state
                                                        is InventoryLoading &&
                                                    _isLoading
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
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 7),
                                    MyTextField(
                                      controller: _fromWarehouseController,
                                      labelText: 'من المستودع',
                                      focusNode: _fromWarehouseFocusNode,
                                      suffixIcon: (_fromWarehouseController
                                              .text.isNotEmpty
                                          ? (state is InventoryLoading &&
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
                                      suffixIcon: (_toWarehouseController
                                              .text.isNotEmpty
                                          ? (state is InventoryLoading &&
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
                                      maxLines: 3,
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      spacing: 10,
                                      children: [
                                        Expanded(
                                          child: MyTextField(
                                            controller: _batchLevelController,
                                            labelText: 'رقم المرحلة',
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'^\d*\.?\d*$')),
                                            ],
                                          ),
                                        ),
                                        // Always show search button
                                        Expanded(
                                          flex: 1,
                                          child: _selectedProduction == null
                                              ? IconButton(
                                                  icon:
                                                      const Icon(Icons.search),
                                                  onPressed:
                                                      _showBatchCodeSearchDialog,
                                                )
                                              : BlocBuilder<ProductionBloc,
                                                  ProductionState>(
                                                  builder: (context,
                                                      productionState) {
                                                    if (productionState
                                                        is ProductionLoading) {
                                                      return const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: Loader(),
                                                        ),
                                                      );
                                                    }
                                                    return Mybutton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                ProductionBloc>()
                                                            .add(
                                                              GetOneProductionByID(
                                                                id: _selectedProduction
                                                                        ?.id ??
                                                                    widget
                                                                        .mainModel!
                                                                        .batch_number!,
                                                              ),
                                                            );
                                                      },
                                                      text: _selectedProduction
                                                              ?.batch_number ??
                                                          widget.mainModel!
                                                              .batch_code!,
                                                    );
                                                  },
                                                ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Raw Materials Section
                      ExpansionTile(
                        title: const Text('مواد داخلة (مواد خام)'),
                        initiallyExpanded: true,
                        children: [
                          ..._rawItems.asMap().entries.map((entry) {
                            final index = entry.key;
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('${index + 1}'),
                                        ),
                                        Expanded(
                                          flex: 12,
                                          child: MyTextField(
                                            suffixIcon: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: _isSearchingItem &&
                                                      _currentItemSearchIndex ==
                                                          index &&
                                                      _isRawItem
                                                  ? const Center(
                                                      child: SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 1.5,
                                                        ),
                                                      ),
                                                    )
                                                  : IconButton(
                                                      icon: const Icon(
                                                          Icons.info_outline,
                                                          size: 18),
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      tooltip: 'عرض التفاصيل',
                                                      onPressed: () {
                                                        _showItemDetailsDialog(
                                                            _rawSelectedItemData[
                                                                index]);
                                                      },
                                                    ),
                                            ),
                                            controller:
                                                _rawItemNameControllers[index],
                                            labelText: 'المادة الخام',
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'الرجاء إدخال المادة';
                                              }
                                              return null;
                                            },
                                            focusNode:
                                                _rawItemNameFocusNodes[index],
                                            onSubmitted: (value) {
                                              _searchForRawItem(index);
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        if (_rawItems.length > 1)
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  _removeRawItem(index),
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
                                                _rawItemUnitControllers[index],
                                            labelText: 'الوحدة',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 1,
                                          child: MyTextField(
                                            controller:
                                                _rawQuantityControllers[index],
                                            focusNode:
                                                _rawQuantityFocusNodes[index],
                                            labelText: 'الكمية',
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'الرجاء إدخال الكمية';
                                              }
                                              if (double.tryParse(value
                                                      .replaceAll(',', '')) ==
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
                                    MyTextField(
                                      controller:
                                          _rawItemNoteControllers[index],
                                      labelText: 'البيان',
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 10),
                                    MyTextField(
                                      controller:
                                          _rawWarehouseControllers[index],
                                      labelText: 'المستودع',
                                      focusNode: _rawWarehouseFocusNodes[index],
                                      suffixIcon: (_rawWarehouseControllers[
                                                  index]
                                              .text
                                              .isNotEmpty
                                          ? (state is InventoryLoading &&
                                                  _isSelectingRawWarehouse[
                                                      index]
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
                                                      _rawWarehouseControllers[
                                                              index]
                                                          .clear();
                                                      _rawSelectedWarehouseIds[
                                                          index] = null;
                                                      _rawItems[index]
                                                          ['warehouse'] = null;
                                                      _rawItems[index][
                                                          'warehouse_name'] = '';
                                                    });
                                                  },
                                                ))
                                          : null),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: _addNewRawItem,
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('إضافة مادة خام جديدة'),
                            ),
                          ),
                        ],
                      ),

                      // Finished Products Section
                      ExpansionTile(
                        title: const Text('مواد خارجة (منتجات نهائية)'),
                        initiallyExpanded: true,
                        children: [
                          ..._finishedItems.asMap().entries.map((entry) {
                            final index = entry.key;
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('${index + 1}'),
                                        ),
                                        Expanded(
                                          flex: 12,
                                          child: MyTextField(
                                            suffixIcon: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: _isSearchingItem &&
                                                      _currentItemSearchIndex ==
                                                          index &&
                                                      !_isRawItem
                                                  ? const Center(
                                                      child: SizedBox(
                                                        width: 16,
                                                        height: 16,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 1.5,
                                                        ),
                                                      ),
                                                    )
                                                  : IconButton(
                                                      icon: const Icon(
                                                          Icons.info_outline,
                                                          size: 18),
                                                      padding: EdgeInsets.zero,
                                                      constraints:
                                                          const BoxConstraints(),
                                                      tooltip: 'عرض التفاصيل',
                                                      onPressed: () {
                                                        _showItemDetailsDialog(
                                                            _finishedSelectedItemData[
                                                                index]);
                                                      },
                                                    ),
                                            ),
                                            controller:
                                                _finishedItemNameControllers[
                                                    index],
                                            labelText: 'المنتج النهائي',
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'الرجاء إدخال المنتج';
                                              }
                                              return null;
                                            },
                                            focusNode:
                                                _finishedItemNameFocusNodes[
                                                    index],
                                            onSubmitted: (value) {
                                              _searchForFinishedItem(index);
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        if (_finishedItems.length > 1)
                                          Expanded(
                                            flex: 1,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                              onPressed: () =>
                                                  _removeFinishedItem(index),
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
                                                _finishedItemUnitControllers[
                                                    index],
                                            labelText: 'الوحدة',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          flex: 1,
                                          child: MyTextField(
                                            controller:
                                                _finishedQuantityControllers[
                                                    index],
                                            focusNode:
                                                _finishedQuantityFocusNodes[
                                                    index],
                                            labelText: 'الكمية',
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'الرجاء إدخال الكمية';
                                              }
                                              if (double.tryParse(value
                                                      .replaceAll(',', '')) ==
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
                                    MyTextField(
                                      controller:
                                          _finishedItemNoteControllers[index],
                                      labelText: 'البيان',
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 10),
                                    MyTextField(
                                      controller:
                                          _finishedWarehouseControllers[index],
                                      labelText: 'المستودع',
                                      focusNode:
                                          _finishedWarehouseFocusNodes[index],
                                      suffixIcon: (_finishedWarehouseControllers[
                                                  index]
                                              .text
                                              .isNotEmpty
                                          ? (state is InventoryLoading &&
                                                  _isSelectingFinishedWarehouse[
                                                      index]
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
                                                      _finishedWarehouseControllers[
                                                              index]
                                                          .clear();
                                                      _finishedSelectedWarehouseIds[
                                                          index] = null;
                                                      _finishedItems[index]
                                                          ['warehouse'] = null;
                                                      _finishedItems[index][
                                                          'warehouse_name'] = '';
                                                    });
                                                  },
                                                ))
                                          : null),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: _addNewFinishedItem,
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('إضافة منتج نهائي جديد'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      state is InventoryLoading
                          ? const Loader()
                          : Mybutton(
                              text:
                                  widget.mainModel == null ? 'إضافة' : 'تعديل',
                              onPressed: _submitForm,
                            ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm() {
    print('1 - Starting form submission');

    // First validate the form
    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(
          context: context,
          content: 'الرجاء تصحيح الأخطاء في النموذج',
          failure: true,
        );
      });
      return;
    }
    print('2 - Form validation passed');

    // Then check other validations
    if (_selectedFromWarehouseId == null) {
      print('3 - Missing source warehouse');
      showSnackBar(
        context: context,
        content: 'الرجاء تحديد المستودع المصدر',
        failure: true,
      );
      return;
    }

    if (_selectedToWarehouseId == null) {
      print('4 - Missing destination warehouse');
      showSnackBar(
        context: context,
        content: 'الرجاء تحديد المستودع المستلم',
        failure: true,
      );
      return;
    }

    if (_rawItems.isEmpty) {
      print('5 - No raw materials added');
      showSnackBar(
        context: context,
        content: 'الرجاء إضافة مواد خام على الأقل',
        failure: true,
      );
      return;
    }

    if (_finishedItems.isEmpty) {
      print('6 - No finished products added');
      showSnackBar(
        context: context,
        content: 'الرجاء إضافة منتجات نهائية على الأقل',
        failure: true,
      );
      return;
    }

    print('7 - All validations passed, preparing data');

    // Prepare raw items data
    final rawItems = _rawItems.map((item) {
      final index = _rawItems.indexOf(item);
      return {
        'item': item['item'],
        'quantity': double.parse(
            _rawQuantityControllers[index].text.replaceAll(',', '')),
        'from_warehouse':
            _rawSelectedWarehouseIds[index] ?? _selectedFromWarehouseId,
        if (_rawItemNoteControllers[index].text.isNotEmpty)
          'note': _rawItemNoteControllers[index].text,
      };
    }).toList();

    // Prepare finished items data
    final finishedItems = _finishedItems.map((item) {
      final index = _finishedItems.indexOf(item);
      return {
        'item': item['item'],
        'quantity': double.parse(
            _finishedQuantityControllers[index].text.replaceAll(',', '')),
        'to_warehouse':
            _finishedSelectedWarehouseIds[index] ?? _selectedToWarehouseId,
        if (_finishedItemNoteControllers[index].text.isNotEmpty)
          'note': _finishedItemNoteControllers[index].text,
      };
    }).toList();

    // Create the final payload with the exact structure the API expects
    final manufacturingData = {
      if (_currentId != null) 'id': _currentId,
      'date': _dateController.text,
      'note': _noteController.text,
      if (_batchLevelController.text.isNotEmpty)
        'batch_level': int.tryParse(_batchLevelController.text),
      'raw_warehouse': _selectedFromWarehouseId,
      'finished_warehouse': _selectedToWarehouseId,
      if (_selectedProduction?.id != null ||
          widget.mainModel?.batch_number != null)
        'batch_number':
            _selectedProduction?.id ?? widget.mainModel?.batch_number,
      'raw_items': rawItems,
      'fg_items': finishedItems,
    };

    print('8 - Submitting data: ${manufacturingData}');

    if (widget.mainModel == null) {
      print('9 - Adding new manufacturing');
      context.read<InventoryBloc>().add(
            AddManufacturing(
              manufacturingData: manufacturingData,
            ),
          );
    } else {
      print('9 - Updating existing manufacturing');
      context.read<InventoryBloc>().add(
            UpdateManufacturing(
              manufacturingData: manufacturingData,
              id: _currentId!,
            ),
          );
    }
  }
}

class _ProductionSearchDialogContent extends StatefulWidget {
  const _ProductionSearchDialogContent();

  @override
  State<_ProductionSearchDialogContent> createState() =>
      _ProductionSearchDialogContentState();
}

class _ProductionSearchDialogContentState
    extends State<_ProductionSearchDialogContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  bool isLoadingMore = false;
  List<BriefProductionModel> resultList = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _nextPage();
    }
  }

  void _nextPage() {
    setState(() {
      isLoadingMore = true;
    });
    currentPage++;
    context.read<ProductionBloc>().add(
          AllProduction(page: currentPage, search: _searchController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'بحث',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    resultList.clear();
                    currentPage = 1;
                  });
                  context.read<ProductionBloc>().add(
                        SearchProductionArchivePagainted(
                          page: 1,
                          search: _searchController.text,
                        ),
                      );
                },
              ),
            ),
            onSubmitted: (value) {
              setState(() {
                resultList.clear();
                currentPage = 1;
              });
              context.read<ProductionBloc>().add(
                    SearchProductionArchivePagainted(
                      page: 1,
                      search: value,
                    ),
                  );
            },
          ),
        ),
        Expanded(
          child: BlocConsumer<ProductionBloc, ProductionState>(
            listener: (context, state) {
              if (state is ProductionSuccess<List<BriefProductionModel>>) {
                if (currentPage == 1) {
                  resultList = state.result;
                } else {
                  resultList.addAll(state.result);
                }
                isLoadingMore = false;
              }
            },
            builder: (context, state) {
              if (state is ProductionLoading && currentPage == 1) {
                return const Center(child: Loader());
              }

              if (resultList.isEmpty && state is! ProductionLoading) {
                return const Center(
                  child: Text('لا يوجد نتائج'),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: resultList.length + (isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == resultList.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: Loader()),
                    );
                  }

                  final item = resultList[index];
                  return ListTile(
                    title: Text(item.batch_number ?? ''),
                    subtitle: Text('${item.type} - ${item.tier}'),
                    trailing: Text('${item.total_weight} KG'),
                    onTap: () {
                      Navigator.pop(context, item);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
