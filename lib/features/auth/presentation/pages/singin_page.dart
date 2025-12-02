import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/Pages/home_page_imports.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gmcappclean/features/auth/presentation/widgets/auth_field.dart';
import 'package:gmcappclean/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:dio/dio.dart';

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

  // Focus nodes for handling Enter key navigation
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  // Initialize to null and conditionally assign it in initState
  FirebaseMessaging? _messaging;
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    // Only initialize and run Firebase-related logic if NOT Windows
    if (!Platform.isWindows) {
      _messaging = FirebaseMessaging.instance;
      requestPermission();
      getToken();
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Helper function to check if Firebase is available
  bool get _isFirebaseEnabled => _messaging != null;

  void requestPermission() async {
    // Check added here for safety, though it should be handled in initState
    if (_isFirebaseEnabled) {
      // NOTE: requestPermission is now awaited on the non-null _messaging instance
      NotificationSettings settings = await _messaging!.requestPermission(
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
    // Check added here for safety, though it should be handled in initState
    if (_isFirebaseEnabled) {
      // NOTE: getToken is now awaited on the non-null _messaging instance
      String? token = await _messaging!.getToken();

      if (!mounted) return;

      setState(() {
        fcmToken = token;
      });
      print('🔑 FCM Token: $fcmToken');

      if (token != null && token.isNotEmpty) {
        final apiClient = ApiClient(dio: Dio());
        // Added check for isWindows to ensure this API call also doesn't
        // attempt to use a null token when running on Windows
        // In a real app, you might only call this if you need to clear a token
        if (!Platform.isWindows) {
          await apiClient.clearFcmToken(token);
        }
      }
    }
  }

  void _onSignInButtonPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      // If running on Windows, fcmToken will be null. Use '' as fallback.
      final String tokenToSend = fcmToken ?? '';

      context.read<AuthBloc>().add(
            AuthSignIn(
              username: usernameController.text.trim(),
              password: passwordController.text.trim(),
              fcm_token: tokenToSend,
            ),
          );
    }
  }

  // Method to handle Enter key press
  void _handleEnterKey(BuildContext context) {
    if (_usernameFocusNode.hasFocus) {
      // If username field is focused, move to password field
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    } else if (_passwordFocusNode.hasFocus) {
      // If password field is focused, submit the form
      _onSignInButtonPressed(context);
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
                            focusNode: _usernameFocusNode,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => _handleEnterKey(context),
                          ),
                          const SizedBox(height: 15),
                          AuthField(
                            hintText: 'كلمة المرور',
                            controller: passwordController,
                            isObscureText: true,
                            focusNode: _passwordFocusNode,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleEnterKey(context),
                          ),
                          const SizedBox(height: 20),
                          AuthGradientButton(
                            onPressed: () => _onSignInButtonPressed(context),
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
