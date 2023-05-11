import 'package:dartz/dartz.dart';
import 'package:weatherapp_flutter/src/domain/entities/daily_forecast.dart';
import 'package:weatherapp_flutter/src/domain/repositories/forecast_repository.dart';
import 'package:weatherapp_flutter/src/utils/errors/failure.dart';

class GetDailyForecast{
  final ForecastRepository repository;

  GetDailyForecast(this.repository);

  Future<Either<Failure, List<DailyForecast>>> call(num lat, num lon){
    return repository.getDailyForecast(lat, lon);
  }
}