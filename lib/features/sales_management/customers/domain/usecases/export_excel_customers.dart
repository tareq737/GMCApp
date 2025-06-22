import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/sales_management/customers/domain/repository/sales_repository.dart';

class ExportCustomers implements UseCase<Uint8List, NoParams> {
  final SalesRepository salesRepository;
  final AuthInteractor authInteractor;

  ExportCustomers({
    required this.salesRepository,
    required this.authInteractor,
  });
  @override
  Future<Either<Failure, Uint8List>> call(NoParams params) async {
    UserEntity? user = await authInteractor.getSession();
    if (user is UserEntity) {
      return await salesRepository.exportExcelCustomers(user: user);
    } else {
      return Left(Failure(message: 'User not found'));
    }
  }
}
