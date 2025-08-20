import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/common/widgets/mytextfield.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/notification/bloc/notification_bloc.dart';
import 'package:gmcappclean/features/notification/service/notification_service.dart';
import 'package:gmcappclean/features/reset_password/bloc/reset_password_bloc.dart';
import 'package:gmcappclean/init_dependencies.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  final _usenameController = TextEditingController();
  final _groupController = TextEditingController();
  final _messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _usenameController.text = '';
    _groupController.text = '';
    _messageController.text = '';
  }

  @override
  void dispose() {
    _usenameController.dispose();
    _groupController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationBloc>(
      create: (context) => NotificationBloc(
        NotificationService(
          apiClient: getIt<ApiClient>(),
          authInteractor: getIt<AuthInteractor>(),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('إشعار للمستخدمين'),
          ),
          body: BlocConsumer<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is SuccessNotification) {
                showSnackBar(
                  context: context,
                  content: 'تم إرسال الإشعار بنجاح',
                  failure: false,
                );
              } else if (state is ErrorNotification) {
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
                  spacing: 15,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextField(
                      controller: _usenameController,
                      labelText: 'المستخدم',
                    ),
                    MyTextField(
                      controller: _groupController,
                      labelText: 'المجموعة',
                    ),
                    MyTextField(
                      controller: _messageController,
                      labelText: 'الرسالة',
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: state is ResetPasswordLoading
                          ? const Loader()
                          : Mybutton(
                              text: 'إشعار',
                              onPressed: () {
                                context.read<NotificationBloc>().add(
                                      Notify(
                                        username:
                                            _usenameController.text.isNotEmpty
                                                ? _usenameController.text
                                                : null,
                                        group: _groupController.text.isNotEmpty
                                            ? _groupController.text
                                            : null,
                                        message: _messageController.text,
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
