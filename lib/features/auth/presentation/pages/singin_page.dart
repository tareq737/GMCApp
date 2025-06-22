import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/Pages/home_page.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gmcappclean/features/auth/presentation/widgets/auth_field.dart';
import 'package:gmcappclean/features/auth/presentation/widgets/auth_gradient_button.dart';

class SinginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SinginPage(),
      );
  const SinginPage({super.key});

  @override
  State<SinginPage> createState() => _SinginPageState();
}

class _SinginPageState extends State<SinginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  String? fcmToken;
  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void requestPermission() async {
    if (!Platform.isWindows) {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ User granted permission');
      } else {
        print('❌ User declined permission');
      }
    }
  }

  void getToken() async {
    if (!Platform.isWindows) {
      String? token = await _messaging.getToken();
      if (!mounted) return; // Prevent setState after dispose
      setState(() {
        fcmToken = token;
      });
      print('🔑 FCM Token: $fcmToken');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Center(
            // Center the entire content
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 24.0),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFailure) {
                      showSnackBar(
                        context: context,
                        content: 'حدث خطأ ما',
                        failure: true,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const Loader();
                    }
                    return Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'GMC',
                            style: TextStyle(
                              color:
                                  isDark ? AppColors.whiteColor : Colors.blue,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 40),
                          AuthField(
                            hintText: 'اسم المستخدم',
                            controller: usernameController,
                          ),
                          const SizedBox(height: 15),
                          AuthField(
                            hintText: 'كلمة المرور',
                            controller: passwordController,
                            isObscureText: true,
                          ),
                          const SizedBox(height: 20),
                          AuthGradientButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                      AuthSignIn(
                                        username:
                                            usernameController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        fcm_token: fcmToken ?? '',
                                      ),
                                    );
                              }
                            },
                            label: 'تسجيل دخول',
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
