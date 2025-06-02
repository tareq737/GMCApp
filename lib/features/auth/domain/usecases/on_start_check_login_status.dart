import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/auth/domain/repository/auth_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class OnStartCheckLoginStatus implements UseCase<UserEntity, NoParams> {
  final AuthRepository authRepository;

  OnStartCheckLoginStatus({required this.authRepository});
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    var result = authRepository.getSession();

    return await result.fold(
      (failure) => left(failure),
      (hastokens) async {
        print('F get session firstname: ${hastokens.firstName}');
        bool isRefreshTokenValid =
            !JwtDecoder.isExpired(hastokens.refreshToken);
        if (isRefreshTokenValid) {
          return right(hastokens);
        }
        return right(hastokens);
      },
    );
  }
}
