import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:weatherapp_flutter/src/data/datasources/remote/services/dio_client.dart';
import '../data/datasources/remote/remote_data_source.dart';
import '../data/datasources/repositories/forecast_repository_impl.dart';
import '../data/datasources/repositories/weather_repository_impl.dart';
import '../domain/repositories/forecast_repository.dart';
import '../domain/repositories/weather_repository.dart';
import '../domain/usecase/get_curr_weather.dart';
import '../domain/usecase/get_daily_forecast.dart';
import '../domain/usecase/get_hour_forecast.dart';
import '../presentation/bloc/daily_forecast/daily_forecast_bloc.dart';
import '../presentation/bloc/geocoding/forecast_bloc.dart';
import '../presentation/bloc/weather/weather_bloc.dart';

final locator = GetIt.instance;
GetIt sl = GetIt.instance;

Future<void> serviceLocator({bool isUnitTest = false}) async {
  if (isUnitTest) {
    WidgetsFlutterBinding.ensureInitialized();
    sl.reset();
    sl.registerSingleton<DioClient>(DioClient(isUnitTest: true));
    dataSource();
    repositories();
    useCase();
    bloc();
  }else{
    sl.registerSingleton<DioClient>(DioClient());
    dataSource();
    repositories();
    useCase();
    bloc();
  }
}

void bloc() {
  sl.registerFactory(() => DailyForecastBloc(sl()));
  sl.registerFactory(() => ForecastBloc(sl()));
  sl.registerFactory(() => WeatherBloc(sl()));
}

void useCase() {
  sl.registerLazySingleton(() => GetCurrWeather(sl()));
  sl.registerLazySingleton(() => GetDailyForecast(sl()));
  sl.registerLazySingleton(() => GetHourForecast(sl()));
}

void repositories() {
  sl.registerLazySingleton<ForecastRepository>(() => ForecastRepositoryImpl(sl()));
  sl.registerLazySingleton<WeatherRepository>(() => WeatherRepositoryImpl(sl()));
}

void dataSource() {
  sl.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(sl()));
}
