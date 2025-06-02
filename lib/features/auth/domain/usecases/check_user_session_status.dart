import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/features/auth/domain/repository/auth_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class CheckUserSessionStatus implements UseCase<UserEntity, NoParams> {
  final AuthRepository authRepository;

  CheckUserSessionStatus({required this.authRepository});
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    var result = authRepository.getSession();
    return await result.fold(
      (failure) => left(failure),
      (hastokens) async {
        print('F get session firstname: ${hastokens.firstName}');
        return await _handleTokens(hastokens);
      },
    );
  }

  Future<Either<Failure, UserEntity>> _handleTokens(
      UserEntity userEntity) async {
    bool isAccessTokenExpired = JwtDecoder.isExpired(userEntity.accessToken);
    bool isRefreshTokenValid = !JwtDecoder.isExpired(userEntity.refreshToken);
    print('F(handletokens in get session): ${userEntity.firstName}');

    if (isAccessTokenExpired) {
      if (isRefreshTokenValid) {
        final refreshResult = await _refreshAccessToken(userEntity);
        return refreshResult.fold(
          (failure) => right(userEntity),
          (success) => right(success),
        );
      } else {
        print('BOTH ACCESS AND REFRESH HAVE EXPIRED');
        return left(
            Failure(message: 'Refresh token has expired please login again'));
      }
    } else {
      if (isRefreshTokenValid) {
        return right(userEntity);
      } else {
        return left(
            Failure(message: 'Refresh token has expired please login again'));
      }
    }
  }

  Future<Either<Failure, UserEntity>> _refreshAccessToken(
      UserEntity userTokens) async {
    var userResult =
        await authRepository.refreshSession(currentUser: userTokens);
    return await userResult.fold(
      (failure) => left(failure),
      (user) async {
        print(' refresh first name F: ${user.firstName}');
        await authRepository.saveSession(user: user);

        return right(user);
      },
    );
  }
}
