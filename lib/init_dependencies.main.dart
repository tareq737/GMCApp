part of 'init_dependencies.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => ApiClient(dio: getIt()));
  getIt.registerSingleton(await SharedPreferences.getInstance());
  getIt.registerLazySingleton(() => AuthInteractor(
        currentUser: getIt(),
        appUserCubit: getIt(),
      ));
  getIt.registerLazySingleton(() => AppUserCubit());
  _initAuth();
  _initSales();
  _initProd();
}

void _initProd() {
  //RemoteDataSource
  getIt
    ..registerFactory<ProdRemoteDataSource>(
      () => ProdRemoteDataSourceImp(
        apiClient: getIt(),
      ),
    )
    //Repository
    ..registerFactory<ProdRepository>(
      () => ProdRepositoryImpl(
        prodRemoteDataSource: getIt(),
      ),
    )
    //UseCases
    ..registerFactory(
      () => AddProdPlanning(
        prodRepository: getIt(),
        authInteractor: getIt(),
      ),
    )
    ..registerFactory(
      () => DeleteProdPlan(
        prodRepository: getIt(),
        authInteractor: getIt(),
      ),
    )
    ..registerFactory(
      () => SearchProdPlan(
        authInteractor: getIt(),
        prodRepository: getIt(),
      ),
    )
    ..registerFactory(
      () => UpdateProdPlan(
        prodRepository: getIt(),
        authInteractor: getIt(),
      ),
    )
    ..registerFactory(
      () => GetAllProdPlan(
        prodRepository: getIt(),
        authInteractor: getIt(),
      ),
    )
    ..registerFactory(
      () => GetProdPlan(
        authInteractor: getIt(),
        prodRepository: getIt(),
      ),
    )
    ..registerFactory(
      () => DepCheckProdPlan(
        authInteractor: getIt(),
        prodRepository: getIt(),
      ),
    )
    ..registerFactory(
      () => TransferProdPlanToProd(
        authInteractor: getIt(),
        prodRepository: getIt(),
      ),
    )
    //Bloc
    ..registerFactory(
      () => ProdPlanBloc(
        addProdPlanningUnit: getIt(),
        deleteProdPlan: getIt(),
        getAllProdPlan: getIt(),
        getProdPlan: getIt(),
        searchProdPlan: getIt(),
        updateProdPlan: getIt(),
        checkProdPlan: getIt(),
        transferProdPlanToProd: getIt(),
      ),
    );
}

void _initSales() {
  //RemoteDataSource
  getIt
    ..registerFactory<SalesRemoteDataSource>(
      () => SalesRemoteDataSourceImpl(
        apiClient: getIt(),
      ),
    )
    //Repository
    ..registerFactory<SalesRepository>(
      () => SalesRepositoryImpl(
        salesRemoteDataSource: getIt(),
      ),
    )
    //UseCases
    ..registerFactory(
      () => AddCustomer(
        authInteractor: getIt(),
        salesRepository: getIt(),
      ),
    )
    ..registerFactory(
      () => DeleteCustomer(
        salesRepository: getIt(),
        authInteractor: getIt(),
      ),
    )
    ..registerFactory(
      () => SearchCustomer(
        authInteractor: getIt(),
        salesRepository: getIt(),
      ),
    )
    ..registerFactory(
      () => UpdateCustomer(
        salesRepository: getIt(),
        authInteractor: getIt(),
      ),
    )
    ..registerFactory(
      () => GetCustomer(
        salesRepository: getIt(),
        authInteractor: getIt(),
      ),
    )
    ..registerFactory(() => GetAllCustomersPaginated(
          authInteractor: getIt(),
          salesRepository: getIt(),
        ))
    ..registerFactory(() => ExportCustomers(
          authInteractor: getIt(),
          salesRepository: getIt(),
        ))
    //Bloc
    ..registerFactory(
      () => SalesBloc(
        addCustomer: getIt(),
        deleteCustomer: getIt(),
        updateCustomer: getIt(),
        getCustomer: getIt(),
        searchCustomer: getIt(),
        getAllCustomersPaginated: getIt(),
        exportCustomers: getIt(),
      ),
    );
}

void _initAuth() {
  // RemoteDataSource
  getIt
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImp(
        getIt(),
      ),
    )
    // LocalDataSource
    ..registerFactory<LocalDataSource>(
      () => SharedPrefsDataSourceImpl(
        getIt(),
      ),
    )
    //Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
      ),
    )
    // UseCases
    ..registerFactory(
      () => UserSignIn(
        authRepository: getIt(),
      ),
    )
    ..registerFactory(
      () => CheckUserSessionStatus(
        authRepository: getIt(),
      ),
    )
    ..registerFactory(
      () => UserLogOut(
        authRepository: getIt(),
      ),
    )
    ..registerFactory(
      () => OnStartCheckLoginStatus(
        authRepository: getIt(),
      ),
    )

    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        checkUserSessionStatus: getIt(),
        userSignIn: getIt(),
        appUserCubit: getIt(),
        userLogOut: getIt(),
        onStartCheckLoginStatus: getIt(),
      ),
    );
}
