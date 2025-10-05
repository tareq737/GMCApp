import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Inventory/bloc/inventory_bloc.dart';
import 'package:gmcappclean/features/Inventory/models/accounts_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/Accounts/account_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class AccountPage extends StatelessWidget {
  final AccountsModel? accountsModel;
  const AccountPage({super.key, this.accountsModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(
        builder: (context) {
          return AccountPageChild(accountsModel: accountsModel);
        },
      ),
    );
  }
}

class AccountPageChild extends StatefulWidget {
  final AccountsModel? accountsModel;
  const AccountPageChild({super.key, this.accountsModel});

  @override
  State<AccountPageChild> createState() => _AccountPageChildState();
}

class _AccountPageChildState extends State<AccountPageChild> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.accountsModel != null) {
      _codeController.text = widget.accountsModel!.code ?? '';
      _nameController.text = widget.accountsModel!.name ?? '';
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
          title:
              Text(widget.accountsModel == null ? 'إضافة حساب' : 'تعديل حساب'),
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess<AccountsModel>) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.accountsModel == null ? 'إضافة' : 'تعديل'} حساب: ${_nameController.text}',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const AccountListPage();
                  },
                ),
              );
            } else if (state is InventoryError) {
              showSnackBar(
                context: context,
                content: state.errorMessage,
                failure: true,
              );
            } else if (state is InventorySuccessDeleted<bool>) {
              showSnackBar(
                context: context,
                content: 'تم الحذف بنجاح',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountListPage(),
                ),
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
                      labelText: 'رمز الحساب',
                      validator: (value) =>
                          value!.isEmpty ? 'يجب إدخال رمز الحساب' : null,
                    ),
                    const SizedBox(height: 20),
                    MyTextField(
                      controller: _nameController,
                      labelText: 'اسم الحساب',
                      validator: (value) =>
                          value!.isEmpty ? 'يجب إدخال اسم الحساب' : null,
                    ),
                    const SizedBox(height: 30),
                    Mybutton(
                      text: widget.accountsModel == null ? 'إضافة' : 'تعديل',
                      onPressed: _submitForm,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    if (widget.accountsModel != null)
                      IconButton(
                        icon: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.withOpacity(0.2),
                            border: Border.all(
                                color: Colors.red.withOpacity(0.5), width: 1),
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
                                      title: Text('تأكيد الحذف',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text('هل انت متأكد؟'),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('إلغاء'),
                                        ),
                                        const SizedBox(width: 8),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                Colors.red.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              side: BorderSide(
                                                  color: Colors.red
                                                      .withOpacity(0.3)),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            context.read<InventoryBloc>().add(
                                                  DeleteOneAccount(
                                                    id: widget
                                                        .accountsModel!.id!,
                                                  ),
                                                );
                                          },
                                          child: const Text('حذف',
                                              style:
                                                  TextStyle(color: Colors.red)),
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
      if (widget.accountsModel == null) {
        context.read<InventoryBloc>().add(
              AddAccount(accountsModel: model),
            );
      } else {
        context.read<InventoryBloc>().add(
              UpdateAccount(
                  accountsModel: model, id: widget.accountsModel!.id!),
            );
      }
    }
  }

  AccountsModel _fillModelFromForm() {
    return AccountsModel(
      id: widget.accountsModel?.id ?? 0,
      code: _codeController.text,
      name: _nameController.text,
    );
  }
}
