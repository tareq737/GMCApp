import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/auth/domain/usecases/check_user_session_status.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/bloc/sales_bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/bloc/operations_bloc.dart';
import 'package:gmcappclean/features/sales_management/operations/models/operations_model.dart';
import 'package:gmcappclean/features/sales_management/operations/services/operations_services.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_call_page.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_visit_page.dart';
import 'package:gmcappclean/init_dependencies.dart';

class CustomerOperationsPage extends StatefulWidget {
  final int customerId;
  final String customerName;
  final String shopName;
  const CustomerOperationsPage(
      {super.key,
      required this.customerId,
      required this.customerName,
      required this.shopName});

  @override
  State<CustomerOperationsPage> createState() => _CustomerOperationsPageState();
}

class _CustomerOperationsPageState extends State<CustomerOperationsPage> {
  @override
  void initState() {
    super.initState();
  }

  IconData _getOperationIcon(String type) {
    switch (type) {
      case 'visit':
        return Icons.work_history_outlined;
      case 'call':
        return Icons.call;
      default:
        return Icons.error;
    }
  }

  // NEW: Helper method to get the correct color for an operation type icon
  Color _getOperationIconColor(String type) {
    switch (type) {
      case 'visit':
        return Colors.blue.shade700;
      case 'call':
        return Colors.green.shade700;
      default:
        return Colors.red.shade700;
    }
  }

  // Helper method to navigate to the details page of an operation
  void _navigateToOperationDetails(
      BuildContext context, OperationsModel operation) {
    if (operation.type == 'visit') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewVisitPage(operationsModel: operation),
        ),
      );
    } else if (operation.type == 'call') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewCallPage(operationsModel: operation),
        ),
      );
    }
  }

  // Builds the ListView for portrait mode
  Widget _buildOperationsList(
      BuildContext context, List<OperationsModel> operations) {
    return ListView.builder(
      itemCount: operations.length,
      itemBuilder: (context, index) {
        final operation = operations[index];
        return Card(
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getOperationIcon(operation.type!),
                  color: _getOperationIconColor(operation.type!), // Apply color
                ),
                Text(operation.id.toString()),
              ],
            ),
            title: Center(child: Text(operation.date!)),
            trailing: Text("${operation.duration}"),
            onTap: () => _navigateToOperationDetails(context, operation),
          ),
        );
      },
    );
  }

  // Builds the GridView for landscape mode
  Widget _buildOperationsGrid(
      BuildContext context, List<OperationsModel> operations) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250, // Each item will have a max width of 250
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 4 / 3, // Adjust aspect ratio as needed
      ),
      itemCount: operations.length,
      itemBuilder: (context, index) {
        final operation = operations[index];
        return Card(
          child: InkWell(
            onTap: () => _navigateToOperationDetails(context, operation),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getOperationIcon(operation.type!),
                    size: 30,
                    color:
                        _getOperationIconColor(operation.type!), // Apply color
                  ),
                  const SizedBox(height: 8),
                  Text(operation.date!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("المدة: ${operation.duration}"),
                  const SizedBox(height: 4),
                  Text("المعرف: ${operation.id}"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<SalesBloc>(),
        ),
        BlocProvider(
          create: (context) => OperationsBloc(OperationsServices(
              apiClient: getIt<ApiClient>(),
              checkUserSessionStatus: getIt<CheckUserSessionStatus>()))
            ..add(GetAllOperationsForCustomer(customerID: widget.customerId)),
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
                  SizedBox(width: 10),
                  Icon(Icons.info_outline),
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
                                widget.customerId.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  widget.shopName,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  widget.customerName,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
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
                          child: isLandscape
                              ? _buildOperationsGrid(context, state.result)
                              : _buildOperationsList(context, state.result),
                        );
                      } else if (state is OperationsError) {
                        showSnackBar(
                          context: context,
                          content: 'حدث خطأ ما',
                          failure: true,
                        );
                        return const Center(
                            child:
                                Text('حدث خطأ عند الحصول على عمليات الزبون'));
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
}
