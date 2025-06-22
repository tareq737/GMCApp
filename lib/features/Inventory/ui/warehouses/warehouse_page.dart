import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/warehouses_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/warehouses/warehouse_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class WarehousePage extends StatelessWidget {
  final WarehousesModel? warehousesModel;

  const WarehousePage({super.key, this.warehousesModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(
        builder: (context) {
          return WarehousePageChild(warehousesModel: warehousesModel);
        },
      ),
    );
  }
}

class WarehousePageChild extends StatefulWidget {
  final WarehousesModel? warehousesModel;
  const WarehousePageChild({super.key, this.warehousesModel});

  @override
  State<WarehousePageChild> createState() => _WarehousePageChildState();
}

class _WarehousePageChildState extends State<WarehousePageChild> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.warehousesModel != null) {
      _codeController.text = widget.warehousesModel!.code ?? '';
      _nameController.text = widget.warehousesModel!.name ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.warehousesModel == null
              ? 'إضافة مستودع'
              : 'تعديل المستودع'),
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess<WarehousesModel>) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.warehousesModel == null ? 'إضافة' : 'تعديل'} المستودع: ${_nameController.text}',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const WarehouseListPage();
                  },
                ),
              );
            } else if (state is InventoryError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
            }
          },
          builder: (context, state) {
            if (state is InventoryLoading) {
              return const Center(child: Loader());
            }
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: _codeController,
                      labelText: 'رمز المستودع',
                      validator: (value) =>
                          value!.isEmpty ? 'يجب إدخال رمز المستودع' : null,
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: _nameController,
                      labelText: 'اسم المستودع',
                      validator: (value) =>
                          value!.isEmpty ? 'يجب إدخال اسم المستودع' : null,
                    ),
                    const SizedBox(height: 30),
                    Mybutton(
                      text: widget.warehousesModel == null ? 'إضافة' : 'تعديل',
                      onPressed: _submitForm,
                    ),
                  ],
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
      final model = _fillModelFromForm();
      if (widget.warehousesModel == null) {
        context.read<InventoryBloc>().add(
              AddWarehouse(warehouseModel: model),
            );
      } else {
        context.read<InventoryBloc>().add(
              UpdateWarehouse(
                  warehousesModel: model, id: widget.warehousesModel!.id),
            );
      }
    }
  }

  WarehousesModel _fillModelFromForm() {
    return WarehousesModel(
      id: widget.warehousesModel?.id ?? 0,
      code: _codeController.text,
      name: _nameController.text,
    );
  }
}
