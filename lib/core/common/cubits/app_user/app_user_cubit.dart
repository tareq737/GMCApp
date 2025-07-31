// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/entities/user_entity.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser({UserEntity? user}) {
    if (user == null) {
      print(
          'no valid user (both access and refresh are invalid or no tokens at all)');
      emit(AppUserInitial());
    } else {
      print('Cubit user is ${user.groups}');
      emit(AppUserLoggedIn(userEntity: user));
    }
  }

  void updateUserGroups(List<String> newGroups) {
    if (state is AppUserLoggedIn) {
      final currentState = state as AppUserLoggedIn;
      final updatedUser = currentState.userEntity.copyWith(groups: newGroups);
      emit(AppUserLoggedIn(userEntity: updatedUser));
    }
  }
}
