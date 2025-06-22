import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/usecases/barrel_usecases.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/usecases/export_excel_customers.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/usecases/get_all_customers_paginated.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/mapper/customer_brief_mapper.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/mapper/customer_mapper.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_brief_view_model.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/viewmodels/customer_view_model.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  final AddCustomer _addCustomer;
  final DeleteCustomer _deleteCustomer;
  final UpdateCustomer _updateCustomer;
  final GetCustomer _getCustomer;
  final SearchCustomer _searchCustomer;
  final GetAllCustomersPaginated _getAllCustomersPaginated;
  final ExportCustomers _exportCustomers;

  SalesBloc({
    required AddCustomer addCustomer,
    required DeleteCustomer deleteCustomer,
    required UpdateCustomer updateCustomer,
    required GetCustomer getCustomer,
    required SearchCustomer searchCustomer,
    required GetAllCustomersPaginated getAllCustomersPaginated,
    required ExportCustomers exportCustomers,
  })  : _addCustomer = addCustomer,
        _deleteCustomer = deleteCustomer,
        _updateCustomer = updateCustomer,
        _getCustomer = getCustomer,
        _searchCustomer = searchCustomer,
        _getAllCustomersPaginated = getAllCustomersPaginated,
        _exportCustomers = exportCustomers,
        super(SalesInitial()) {
    on<SalesEvent>(
      (event, emit) {
        emit(SalesOpLoading());
      },
    );

    on<SalesAddCustomer>(
      (event, emit) async {
        print('bloc has been reached');
        final result = await _addCustomer(event.item);
        result.fold(
          (failure) {
            emit(SalesOpFailure(message: failure.message));
            print('bloc has failure');
          },
          (success) {
            print('bloc has successed \n ${success.basicInfo.toString()}');
            emit(
              SalesOpSuccess<CustomerViewModel>(
                opResult:
                    CustomerPresentationMapper.toViewModel(entity: success),
              ),
            );
          },
        );
      },
    );
    on<SalesUpdateCustomer>(
      (event, emit) async {
        final result = await _updateCustomer(event.item);
        result.fold(
          (failure) {
            emit(SalesOpFailure(message: failure.message));
          },
          (success) {
            emit(
              SalesOpSuccess<CustomerViewModel>(
                opResult:
                    CustomerPresentationMapper.toViewModel(entity: success),
              ),
            );
          },
        );
      },
    );

    on<SalesDelete<CustomerViewModel>>(
      (event, emit) async {
        final result = await _deleteCustomer(event.id);
        result.fold(
          (failure) {
            emit(SalesOpFailure(message: failure.message));
          },
          (success) {
            emit(
              SalesOpSuccess<bool>(opResult: success),
            );
          },
        );
      },
    );
    on<SalesGetById<CustomerViewModel>>(
      (event, emit) async {
        final result = await _getCustomer(event.id);
        result.fold(
          (failure) {
            emit(SalesOpFailure(message: failure.message));
          },
          (success) {
            emit(
              SalesOpSuccess<CustomerViewModel>(
                opResult:
                    CustomerPresentationMapper.toViewModel(entity: success),
              ),
            );
          },
        );
      },
    );
    on<SalesGetAllPaginated<CustomerBriefViewModel>>(
      (event, emit) async {
        final result = await _getAllCustomersPaginated(PaginatedSalesParams(
          page: event.page,
          hasCood: event.hasCood,
          pageSize: event.pageSize,
          search: event.search,
        ));
        result.fold(
          (failure) {
            emit(SalesOpFailure(message: failure.message));
          },
          (success) {
            emit(
              SalesOpSuccess<List<CustomerBriefViewModel>>(
                opResult: List.generate(
                  success.length,
                  (index) {
                    return CustomerBriefPresentationMapper.toViewModel(
                      entity: success[index],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );

    on<SalesSearch<CustomerBriefViewModel>>(
      (event, emit) async {
        final result = await _searchCustomer(event.lexum);
        result.fold(
          (failure) {
            emit(SalesOpFailure(message: failure.message));
          },
          (success) {
            emit(
              SalesOpSuccess<List<CustomerBriefViewModel>>(
                opResult: List.generate(
                  success.length,
                  (index) {
                    return CustomerBriefPresentationMapper.toViewModel(
                      entity: success[index],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );

    on<ExportExcelCustomers>(
      (event, emit) async {
        var result = await _exportCustomers(NoParams());
        result.fold(
          (failure) {
            emit(SalesOpFailure(message: failure.message));
          },
          (success) {
            emit(SalesOpSuccess(opResult: success));
          },
        );
      },
    );
  }
}
