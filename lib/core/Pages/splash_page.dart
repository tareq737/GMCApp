import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmcappclean/core/Pages/home_page_imports.dart';
import 'package:gmcappclean/core/common/api/api.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/services/version_checker.dart';
import 'package:gmcappclean/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gmcappclean/features/auth/presentation/pages/singin_page.dart';
import 'package:gmcappclean/core/services/auth_interactor.dart';
import 'package:gmcappclean/core/services/refresh_groups.dart';
import 'package:gmcappclean/init_dependencies.dart';

class SplashPage extends StatefulWidget {
  final RemoteMessage? initialMessage;
  const SplashPage({super.key, this.initialMessage});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isTimerDone = false;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    await _refreshGroups();
    if (!mounted) return;
    _startTimer();
  }

  Future<void> _refreshGroups() async {
    final apiClient = getIt<ApiClient>();
    final authInteractor = getIt<AuthInteractor>();

    final refresher = RefreshGroups(
      apiClient: apiClient,
      authInteractor: authInteractor,
    );

    await refresher.refreshUserGroup().then((value) {
      debugPrint("Groups refreshed: $value");
    }).catchError((e) {
      debugPrint("Error refreshing groups: $e");
    });
  }

  void _startTimer() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final isVersionOkay = await VersionChecker.check(context);

    if (!mounted) return;

    if (isVersionOkay) {
      setState(() => _isTimerDone = true);
      _checkToNavigate();
    }
  }

  void _checkToNavigate() async {
    if (_isTimerDone) {
      await Future.delayed(const Duration(seconds: 1));
      context.read<AuthBloc>().add(AuthIsUserLoggedin());
      await Future.delayed(const Duration(milliseconds: 500));

      final initialMessage = widget.initialMessage;
      if (initialMessage != null &&
          initialMessage.data['navigate_to'] != null) {
        SplashNavigator.navigateBasedNavigate(
          context,
          context.read<AppUserCubit>().state,
          initialMessage,
        );
      } else {
        SplashNavigator.navigateBasedOnState(
          context,
          context.read<AppUserCubit>().state,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Animate(
          child: Image.asset('assets/images/app_logo.png')
              .animate()
              .scale(duration: 2000.ms),
        ),
      ),
    );
  }
}

class SplashNavigator {
  static Route _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static void navigateBasedOnState(BuildContext context, AppUserState state) {
    final target =
        state is AppUserLoggedIn ? const HomePage() : const SinginPage();
    Navigator.pushReplacement(context, _fadeRoute(target));
  }

  static void navigateBasedNavigate(
    BuildContext context,
    AppUserState state,
    RemoteMessage initialMessage,
  ) {
    final targetRoute = initialMessage.data['navigate_to'];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(navigateTo: targetRoute),
      ),
    );
  }
}
