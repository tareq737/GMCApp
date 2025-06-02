part of 'additional_operations_bloc.dart';

@immutable
sealed class AdditionalOperationsEvent {}

class GetAdditionalOperationsPagainted extends AdditionalOperationsEvent {
  final int page;
  final bool done;
  final String? department;

  GetAdditionalOperationsPagainted({
    required this.page,
    required this.done,
    this.department,
  });
}

class AddAdditionalOperation extends AdditionalOperationsEvent {
  final AdditionalOperationsModel additionalOperationsModel;

  AddAdditionalOperation({required this.additionalOperationsModel});
}

class UpdateAdditionalOperation extends AdditionalOperationsEvent {
  final AdditionalOperationsModel additionalOperationsModel;
  final int id;

  UpdateAdditionalOperation(
      {required this.additionalOperationsModel, required this.id});
}

class GetOneAdditionalOperations extends AdditionalOperationsEvent {
  final int id;

  GetOneAdditionalOperations({required this.id});
}
