import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gmcappclean/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:gmcappclean/core/common/widgets/animated_shadow_button.dart';
import 'package:gmcappclean/core/common/widgets/loader.dart';
import 'package:gmcappclean/core/common/widgets/mybutton.dart';
import 'package:gmcappclean/core/services/version_checker.dart';
import 'package:gmcappclean/core/theme/app_colors.dart';
import 'package:gmcappclean/core/theme/theme_cubit.dart';
import 'package:gmcappclean/core/utils/show_snackbar.dart';
import 'package:gmcappclean/features/Exchange%20Rate/ui/rate_list_page.dart';
import 'package:gmcappclean/features/Inventory/ui/groups_list_page.dart';
import 'package:gmcappclean/features/Inventory/ui/items_list_page.dart';
import 'package:gmcappclean/features/Inventory/ui/items_tree_page.dart';
import 'package:gmcappclean/features/Inventory/ui/warehouse_list_page.dart';
import 'package:gmcappclean/features/Prayer_times/bloc/prayer_times_bloc.dart';
import 'package:gmcappclean/features/Prayer_times/services/prayer_times_service.dart';
import 'package:gmcappclean/features/Purchases/UI/purchases_list.dart';
import 'package:gmcappclean/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:gmcappclean/features/auth/presentation/pages/singin_page.dart';
import 'package:gmcappclean/features/maintenance/UI/maintenance_list_page.dart';
import 'package:gmcappclean/features/production_management/additional_operations/ui/list_additional_operations_page.dart';
import 'package:gmcappclean/features/production_management/production/ui/production_list.dart';
import 'package:gmcappclean/features/production_management/production_ready/presentation/pages/full_prod_plan_page.dart';
import 'package:gmcappclean/features/production_management/total_production/ui/export_excel_tasks_page.dart';
import 'package:gmcappclean/features/production_management/total_production/ui/total_production_page.dart';
import 'package:gmcappclean/features/reset_password/ui/change_password_page.dart';
import 'package:gmcappclean/features/reset_password/ui/reset_password_page.dart';
import 'package:gmcappclean/features/sales_management/customers/presentation/pages/full_coustomers_page.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_call_page.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/new_visit_page.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/operations_date_page.dart';
import 'package:gmcappclean/features/sales_management/operations/ui/operations_page.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    AppUserState state = context.read<AppUserCubit>().state;
    List<String>? groups;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
    }

    return BlocListener<AppUserCubit, AppUserState>(
      listener: (context, state) {
        if (state is AppUserInitial) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => (const SinginPage())),
          );
        }
      },
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('الصفحة الرئيسية'),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.settings),
                onSelected: (value) {
                  switch (value) {
                    case 'change_password':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordPage(),
                        ),
                      );
                      break;
                    case 'reset_password':
                      if (groups != null && groups.contains('admins')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResetPasswordPage(),
                          ),
                        );
                      }
                      break;
                    case 'toggle_theme':
                      context.read<ThemeCubit>().toggleTheme();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'change_password',
                    child: ListTile(
                      leading: Icon(Icons.password),
                      title: Text('تغيير كلمة المرور'),
                    ),
                  ),
                  if (groups != null && groups.contains('admins'))
                    const PopupMenuItem(
                      value: 'reset_password',
                      child: ListTile(
                        leading: Icon(Icons.lock_reset),
                        title: Text('إعادة ضبط كلمة المرور'),
                      ),
                    ),
                  PopupMenuItem(
                    value: 'toggle_theme',
                    child: ListTile(
                      leading: Icon(
                        Theme.of(context).brightness == Brightness.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      title: const Text('تبديل المظهر'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: Center(
              child: BlocProvider(
                create: (context) => PrayerTimesBloc(
                  prayerTimesService: PrayerTimesService(),
                )..add(GetPrayerTimes(date: DateTime.now())),
                child: Column(
                  children: [
                    Expanded(
                      flex: 70,
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _animation.value,
                            child: Image.asset(
                              'assets/images/app_logo.png',
                              width: 150,
                              height: 150,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 60,
                      child: BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
                        builder: (context, state) {
                          if (state is PrayerTimesLoading) {
                            return const Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Loader(),
                              ),
                            );
                          }
                          if (state is PrayerTimesGetSuccess) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(DateTime.now()),
                                  ),
                                  Text(
                                    '${state.opResult.hijriDay}-${state.opResult.hijiMonth}-${state.opResult.hijriYear}',
                                  ),
                                  const SizedBox(height: 10),
                                  Flexible(
                                    child: GridView.count(
                                      crossAxisCount: isLandscape ? 6 : 3,
                                      crossAxisSpacing: 5,
                                      children: [
                                        prayerTimeCard(
                                          Icons.wb_twighlight,
                                          'الفجر',
                                          state.opResult.fajr,
                                        ),
                                        prayerTimeCard(
                                          Icons.wb_sunny,
                                          'الشروق',
                                          state.opResult.sunrise,
                                        ),
                                        prayerTimeCard(
                                          Icons.access_time,
                                          'الظهر',
                                          state.opResult.dhuhr,
                                        ),
                                        prayerTimeCard(
                                          Icons.wb_cloudy,
                                          'العصر',
                                          state.opResult.asr,
                                        ),
                                        prayerTimeCard(
                                          Icons.nights_stay,
                                          'المغرب',
                                          state.opResult.maghrib,
                                        ),
                                        prayerTimeCard(
                                          Icons.brightness_3,
                                          'العشاء',
                                          state.opResult.isha,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (state is PrayerTimesGetFailure) {
                            return const Center(
                              child: Icon(Icons.error, color: Colors.red),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          drawer: Drawer(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                Theme.of(context).brightness == Brightness.dark
                                    ? [AppColors.gradient1, AppColors.gradient2]
                                    : [
                                        AppColors.lightGradient1,
                                        AppColors.lightGradient2,
                                      ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AvatarGlow(
                              child: Material(
                                color: Colors.transparent,
                                elevation: 8.0,
                                shape: const CircleBorder(),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.6,
                                  ),
                                  child: SizedBox(
                                    width: 40,
                                    child: Image.asset(
                                      'assets/images/app_logo.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BlocBuilder<AppUserCubit, AppUserState>(
                                  builder: (context, state) {
                                    if (state is AppUserLoggedIn) {
                                      return Text(
                                        "${state.userEntity.firstName} ${state.userEntity.lastName}",
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 15,
                                        ),
                                      );
                                    } else {
                                      return const Text('');
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (groups != null &&
                          (groups.contains('Sales') ||
                              groups.contains('admins')))
                        ExpansionTile(
                          leading: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset('assets/images/sales_dep.png'),
                          ),
                          title: const Text('قسم المبيعات'),
                          children: [
                            ListTile(
                              title: const Text('كافة الزبائن'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FullCoustomersPage(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('زيارة جديدة'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const NewVisitPage();
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('اتصال جديد'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const NewCallPage();
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('عمليات زبون'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const OperationsPage();
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('العمليات ضمن مدة'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const OperationsDatePage();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ExpansionTile(
                        leading: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/warehouse_dep.png'),
                        ),
                        title: const Text('قسم المستودعات'),
                        children: [
                          ListTile(
                            title: const Text('المستودعات'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const WarehouseListPage(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text('المجموعات'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const GroupsListPage();
                                  },
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text('المواد'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ItemsListPage();
                                  },
                                ),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text('شجرة المواد'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const ItemsTreePage();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      if (groups != null &&
                          (groups.contains('production') ||
                              groups.contains('admins')))
                        ExpansionTile(
                          leading: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset(
                              'assets/images/manufacturing.png',
                            ),
                          ),
                          title: const Text('قسم الإنتاج'),
                          children: [
                            ListTile(
                              title: const Text('الجهوزية'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const FullProdPlanPage(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('الإنتاج'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProductionList(
                                      type: 'Production',
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('أرشيف الإنتاج'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ProductionList(
                                      type: 'Archive',
                                    ),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('الأعمال الإضافية'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ListAdditionalOperationsPage(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('عمل الموظفين'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TotalProductionPage(),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('البرنامج الفردي'),
                              onTap: () async {
                                if (!Platform.isWindows) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('غير مدعوم'),
                                      content: const Text(
                                        'هذه الميزة متاحة فقط على نظام Windows.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('موافق'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                final AppUserState appUserState =
                                    context.read<AppUserCubit>().state;
                                List<String> userGroups = [];
                                if (appUserState is AppUserLoggedIn) {
                                  userGroups =
                                      appUserState.userEntity.groups ?? [];
                                }

                                final Map<String, Map<String, String>>
                                    departmentAccess = {
                                  'RawMaterials': {
                                    'displayName': 'قسم الأولية',
                                    'requiredGroup': 'raw_material_dep'
                                  },
                                  'Manufacturing': {
                                    'displayName': 'قسم التصنيع',
                                    'requiredGroup': 'manufacturing_dep'
                                  },
                                  'Lab': {
                                    'displayName': 'قسم المخبر',
                                    'requiredGroup': 'lab_dep'
                                  },
                                  'EmptyPackaging': {
                                    'displayName': 'قسم الفوارغ',
                                    'requiredGroup': 'emptyPackaging_dep'
                                  },
                                  'Packaging': {
                                    'displayName': 'قسم التعبئة',
                                    'requiredGroup': 'packaging_dep'
                                  },
                                  'FinishedGoods': {
                                    'displayName': 'قسم الجاهزة',
                                    'requiredGroup': 'finishedGoods_dep'
                                  },
                                };
                                // Check if the user is an admin
                                final bool isAdmin =
                                    userGroups.contains('admins');
                                final List<
                                        MapEntry<String, Map<String, String>>>
                                    accessibleDepartments = isAdmin
                                        ? departmentAccess.entries
                                            .toList() // Admins get all departments
                                        : departmentAccess.entries
                                            .where((entry) =>
                                                userGroups.contains(entry
                                                    .value['requiredGroup']))
                                            .toList();

                                String? selectedDepartment;

                                if (accessibleDepartments.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('لا توجد أقسام متاحة'),
                                      content: const Text(
                                        'ليس لديك صلاحيات للوصول إلى أي قسم.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('موافق'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return; // Exit if no accessible departments
                                } else if (accessibleDepartments.length == 1) {
                                  // If only one department is accessible, select it automatically
                                  selectedDepartment =
                                      accessibleDepartments.first.key;
                                } else {
                                  // If multiple departments are accessible, show the dialog for selection
                                  final List<Widget> departmentListTiles =
                                      accessibleDepartments.map((entry) {
                                    return ListTile(
                                      title: Text(entry.value['displayName']!),
                                      onTap: () => Navigator.pop(
                                        context,
                                        entry
                                            .key, // Returns the backend department code
                                      ),
                                    );
                                  }).toList();

                                  selectedDepartment = await showDialog<String>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('اختر القسم'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: departmentListTiles,
                                      ),
                                    ),
                                  );
                                }

                                // Navigate to ExportExcelTasksPage if a department was selected (either automatically or by user)
                                if (selectedDepartment != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ExportExcelTasksPage(
                                        department: selectedDepartment!,
                                        departmentDisplayName: departmentAccess[
                                                selectedDepartment]![
                                            'displayName']!,
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ListTile(
                        leading: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/purchases_dep.png'),
                        ),
                        title: const Text('المشتريات'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const PurchasesList();
                              },
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/maintenance _dep.png',
                          ),
                        ),
                        title: const Text('الصيانة'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const MaintenanceListPage();
                              },
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/rate.png'),
                        ),
                        title: const Text('أسعار الصرف'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const RateListPage();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Color(0xFF1877F2), // Facebook Blue
                      ),
                      onPressed: () async {
                        var url = Uri.https('facebook.com', 'GMCpaint');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Color(0xFF25D366), // WhatsApp Green
                      ),
                      onPressed: () async {
                        var url = Uri.parse('https://wa.me/+963991177992');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.telegram,
                        color: Color(0xFF0088cc), // Telegram Blue
                      ),
                      onPressed: () async {
                        var url = Uri.parse('https://t.me/gmcpaints');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.instagram),
                      color: Color(0xFFE1306C),
                      onPressed: () async {
                        Uri url = Uri.parse(
                          'https://www.instagram.com/gmcpaints',
                        );

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.globe,
                        color: Colors.blueGrey,
                      ),
                      onPressed: () async {
                        var url = Uri.https('ofc.com.sy');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  ],
                ),
                const Divider(),
                Column(
                  spacing: 10,
                  children: [
                    const VersionCheckRow(),

                    // AnimatedShadowButton(
                    //   text: 'تسجيل خروج',
                    //   onPressed: () {
                    //     context.read<AuthBloc>().add(AuthLogOut());
                    //   },
                    // ),
                    Mybutton(
                      text: 'تسجيل خروج',
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogOut());
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget prayerTimeCard(IconData icon, String prayerName, String time) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.blueAccent),
          Text(
            prayerName,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(time, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

class VersionText extends StatelessWidget {
  const VersionText({super.key});

  Future<String> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version; // Retrieves version from pubspec.yaml
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...'); // Placeholder while fetching
        }
        if (snapshot.hasError) {
          return const Text('Error'); // Handle errors
        }
        return Text(
          "Version ${snapshot.data ?? 'Unknown'}",
          style: const TextStyle(fontSize: 10),
        ); // Display actual version
      },
    );
  }
}

class VersionCheckRow extends StatefulWidget {
  const VersionCheckRow({super.key});

  @override
  State<VersionCheckRow> createState() => _VersionCheckRowState();
}

class _VersionCheckRowState extends State<VersionCheckRow> {
  bool _isChecking = false;

  void _checkVersion() async {
    setState(() => _isChecking = true);

    // Pass notifyIfLatest: true to show a SnackBar if already up-to-date
    await VersionChecker.check(context, notifyIfLatest: true);

    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const VersionText(),
        _isChecking
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(width: 18, height: 18, child: Loader()),
              )
            : IconButton(
                onPressed: _checkVersion,
                icon:
                    const Icon(Icons.refresh_rounded, color: Colors.blueAccent),
              ),
      ],
    );
  }
}
