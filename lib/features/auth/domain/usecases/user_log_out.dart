import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/auth/domain/repository/auth_repository.dart';

class UserLogOut implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;

  UserLogOut({required this.authRepository});
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    var logOutResult = await authRepository.clearSession();
    return logOutResult.fold(
      (failure) {
        return logOutResult;
      },
      (success) {
        return logOutResult;
      },
    );
  }
}
