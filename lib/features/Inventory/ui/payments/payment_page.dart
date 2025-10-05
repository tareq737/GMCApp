import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:gmcappclean/features/Inventory/models/payment_model.dart';
import 'package:gmcappclean/features/Inventory/services/inventory_services.dart';
import 'package:gmcappclean/features/Inventory/ui/payments/payments_list_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:intl/intl.dart';

// Assuming PaymentPage and other imports/dependencies remain the same

class PaymentPage extends StatelessWidget {
  final PaymentModel? paymentModel;
  const PaymentPage({super.key, this.paymentModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InventoryBloc(InventoryServices(
        apiClient: getIt<ApiClient>(),
        authInteractor: getIt<AuthInteractor>(),
      )),
      child: Builder(
        builder: (context) {
          return PaymentPageChild(paymentModel: paymentModel);
        },
      ),
    );
  }
}

class PaymentPageChild extends StatefulWidget {
  final PaymentModel? paymentModel;
  const PaymentPageChild({super.key, this.paymentModel});

  @override
  State<PaymentPageChild> createState() => _PaymentPageChildState();
}

class _PaymentPageChildState extends State<PaymentPageChild> {
  final _dateController = TextEditingController();
  final _ammountController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _accountPaidIntoNameController = TextEditingController();
  final _noteController = TextEditingController();
  int? _selectedCustomerId;
  int? _selectedAccountPaidIntoNameId;

  // Flags to prevent re-searching immediately after selection
  bool _isSelectingCustomer = false;
  bool _isSelectingAccountPaidInto = false;

  final _customerFocusNode = FocusNode();
  final _accountPaidIntoFocusNode = FocusNode();
  // NEW: FocusNode for the next field
  final _noteFocusNode = FocusNode();

  // Flags to track which search response to handle
  bool _searchingCustomer = false;
  bool _searchingAccountPaidInto = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.paymentModel != null) {
      _dateController.text = widget.paymentModel!.date ?? '';
      _ammountController.text = widget.paymentModel!.amount ?? '';
      _customerNameController.text = widget.paymentModel!.customer_name ?? '';
      _accountPaidIntoNameController.text =
          widget.paymentModel!.account_paid_into_name ?? '';
      _noteController.text = widget.paymentModel!.note ?? '';
      // Assuming you want to set the IDs for existing models
      _selectedCustomerId = widget.paymentModel!.customer;
      _selectedAccountPaidIntoNameId = widget.paymentModel!.account_paid_into;
    } else {
      // Set default date for new entry
      _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    _customerFocusNode.addListener(_onCustomerFocusChange);
    _accountPaidIntoFocusNode.addListener(_onAccountPaidIntoFocusChange);
  }

  void _onCustomerFocusChange() {
    // FIX 2: Reset selection flag when focus is gained (user is ready to edit/search again)
    if (_customerFocusNode.hasFocus) {
      _isSelectingCustomer = false;
    }

    if (!_customerFocusNode.hasFocus &&
        _customerNameController.text.isNotEmpty &&
        !_isSelectingCustomer) {
      _searchingCustomer = true;
      _searchingAccountPaidInto = false;
      context.read<InventoryBloc>().add(
            SearchAccounts(
              search: _customerNameController.text,
              page: 1,
            ),
          );
    } else if (!_customerFocusNode.hasFocus &&
        _customerNameController.text.isEmpty) {
      setState(() {
        _selectedCustomerId = null;
      });
    }
  }

  void _onAccountPaidIntoFocusChange() {
    // FIX 2: Reset selection flag when focus is gained (user is ready to edit/search again)
    if (_accountPaidIntoFocusNode.hasFocus) {
      _isSelectingAccountPaidInto = false;
    }

    if (!_accountPaidIntoFocusNode.hasFocus &&
        _accountPaidIntoNameController.text.isNotEmpty &&
        !_isSelectingAccountPaidInto) {
      _searchingAccountPaidInto = true;
      _searchingCustomer = false;
      context.read<InventoryBloc>().add(
            SearchAccounts(
              search: _accountPaidIntoNameController.text,
              page: 1,
            ),
          );
    } else if (!_accountPaidIntoFocusNode.hasFocus &&
        _accountPaidIntoNameController.text.isEmpty) {
      setState(() {
        _selectedAccountPaidIntoNameId = null;
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _ammountController.dispose();
    _customerNameController.dispose();
    _accountPaidIntoNameController.dispose();
    _noteController.dispose();
    _customerFocusNode.removeListener(_onCustomerFocusChange);
    _accountPaidIntoFocusNode.removeListener(_onAccountPaidIntoFocusChange);
    _customerFocusNode.dispose();
    _accountPaidIntoFocusNode.dispose();
    _noteFocusNode.dispose(); // Dispose the new focus node
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.paymentModel == null ? 'إضافة سند' : 'تعديل سند'),
        ),
        body: BlocConsumer<InventoryBloc, InventoryState>(
          listener: (context, state) {
            if (state is InventorySuccess<PaymentModel>) {
              showSnackBar(
                context: context,
                content:
                    'تم ${widget.paymentModel == null ? 'إضافة' : 'تعديل'} سند: ${_customerNameController.text}',
                failure: false,
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const PaymentsListPage();
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
                  builder: (context) => const PaymentsListPage(),
                ),
              );
            } else if (state is InventorySuccess<List<AccountsModel>>) {
              if (_searchingCustomer) {
                _handleCustomerSearchResults(context, state.result);
              } else if (_searchingAccountPaidInto) {
                _handleAccountPaidIntoSearchResults(context, state.result);
              }
            }
          },
          builder: (context, state) {
            // Determine if the *main* form submission or deletion is loading
            final isSubmitting = state is InventoryLoading &&
                !_searchingCustomer &&
                !_searchingAccountPaidInto;

            // Determine if the search field is actively loading
            final isSearchLoading = state is InventoryLoading &&
                (_searchingCustomer || _searchingAccountPaidInto);

            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MyTextField(
                        readOnly: true,
                        controller: _dateController,
                        labelText: 'التاريخ ',
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
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
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: _ammountController,
                        labelText: 'المبلغ',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(
                                r'^\d*\.?\d{0,2}'), // allows float with up to 2 decimals
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يجب إدخال المبلغ';
                          }
                          final num? number = num.tryParse(value);
                          if (number == null) {
                            return 'يجب إدخال رقم صالح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: _customerNameController,
                        labelText: 'اسم الحساب',
                        focusNode: _customerFocusNode,
                        suffixIcon: (_customerNameController.text.isNotEmpty
                            ? (isSearchLoading && _searchingCustomer
                                ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _customerNameController.clear();
                                        _selectedCustomerId = null;
                                        _isSelectingCustomer = false;
                                      });
                                    },
                                  ))
                            : null),
                        validator: (value) =>
                            value!.isEmpty ? 'يجب إدخال اسم الحساب' : null,
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: _accountPaidIntoNameController,
                        labelText: 'الحساب المدفوع فيه',
                        focusNode: _accountPaidIntoFocusNode,
                        suffixIcon: (_accountPaidIntoNameController
                                .text.isNotEmpty
                            ? (isSearchLoading && _searchingAccountPaidInto
                                ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _accountPaidIntoNameController.clear();
                                        _selectedAccountPaidIntoNameId = null;
                                        _isSelectingAccountPaidInto = false;
                                      });
                                    },
                                  ))
                            : null),
                        validator: (value) =>
                            value!.isEmpty ? 'يجب إدخال الحساب' : null,
                      ),
                      const SizedBox(height: 15),
                      MyTextField(
                        controller: _noteController,
                        labelText: 'ملاحظات',
                        focusNode: _noteFocusNode, // Assign the new focus node
                        validator: (value) => null,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 30),
                      // Conditional render for the submit button
                      isSubmitting
                          ? const Loader()
                          : Mybutton(
                              text: widget.paymentModel == null
                                  ? 'إضافة'
                                  : 'تعديل',
                              onPressed: _submitForm,
                            ),
                      const SizedBox(height: 40),
                      if (widget.paymentModel != null)
                        IconButton(
                          // Disable button if submitting/loading
                          onPressed: isSubmitting
                              ? null
                              : () {
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
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              subtitle: Text('هل انت متأكد؟'),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('إلغاء'),
                                                ),
                                                const SizedBox(width: 8),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      side: BorderSide(
                                                          color: Colors.red
                                                              .withOpacity(
                                                                  0.3)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    context
                                                        .read<InventoryBloc>()
                                                        .add(DeleteOnePayment(
                                                          id: widget
                                                              .paymentModel!
                                                              .id!,
                                                        ));
                                                  },
                                                  child: const Text('حذف',
                                                      style: TextStyle(
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
                        )
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
      final model = _fillModelFromForm();
      if (widget.paymentModel == null) {
        context.read<InventoryBloc>().add(
              AddPayment(paymentModel: model),
            );
      } else {
        context.read<InventoryBloc>().add(
              UpdatePayment(paymentModel: model, id: widget.paymentModel!.id!),
            );
      }
    }
  }

  PaymentModel _fillModelFromForm() {
    return PaymentModel(
      id: widget.paymentModel?.id ?? 0,
      date: _dateController.text,
      amount: _ammountController.text,
      customer: _selectedCustomerId,
      account_paid_into: _selectedAccountPaidIntoNameId,
      customer_name: _customerNameController.text,
      account_paid_into_name: _accountPaidIntoNameController.text,
      note: _noteController.text,
    );
  }

  // --- FOCUS HANDLING UPDATED HERE ---

  void _handleCustomerSearchResults(
      BuildContext context, List<AccountsModel> results) {
    _searchingCustomer = false;
    if (results.length == 1) {
      _isSelectingCustomer = true;
      final selected = results.first;
      setState(() {
        _customerNameController.text = selected.account_name ?? '';
        _selectedCustomerId = selected.id;
      });
      // NEW: Move focus from customer to 'الحساب المدفوع فيه'
      FocusScope.of(context).requestFocus(_accountPaidIntoFocusNode);
    } else if (results.length > 1) {
      _showAccountsSelectionDialog(context, results, isCustomer: true);
    } else {
      _customerNameController.clear();
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

  void _handleAccountPaidIntoSearchResults(
      BuildContext context, List<AccountsModel> results) {
    _searchingAccountPaidInto = false;
    if (results.length == 1) {
      _isSelectingAccountPaidInto = true;
      final selected = results.first;
      setState(() {
        _accountPaidIntoNameController.text = selected.account_name ?? '';
        _selectedAccountPaidIntoNameId = selected.id;
      });
      // NEW: Move focus from paid account to 'ملاحظات'
      FocusScope.of(context).requestFocus(_noteFocusNode);
    } else if (results.length > 1) {
      _showAccountsSelectionDialog(context, results, isCustomer: false);
    } else {
      _accountPaidIntoNameController.clear();
      setState(() {
        _selectedAccountPaidIntoNameId = null;
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
    List<AccountsModel> results, {
    required bool isCustomer,
  }) async {
    final selected = await showDialog<AccountsModel>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختر الحساب'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  final account = results[index];
                  return ListTile(
                    title: Text(account.account_name ?? account.name ?? ''),
                    onTap: () {
                      Navigator.pop(context, account);
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    if (selected != null) {
      if (isCustomer) {
        _isSelectingCustomer = true;
      } else {
        _isSelectingAccountPaidInto = true;
      }

      setState(() {
        if (isCustomer) {
          _customerNameController.text = selected.account_name ?? '';
          _selectedCustomerId = selected.id;
          // NEW: Move focus after selection from dialog
          FocusScope.of(context).requestFocus(_accountPaidIntoFocusNode);
        } else {
          _accountPaidIntoNameController.text = selected.account_name ?? '';
          _selectedAccountPaidIntoNameId = selected.id;
          // NEW: Move focus after selection from dialog
          FocusScope.of(context).requestFocus(_noteFocusNode);
        }
      });
    } else {
      // If dialog is dismissed, don't change focus or fields
      // Ensure the text field that lost focus regains it for re-entry if needed
    }
  }
}
