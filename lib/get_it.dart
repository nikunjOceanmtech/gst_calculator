import 'package:get_it/get_it.dart';
import 'package:gst_calculator/features/gst_calculator/presentation/cubit/gst_calculator_cubit.dart';

final getItInstance = GetIt.I;

Future init() async {
  // getItInstance.registerLazySingleton<Client>(() => Client());
  // getItInstance.registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  // Analytics Property
  // getItInstance.registerLazySingleton<AnalyticsService>(() => AnalyticsService());

  //Data source Dependency
  // getItInstance.registerLazySingleton<SettingDataSource>(() => SettingDataSourceImpl(client: getItInstance()));

  //Data Repository Dependency
  // getItInstance
  // .registerLazySingleton<SettingRemoteRepository>(() => SettingRepositoryImpl(settingDataSource: getItInstance()));

  //Usecase Dependency
  // getItInstance.registerLazySingleton<GetPolicyData>(() => GetPolicyData(settingRemoteRepository: getItInstance()));

  //Bloc Dependency
  // getItInstance.registerFactory(() => SettingPageBloc(loadingCubit: getItInstance()));

  //Cubit Dependency
  getItInstance.registerLazySingleton<GstCalculatorCubit>(() => GstCalculatorCubit());

  //Theme Dependency
  // getItInstance.registerLazySingleton<GetPreferredTheme>(() => GetPreferredTheme(appRepository: getItInstance()));
}
