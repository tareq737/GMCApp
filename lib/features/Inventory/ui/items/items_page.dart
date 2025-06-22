// ignore_for_file: public_member_api_docs, sort_constructors_first
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
import 'package:gmcappclean/features/Inventory/models/groups_model.dart';
import 'package:gmcappclean/features/Inventory/models/items_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/items/items_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

// Helper class to manage controllers for each price entry
class PriceEntry {
  final UniqueKey key; // Unique key for widget rebuilding and identification
  final TextEditingController listNameController;
  final TextEditingController priceController;

  PriceEntry({
    String? listName,
    String? price,
  })  : key = UniqueKey(),
        listNameController = TextEditingController(text: listName),
        priceController = TextEditingController(text: price);

  // Method to convert the current state of controllers to a Map
  Map<String, dynamic> toMap() {
    return {
      'list_name': listNameController.text,
      'price': priceController.text,
    };
  }

  // Dispose controllers to prevent memory leaks
  void dispose() {
    listNameController.dispose();
    priceController.dispose();
  }
}

class ItemsPage extends StatelessWidget {
  final ItemsModel? itemsModel;
  const ItemsPage({
    super.key,
    this.itemsModel,
  });
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(
        builder: (context) {
          return ItemsPageChild(itemsModel: itemsModel);
        },
      ),
    );
  }
}

class ItemsPageChild extends StatefulWidget {
  final ItemsModel? itemsModel;
  const ItemsPageChild({super.key, this.itemsModel});

  @override
  State<ItemsPageChild> createState() => _ItemsPageChildState();
}

class _ItemsPageChildState extends State<ItemsPageChild> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  final _minLimitController = TextEditingController();
  final _maxLimitController = TextEditingController();
  final _parentGroupController = TextEditingController();
  final _parentGroupFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isSelectingParentGroup = false;
  bool _isFormSubmitting = false;
  int? _selectedParentGroupId;

  // List to hold PriceEntry objects, each containing its own controllers
  List<PriceEntry> _priceEntries = [];

  @override
  void initState() {
    super.initState();
    if (widget.itemsModel != null) {
      _codeController.text = widget.itemsModel!.code ?? '';
      _nameController.text = widget.itemsModel!.name ?? '';
      _unitController.text = widget.itemsModel!.unit ?? '';
      _minLimitController.text = widget.itemsModel!.min_limit ?? '';
      _maxLimitController.text = widget.itemsModel!.max_limit ?? '';
      _parentGroupController.text = widget.itemsModel!.group_code_name ?? '';
      _selectedParentGroupId = widget.itemsModel!.group;

      // Initialize _priceEntries from the default_price data
      if (widget.itemsModel!.default_price != null) {
        for (var priceMap in widget.itemsModel!.default_price!) {
          _priceEntries.add(PriceEntry(
            listName: priceMap['list_name'] as String?,
            price: priceMap['price'] as String?,
          ));
        }
      }
    }
    _parentGroupFocusNode.addListener(_onParentGroupFocusChange);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _parentGroupController.dispose();
    _parentGroupFocusNode.removeListener(_onParentGroupFocusChange);
    _parentGroupFocusNode.dispose();
    _unitController.dispose();
    _minLimitController.dispose();
    _maxLimitController.dispose();
    // Dispose all controllers in _priceEntries
    for (var entry in _priceEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  void _onParentGroupFocusChange() {
    if (_isFormSubmitting) return;

    if (!_parentGroupFocusNode.hasFocus &&
        _parentGroupController.text.isNotEmpty &&
        !_isSelectingParentGroup) {
      context.read<InventoryBloc>().add(
            SearchGroups(
              search: _parentGroupController.text,
              page: 1,
            ),
          );
    } else if (!_parentGroupFocusNode.hasFocus &&
        _parentGroupController.text.isEmpty) {
      setState(() {
        _selectedParentGroupId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.itemsModel == null ? 'إضافة المادة' : 'تعديل المادة'),
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess<ItemsModel>) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.itemsModel == null ? 'إضافة' : 'تعديل'} المادة: ${_nameController.text}',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const ItemsListPage();
                  },
                ),
              );
            } else if (state is InventorySuccess<List<GroupsModel>>) {
              if (state.result.length == 1) {
                _isSelectingParentGroup = true;
                final selectedGroup = state.result.first;
                setState(() {
                  _parentGroupController.text =
                      '${selectedGroup.code ?? ''}-${selectedGroup.name ?? ''}';
                  _selectedParentGroupId = selectedGroup.id;
                });
                FocusScope.of(context).unfocus();
                _isSelectingParentGroup = false;
              } else if (state.result.length > 1) {
                _showGroupSelectionDialog(context, state.result);
              } else {
                _parentGroupController.clear();
                setState(() {
                  _selectedParentGroupId = null;
                });
                showSnackBar(
                  context: context,
                  content: 'لم يتم العثور على مجموعات مطابقة.',
                  failure: true,
                );
              }
            } else if (state is InventoryError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
              if (_parentGroupController.text.isEmpty) {
                setState(() {
                  _selectedParentGroupId = null;
                });
              }
            }
          },
          builder: (context, state) {
            bool isLoadingSearch = state is InventoryLoading &&
                _parentGroupFocusNode.hasFocus &&
                state is! InventorySuccess<ItemsModel> &&
                state is! InventoryError;

            bool isLoadingFormSubmission = state is InventoryLoading &&
                (context.read<InventoryBloc>().state is InventoryLoading &&
                    context.read<InventoryBloc>().state
                        is! InventorySuccess<List<GroupsModel>>);

            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      MyTextField(
                        controller: _codeController,
                        labelText: 'رمز المادة',
                        validator: (value) =>
                            value!.isEmpty ? 'يجب إدخال رمز المادة' : null,
                      ),
                      const SizedBox(height: 20), // Spacing
                      MyTextField(
                        controller: _nameController,
                        labelText: 'اسم المادة',
                        validator: (value) =>
                            value!.isEmpty ? 'يجب إدخال اسم المادة' : null,
                      ),
                      const SizedBox(height: 20), // Spacing
                      MyTextField(
                        controller: _parentGroupController,
                        labelText: 'المجموعة الأب',
                        focusNode: _parentGroupFocusNode,
                        suffixIcon: isLoadingSearch
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              )
                            : (_parentGroupController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _parentGroupController.clear();
                                        _selectedParentGroupId = null;
                                      });
                                    },
                                  )
                                : null),
                      ),
                      const SizedBox(height: 20), // Spacing
                      MyTextField(
                        controller: _unitController,
                        labelText: 'وحدة المادة',
                      ),
                      const SizedBox(height: 20), // Spacing
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              controller: _minLimitController,
                              labelText: 'الحد الأدنى',
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$')),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                            ),
                          ),
                          const SizedBox(
                              width: 10), // Spacing between text fields
                          Expanded(
                            child: MyTextField(
                              controller: _maxLimitController,
                              labelText: 'الحد الأقصى',
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$')),
                              ],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30), // Spacing
                      const Text(
                        'قائمة الأسعار:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8), // Spacing

                      // Dynamic list of price entry fields
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _priceEntries.length,
                        itemBuilder: (context, index) {
                          final priceEntry = _priceEntries[index];
                          return Padding(
                            key: priceEntry.key, // Use unique key for list item
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: MyTextField(
                                    controller: priceEntry.listNameController,
                                    labelText: 'اسم القائمة',
                                    readOnly: true,
                                  ),
                                ),
                                const SizedBox(width: 10), // Spacing
                                Expanded(
                                  flex: 2,
                                  child: MyTextField(
                                    controller: priceEntry.priceController,
                                    labelText: 'السعر',
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*$')),
                                    ],
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    validator: (value) =>
                                        value!.isEmpty ? 'السعر مطلوب' : null,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 30), // Spacing
                      isLoadingFormSubmission
                          ? const Center(child: Loader())
                          : Center(
                              child: Mybutton(
                                text: widget.itemsModel == null
                                    ? 'إضافة'
                                    : 'تعديل',
                                onPressed: () {
                                  if (!_isFormSubmitting) {
                                    _submitForm();
                                  }
                                },
                              ),
                            ),
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
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      setState(() {
        _isFormSubmitting = true;
      });

      final model = _fillModelFromForm();
      if (widget.itemsModel == null) {
        context.read<InventoryBloc>().add(AddItem(itemsModel: model));
      } else {
        context.read<InventoryBloc>().add(
              UpdateItem(itemsModel: model, id: widget.itemsModel!.id),
            );
      }

      // It's generally not recommended to use Future.delayed like this
      // for managing loading states, as it can lead to UI inconsistencies
      // if the actual API call takes longer or shorter.
      // Better to manage _isFormSubmitting directly in BlocListener
      // based on InventoryLoading and InventorySuccess/Error states.
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          // Check if the widget is still mounted before calling setState
          setState(() {
            _isFormSubmitting = false;
          });
        }
      });
    }
  }

  ItemsModel _fillModelFromForm() {
    // When submitting, extract data from controllers in _priceEntries
    final List<Map<String, dynamic>> pricesToSubmit =
        _priceEntries.map((entry) => entry.toMap()).toList();

    return ItemsModel(
      id: widget.itemsModel?.id ?? 0,
      code: _codeController.text,
      name: _nameController.text,
      group: _selectedParentGroupId,
      unit: _unitController.text,
      min_limit: _minLimitController.text,
      max_limit: _maxLimitController.text,
      default_price: pricesToSubmit,
    );
  }

  void _showGroupSelectionDialog(
      BuildContext context, List<GroupsModel> groups) async {
    _isSelectingParentGroup = true;

    final selectedGroup = await showDialog<GroupsModel>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر مجموعة الأب'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: groups.length,
              itemBuilder: (BuildContext context, int index) {
                final group = groups[index];
                return ListTile(
                  title: Text('${group.code}-${group.name}'),
                  onTap: () {
                    Navigator.pop(context, group);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedGroup != null) {
      setState(() {
        _parentGroupController.text =
            '${selectedGroup.code ?? ''}-${selectedGroup.name ?? ''}';
        _selectedParentGroupId = selectedGroup.id;
      });
      FocusScope.of(context).unfocus();
    } else {
      setState(() {
        _parentGroupController.clear();
        _selectedParentGroupId = null;
      });
    }

    _isSelectingParentGroup = false;
  }
}
