import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:gmcappclean/features/reset_password/models/change_password_model.dart';
import 'package:gmcappclean/features/reset_password/services/reset_password_service.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _usenameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final userState = context.read<AppUserCubit>().state;
    if (userState is AppUserLoggedIn) {
      _usenameController.text = userState.userEntity.firstName ?? '';
    }

    _oldPasswordController.text = '';
    _newPasswordController.text = '';
  }

  @override
  void dispose() {
    _usenameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordBloc>(
      create: (context) => ResetPasswordBloc(
        ResetPasswordService(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('تغيير كلمة المرور'),
          ),
          body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordSuccess) {
                showSnackBar(
                  context: context,
                  content: 'تمت إعادة ضبط كلمة المرور بنجاح',
                  failure: false,
                );
                _oldPasswordController.text = '';
                _newPasswordController.text = '';
              } else if (state is ResetPasswordError) {
                showSnackBar(
                  context: context,
                  content: state.errorMessage,
                  failure: true,
                );
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextField(
                      controller: _usenameController,
                      labelText: 'اسم المستخدم',
                      readOnly: true,
                    ),
                    MyTextField(
                      controller: _oldPasswordController,
                      labelText: 'كلمة المرور الحالية',
                      obscureText: true,
                    ),
                    MyTextField(
                      controller: _newPasswordController,
                      labelText: 'كلمة المرور الجديدة',
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: state is ResetPasswordLoading
                          ? const Loader()
                          : Mybutton(
                              text: 'تعديل',
                              onPressed: () {
                                final newPassword =
                                    _newPasswordController.text.trim();
                                final oldPassword =
                                    _oldPasswordController.text.trim();

                                if (newPassword.length < 5) {
                                  showSnackBar(
                                    context: context,
                                    content:
                                        'كلمة المرور الجديدة يجب أن تكون على الأقل 5 أحرف',
                                    failure: true,
                                  );
                                  return;
                                }

                                final model = ChangePasswordModel(
                                  old_password: oldPassword,
                                  new_password: newPassword,
                                );

                                context.read<ResetPasswordBloc>().add(
                                      ChangePassword(
                                          changePasswordModel: model),
                                    );
                              },
                            ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
