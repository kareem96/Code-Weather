import 'package:dartz/dartz.dart';
import 'package:weatherapp_flutter/src/domain/entities/forecast.dart';
import 'package:weatherapp_flutter/src/domain/repositories/forecast_repository.dart';
import 'package:weatherapp_flutter/src/utils/errors/failure.dart';

class GetHourForecast{
  final ForecastRepository repository;

  GetHourForecast(this.repository);

  Future<Either<Failure, List<Forecast>>> call(num lat, num lon){
    return repository.getHourForecast(lat, lon);
  }
}