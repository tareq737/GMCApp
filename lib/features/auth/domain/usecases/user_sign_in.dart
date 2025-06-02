import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/usecase/usecase.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/features/auth/domain/repository/auth_repository.dart';

class UserSignIn implements UseCase<UserEntity, UserLoginParams> {
  final AuthRepository authRepository;

  const UserSignIn({required this.authRepository});

  @override
  Future<Either<Failure, UserEntity>> call(UserLoginParams params) async {
    var signInResult = await authRepository.signIn(
      username: params.username,
      password: params.password,
      fcm_token: params.fcm_token,
    );
    return await signInResult.fold((failure) {
      return signInResult;
    }, (success) async {
      print(' Usecase user is ${success.groups}');
      final saveResult = await authRepository.saveSession(user: success);
      return saveResult.fold(
        (saveFailure) => Left(saveFailure),
        (saveSuccess) => Right(success),
      );
    });
  }
}

class UserLoginParams {
  final String username;
  final String password;
  final String fcm_token;

  UserLoginParams(
      {required this.username,
      required this.password,
      required this.fcm_token});
}
