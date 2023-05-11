import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
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

void init() {
  // bloc
  locator.registerFactory(
        () => WeatherBloc(
      locator(),
      // locator(),
    ),
  );
  locator.registerFactory(
        () => ForecastBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => DailyForecastBloc(
      locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(
        () => GetCurrWeather(
      locator(),
    ),
  );
  locator.registerLazySingleton(
        () => GetHourForecast(
      locator(),
    ),
  );
  locator.registerLazySingleton(
        () => GetDailyForecast(
      locator(),
    ),
  );

  // repository
  locator.registerLazySingleton<WeatherRepository>(
        () => WeatherRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<ForecastRepository>(
        () => ForecastRepositoryImpl(
      remoteDataSource: locator(),
    ),
  );

  // data source
  locator.registerLazySingleton<RemoteDataSource>(
        () => RemoteDataSourceImpl(
      client: locator(),
    ),
  );

  // external
  locator.registerLazySingleton(() => http.Client());
}