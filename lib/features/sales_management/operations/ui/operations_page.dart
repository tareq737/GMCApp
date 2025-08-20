import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/search_row.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';
import 'package:gmcappclean/features/sales_management/operations/bloc/operations_bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/models/operations_model.dart';
import 'package:gmcappclean/features/sales_management/operations/services/operations_services.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_call_page.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_visit_page.dart';
import 'dart:ui' as ui;
import 'package:gmcappclean/init_dependencies.dart';

class OperationsPage extends StatefulWidget {
  const OperationsPage({super.key});

  @override
  State<OperationsPage> createState() => _OperationsPageState();
}

class _OperationsPageState extends State<OperationsPage> {
  CustomerBriefViewModel? _selectedCustomer;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SalesBloc>(),
        ),
        BlocProvider(
          create: (context) => OperationsBloc(OperationsServices(
              apiClient: getIt<ApiClient>(),
              checkUserSessionStatus: getIt<CheckUserSessionStatus>())),
        ),
      ],
      child: Builder(builder: (context) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Row(
                children: [
                  Text('عمليات زبون'),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.info_outline),
                ],
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8),
              child: _selectedCustomer == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('يرجى اختيار زبون'),
                        SearchRow(
                          textEditingController: _searchController,
                          onSearch: () {
                            _searchCustomer(context);
                          },
                        ),
                        BlocConsumer<SalesBloc, SalesState>(
                          listener: (context, state) {
                            if (state is SalesOpFailure) {
                              showSnackBar(
                                context: context,
                                content: 'حدث خطأ ما',
                                failure: true,
                              );
                            } else if (state is SalesOpSuccess<
                                List<CustomerBriefViewModel>>) {
                              _showCustomerDialog(context, state.opResult);
                            }
                          },
                          builder: (context, state) {
                            if (state is SalesOpLoading) {
                              return const Loader();
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    )
                  : Column(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('اسم الزبون:'),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 10,
                                    child: Text(
                                      _selectedCustomer!.id.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 8),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      Text(
                                        _selectedCustomer?.customerName ?? '',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        _selectedCustomer?.shopName ?? '',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  IconButton(
                                    icon: const Icon(Icons.clear,
                                        color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _selectedCustomer = null;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<OperationsBloc, OperationsState>(
                          builder: (context, state) {
                            if (state is OperationsLoading) {
                              return const Loader();
                            } else if (state
                                is OperationsSuccess<List<OperationsModel>>) {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: state.result.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              state.result[index].type ==
                                                      'visit'
                                                  ? Icons.work_history_outlined
                                                  : state.result[index].type ==
                                                          'call'
                                                      ? Icons.call
                                                      : Icons.error,
                                            ),
                                            Text(state.result[index].id
                                                .toString()),
                                          ],
                                        ),
                                        title: Center(
                                          child:
                                              Text(state.result[index].date!),
                                        ),
                                        trailing: Text(
                                            "${state.result[index].duration}"),
                                        onTap: () {
                                          if (state.result[index].type ==
                                              'visit') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return NewVisitPage(
                                                    operationsModel:
                                                        state.result[index],
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                          if (state.result[index].type ==
                                              'call') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return NewCallPage(
                                                    operationsModel:
                                                        state.result[index],
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else if (state is OperationsError) {
                              showSnackBar(
                                context: context,
                                content: 'حدث خطأ ما',
                                failure: true,
                              );
                              return const Center(
                                  child: Text(
                                      'حدث خطأ عند الحصول على عمليات الزبون'));
                            } else {
                              return const Center(
                                  child: Text('لا يوجد عمليات للزبون'));
                            }
                          },
                        ),
                      ],
                    ),
            ),
          ),
        );
      }),
    );
  }

  void _searchCustomer(BuildContext context) {
    context.read<SalesBloc>().add(
          SalesSearch<CustomerBriefViewModel>(lexum: _searchController.text),
        );
  }

  void _showCustomerDialog(
      BuildContext context, List<CustomerBriefViewModel> customers) {
    showDialog(
      context: context,
      builder: (BuildContext newcontext) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              'يرجى اختيار زبون',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: customers.length,
                itemBuilder: (newcontext, index) {
                  return ListTile(
                      leading: CircleAvatar(
                        radius: 10,
                        child: Text(
                          customers[index].id.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 8),
                        ),
                      ),
                      title: Column(
                        children: [
                          Text(customers[index].customerName ?? ''),
                          Text(customers[index].shopName ?? ''),
                        ],
                      ),
                      subtitle: Text(
                        '${customers[index].governate ?? ''} - ${customers[index].region ?? ''}',
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCustomer = customers[index];
                        });
                        context.read<OperationsBloc>().add(
                              GetAllOperationsForCustomer(
                                customerID: customers[index].id,
                              ),
                            );
                        Navigator.of(context).pop();
                      });
                },
              ),
            ),
            actions: [
              TextButton(
                child: const Text('إغلاق'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
