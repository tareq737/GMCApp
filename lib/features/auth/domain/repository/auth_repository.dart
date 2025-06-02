import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn({
    required String username,
    required String password,
    required String fcm_token,
  });
  Future<Either<Failure, bool>> clearSession();
  Future<Either<Failure, bool>> saveSession({required UserEntity user});
  Either<Failure, UserEntity> getSession();
  Future<Either<Failure, UserEntity>> refreshSession(
      {required UserEntity currentUser});
}
