import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:gmcappclean/features/reset_password/models/reset_password_model.dart';
import 'package:gmcappclean/features/reset_password/services/reset_password_service.dart';
import 'package:gmcappclean/init_dependencies.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _usenameController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usenameController.text = '';
    _newPasswordController.text = '';
  }

  @override
  void dispose() {
    _usenameController.dispose();
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
            title: const Text('إعادة تعيين كلمة المرور'),
          ),
          body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
            listener: (context, state) {
              if (state is ResetPasswordSuccess) {
                showSnackBar(
                  context: context,
                  content: 'تمت إعادة ضبط كلمة المرور بنجاح',
                  failure: false,
                );
                _usenameController.text = '';
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextField(
                      controller: _usenameController,
                      labelText: 'اسم المستخدم',
                    ),
                    const SizedBox(height: 16),
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
                                final model = ResetPasswordModel(
                                  new_password: _newPasswordController.text,
                                );

                                context.read<ResetPasswordBloc>().add(
                                      ResetPassword(
                                        resetPasswordModel: model,
                                        username: _usenameController.text,
                                      ),
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
