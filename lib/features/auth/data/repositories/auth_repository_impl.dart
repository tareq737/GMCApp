// ignore_for_file: avoid_print

import 'package:fpdart/fpdart.dart';
import 'package:gmcappclean/core/error/failures.dart';
import 'package:gmcappclean/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';
import 'package:gmcappclean/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:gmcappclean/features/auth/data/models/user_model.dart';
import 'package:gmcappclean/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, UserEntity>> signIn(
      {required String username,
      required String password,
      required String fcm_token}) async {
    try {
      final user = await remoteDataSource.signIn(
        username: username,
        password: password,
        fcm_token: fcm_token,
      );
      return right(user);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> saveSession({required UserEntity user}) async {
    try {
      if (await localDataSource.saveSession(
        user: UserModel(
          accessToken: user.accessToken,
          refreshToken: user.refreshToken,
          firstName: user.firstName,
          lastName: user.lastName,
          groups: user.groups,
        ),
      )) {
        return right(true);
      } else {
        return left(Failure(message: 'session Tokens were not saved!'));
      }
    } catch (e) {
      return left(Failure(message: 'session Tokens were not saved!'));
    }
  }

  @override
  Either<Failure, UserEntity> getSession() {
    try {
      UserModel? userTokens = localDataSource.getUserTokens;
      if (userTokens is UserModel) {
        print('F in get session impl ${userTokens.firstName}');
        return right(userTokens);
      } else {
        return left(Failure(message: 'no session tokens were found'));
      }
    } catch (e) {
      return left(Failure(message: 'Exception while fetching session tokens!'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> refreshSession(
      {required UserEntity currentUser}) async {
    try {
      final user = await remoteDataSource.refreshCurrentUser(
        userModel: UserModel(
          accessToken: currentUser.accessToken,
          refreshToken: currentUser.refreshToken,
          firstName: currentUser.firstName,
          lastName: currentUser.lastName,
          groups: currentUser.groups,
        ),
      );
      if (user == null) {
        return left(Failure(message: 'user is not logged in!'));
      }

      return right(user);
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> clearSession() async {
    try {
      bool res = await localDataSource.clearSession();
      if (res) {
        return right(res);
      } else {
        return left(Failure(message: 'Could not clear tokens'));
      }
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
