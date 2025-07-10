import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:gmcappclean/core/Pages/splash_page.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/log/logger_service.dart';
import 'package:gmcappclean/features/Exchange Rate/ui/rate_list_page.dart';
import 'package:gmcappclean/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gmcappclean/features/maintenance/UI/maintenance_list_page.dart';
import 'package:gmcappclean/features/purchases/UI/purchases_list.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/pages/full_coustomers_page.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/operations_date_page.dart';
import 'package:gmcappclean/init_dependencies.dart';
import 'package:gmcappclean/core/theme/theme_cubit.dart';

// Global nav key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
RemoteMessage? globalInitialMessage;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LoggerService.redirectPrint();
  debugPrint('App Started');
  LoggerService.info('App Started from Logger');

  await initDependencies();
  await Firebase.initializeApp();
  await initializeLocalNotification();

  globalInitialMessage = await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      showNotification(message);
    }
  });

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AppUserCubit>()),
        BlocProvider(
            create: (_) => getIt<AuthBloc>()..add(AuthIsUserLoggedin())),
        BlocProvider(create: (_) => ThemeCubit()..loadTheme()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, theme) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'GMC App',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: SplashPage(initialMessage: globalInitialMessage),
          routes: {
            'RateListPage': (context) => const RateListPage(),
            'PurchasesList': (context) => const PurchasesList(
                  status: 1,
                ),
            'OperationsDatePage': (context) => const OperationsDatePage(),
            'MaintenanceListPage': (context) => const MaintenanceListPage(
                  status: 1,
                ),
            'FullCoustomersPage': (context) => const FullCoustomersPage(),
          },
        );
      },
    );
  }
}

Future<void> initializeLocalNotification() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'your_channel_id',
    'Your Channel Name',
    description: 'Your channel description',
    importance: Importance.high,
    sound: RawResourceAndroidNotificationSound('noti'),
    playSound: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'your_channel_id',
    'Your Channel Name',
    channelDescription: 'Your channel description',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    color: Color(0xFF2196F3),
    showWhen: true,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ?? 'No Title',
    message.notification?.body ?? 'No Body',
    notificationDetails,
    payload: jsonEncode(message.data),
  );
}
