import 'package:dartz/dartz.dart';
import 'package:weatherapp_flutter/src/domain/entities/forecast.dart';
import 'package:weatherapp_flutter/src/utils/errors/failure.dart';

import '../entities/daily_forecast.dart';

abstract class ForecastRepository{
  Future<Either<Failure, List<Forecast>>> getHourForecast(num lat, num lon);
  Future<Either<Failure, List<DailyForecast>>> getDailyForecast(num lat, num lon);
}