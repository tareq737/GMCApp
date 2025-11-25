part of 'home_page_imports.dart';

class HomePage extends StatefulWidget {
  final String? navigateTo;
  const HomePage({super.key, this.navigateTo});

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
    if (widget.navigateTo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, widget.navigateTo!);
      });
    }
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
    String? user;
    if (state is AppUserLoggedIn) {
      groups = state.userEntity.groups;
      user = state.userEntity.firstName;
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
                            builder: (_) => const ChangePasswordPage()),
                      );
                      break;
                    case 'reset_password':
                      if (groups != null && groups.contains('admins')) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ResetPasswordPage()),
                        );
                      }
                      break;
                    case 'notify':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotifyPage()),
                      );
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
                  if (groups != null && groups.contains('admins'))
                    const PopupMenuItem(
                      value: 'notify',
                      child: ListTile(
                        leading: Icon(Icons.notification_add),
                        title: Text('إشعارات'),
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
          body: Center(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => PrayerTimesBloc(
                    prayerTimesService: PrayerTimesService(),
                  )..add(GetPrayerTimes(date: DateTime.now())),
                ),
                BlocProvider(
                    create: (context) => StatisticsBloc(
                          StatisticsServices(
                            apiClient: getIt<ApiClient>(),
                            authInteractor: getIt<AuthInteractor>(),
                          ),
                        )),
              ],
              child: Column(
                children: [
                  if (groups != null &&
                      (groups.contains('managers') ||
                          groups.contains('admins')))
                    const Expanded(
                      child: StatisticsWidget(),
                    ),
                  if (groups == null ||
                      (!groups.contains('managers') &&
                          !groups.contains('admins')))
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
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
                          ),
                          Expanded(
                            child:
                                BlocBuilder<PrayerTimesBloc, PrayerTimesState>(
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
                                          '//${state.opResult.hijriDay}-${state.opResult.hijiMonth}-${state.opResult.hijriYear}',
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
                ],
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
                            BlocBuilder<AppUserCubit, AppUserState>(
                              builder: (context, state) {
                                if (state is AppUserLoggedIn) {
                                  return Text(
                                    "${state.userEntity.firstName} ${state.userEntity.lastName}",
                                    style: TextStyle(
                                      color:
                                          isDark ? Colors.white : Colors.black,
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
                      ),
                      if (groups != null &&
                          (groups.contains('Sales') ||
                              groups.contains('managers') ||
                              groups.contains('admins')))
                        ExpansionTile(
                          leading: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset('assets/images/sales_dep.png'),
                          ),
                          title: const Text('المبيعات'),
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
                              title: const Text('عملية جديدة'),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: AlertDialog(
                                        title: const Text('نوع العملية'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.place,
                                                  color: Colors.blue),
                                              title: const Text('زيارة جديدة'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NewVisitPage(),
                                                  ),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.call,
                                                  color: Colors.green),
                                              title: const Text('اتصال جديد'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NewCallPage(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
                                      return OperationsDatePage(
                                        fromDate: DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now()),
                                        toDate: DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now()),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('كفاءة منتجات'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const ProductEfficiencyListPage();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      if (groups != null &&
                          (groups.contains('accounting_&_warehouses') ||
                              groups.contains('managers') ||
                              groups.contains('admins')))
                        ExpansionTile(
                          leading: SizedBox(
                            height: 30,
                            width: 30,
                            child:
                                Image.asset('assets/images/warehouse_dep.png'),
                          ),
                          title: const Text('المستودعات والمحاسبة'),
                          children: [
                            if ((groups.contains('aw_items') ||
                                groups.contains('managers') ||
                                groups.contains('admins')))
                              ExpansionTile(
                                title: const Text('المواد'),
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
                            if ((groups.contains('aw_balance') ||
                                groups.contains('managers') ||
                                groups.contains('admins')))
                              ExpansionTile(
                                title: const Text('الجرد والحركة'),
                                children: [
                                  ListTile(
                                    title: const Text('جرد'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const WarehouseBalanceListPage();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    title: const Text('حركة مادة'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const ItemMovementListPage();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            if ((groups.contains('aw_transfers') ||
                                groups.contains('managers') ||
                                groups.contains('admins')))
                              ExpansionTile(
                                title: const Text('المناقلات'),
                                children: [
                                  if ((groups.contains('aw_transfers_ready') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('إدخال جاهزة'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TransfersListPage(
                                                    transfer_type: 1),
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups.contains('aw_transfers_ready') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('إخراج جاهزة'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TransfersListPage(
                                                    transfer_type: 2),
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups.contains('aw_transfers_raw') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('إدخال أولية'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TransfersListPage(
                                                    transfer_type: 3),
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups.contains('aw_transfers_raw') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('إخراج أولية'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TransfersListPage(
                                                    transfer_type: 4),
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups.contains('aw_transfers_trust') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('مناقلة بضاعة أمانة'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TransfersListPage(
                                                    transfer_type: 5),
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups
                                          .contains('aw_transfers_warehouse') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('مناقلة مستودع'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TransfersListPage(
                                                    transfer_type: 6),
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups
                                          .contains('aw_trasnfers_packaging') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('إدخال تعبئة'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TransfersListPage(
                                                    transfer_type: 7),
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups
                                          .contains('aw_trasnfers_packaging') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('إخراج تعبئة'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TransfersListPage(
                                                    transfer_type: 8),
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups.contains('aw_manufacturing') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('عمليات التصنيع'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ManufacturingListPage(),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            if ((groups.contains('aw_bills') ||
                                groups.contains('managers') ||
                                groups.contains('admins')))
                              ExpansionTile(
                                title: const Text('الفواتير'),
                                children: [
                                  if ((groups.contains('aw_bills_sales') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('فواتير المبيعات'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const BillsListPage(
                                                bill_type: 'sales',
                                                transfer_type: 102,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups.contains('aw_bills_purchases') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('فواتير المشتريات'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const BillsListPage(
                                                bill_type: 'purchase',
                                                transfer_type: 101,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            if ((groups.contains('accounting') ||
                                groups.contains('managers') ||
                                groups.contains('admins')))
                              ExpansionTile(
                                title: const Text('المحاسبة'),
                                children: [
                                  if ((groups
                                          .contains('accounting_customers') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('الحسابات'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const AccountListPage();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  if ((groups.contains('accounting_payments') ||
                                      groups.contains('managers') ||
                                      groups.contains('admins')))
                                    ListTile(
                                      title: const Text('السندات'),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const PaymentsListPage();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                          ],
                        ),
                      if (groups != null &&
                          (groups.contains('production') ||
                              groups.contains('managers') ||
                              groups.contains('admins')))
                        ExpansionTile(
                          leading: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset(
                              'assets/images/manufacturing.png',
                            ),
                          ),
                          title: const Text('الإنتاج'),
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
                                    'requiredGroup': 'raw_material_dep',
                                    'image': 'assets/images/raw_materials.png',
                                  },
                                  'Manufacturing': {
                                    'displayName': 'قسم التصنيع',
                                    'requiredGroup': 'manufacturing_dep',
                                    'image': 'assets/images/manufacturing.png',
                                  },
                                  'Lab': {
                                    'displayName': 'قسم المخبر',
                                    'requiredGroup': 'lab_dep',
                                    'image': 'assets/images/lab.png',
                                  },
                                  'EmptyPackaging': {
                                    'displayName': 'قسم الفوارغ',
                                    'requiredGroup': 'emptyPackaging_dep',
                                    'image':
                                        'assets/images/empty_packiging.png',
                                  },
                                  'Packaging': {
                                    'displayName': 'قسم التعبئة',
                                    'requiredGroup': 'packaging_dep',
                                    'image': 'assets/images/packaging.png',
                                  },
                                  'FinishedGoods': {
                                    'displayName': 'قسم الجاهزة',
                                    'requiredGroup': 'finishedGoods_dep',
                                    'image': 'assets/images/finishedGoods.png',
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
                                    final displayName =
                                        entry.value['displayName']!;
                                    final imagePath = entry.value['image']!;

                                    return ListTile(
                                      leading: Image.asset(
                                        imagePath,
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.contain,
                                      ),
                                      title: Text(displayName),
                                      onTap: () => Navigator.pop(
                                        context,
                                        entry
                                            .key, // Return the backend department code
                                      ),
                                    );
                                  }).toList();

                                  selectedDepartment = await showDialog<String>(
                                    context: context,
                                    builder: (context) => Directionality(
                                      textDirection: ui.TextDirection.rtl,
                                      child: AlertDialog(
                                        title: const Text('اختر القسم'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: departmentListTiles,
                                        ),
                                      ),
                                    ),
                                  );
                                }

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
                      ExpansionTile(
                        title: const Text('HR'),
                        leading: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/hr_dep.png'),
                        ),
                        children: [
                          if (groups != null &&
                              (groups.contains('HR_manager') ||
                                  groups.contains('managers') ||
                                  groups.contains('admins')))
                            ListTile(
                              title: const Text('الموظفون'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const EmployeesListPage();
                                    },
                                  ),
                                );
                              },
                            ),
                          if (groups != null &&
                              (groups.contains('HR_manager') ||
                                  groups.contains('managers') ||
                                  groups.contains('admins')))
                            ListTile(
                              title: const Text('جدول الدوام'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const AttendanceLogeListPage();
                                    },
                                  ),
                                );
                              },
                            ),
                          ListTile(
                            title: const Text('الإجازات'),
                            onTap: () {
                              int? selectedProgress;
                              if (groups?.contains('managers') ?? false) {
                                selectedProgress = 2;
                              } else if (groups?.contains('HR_manager') ??
                                  false) {
                                selectedProgress = 1;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WorkLeavesListPage(
                                    selectedProgress: selectedProgress,
                                  ),
                                ),
                              );
                            },
                          ),
                          if (groups != null &&
                              (groups.contains('HR_manager') ||
                                  groups.contains('managers') ||
                                  groups.contains('admins')))
                            ListTile(
                              title: const Text('الموظفين الغائبين'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const AttendanceAbsentReportPage();
                                    },
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                      if (groups != null &&
                          (groups.contains('Gardening') ||
                              groups.contains('managers') ||
                              groups.contains('admins')))
                        ExpansionTile(
                          title: const Text('الزراعة'),
                          leading: SizedBox(
                            height: 30,
                            width: 30,
                            child:
                                Image.asset('assets/images/Gardening_dep.png'),
                          ),
                          children: [
                            ListTile(
                              title: const Text('البرنامج اليومي'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const ListGardenTasksPage();
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('البرنامج العام'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const GenralListGardenTasksPage();
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: const Text('إضافة مهام'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const AddGardenActivityPage();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ListTile(
                        leading: SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset(
                            'assets/images/purchases_dep.png',
                          ),
                        ),
                        title: const Text('المشتريات'),
                        onTap: () {
                          if (user == 'محمد حسام عبيد') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const PurchasesList(status: 10);
                                },
                              ),
                            );
                          } else if (user == 'أسامة عبيد') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const PurchasesList(status: 1);
                                },
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const PurchasesList(status: 8);
                                },
                              ),
                            );
                          }
                        },
                      ),
                      ExpansionTile(
                        title: const Text('الصيانة'),
                        leading: SizedBox(
                          height: 30,
                          width: 30,
                          child:
                              Image.asset('assets/images/maintenance _dep.png'),
                        ),
                        children: [
                          ListTile(
                            title: const Text('برنامج الصيانة'),
                            onTap: () {
                              if (user == 'أسامة عبيد') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const MaintenanceListPage(
                                        status: 1,
                                      );
                                    },
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const MaintenanceListPage(
                                        status: 7,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                          ListTile(
                            title: const Text('سجل صيانة آلة'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const MachineMaintenanceLogPage();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
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
                      if (groups != null &&
                          (groups.contains('cash') ||
                              groups.contains('admins')))
                        ExpansionTile(
                          title: const Text('الصندوق'),
                          leading: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset('assets/images/cash.png'),
                          ),
                          children: [
                            ListTile(
                              leading: const FaIcon(FontAwesomeIcons.moneyBill,
                                  color: Colors.green),
                              title: const Text('Syrian Pound'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CashflowPage(
                                        currency: 'SP',
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: const FaIcon(FontAwesomeIcons.dollarSign,
                                  color: Colors.green),
                              title: const Text('United States dollar'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CashflowPage(
                                        currency: 'USA',
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
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
                      color: const Color(0xFFE1306C),
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
                  children: [
                    const VersionCheckRow(),
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
