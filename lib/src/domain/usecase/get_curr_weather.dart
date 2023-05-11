import 'package:dartz/dartz.dart';
import 'package:weatherapp_flutter/src/domain/entities/weather.dart';
import 'package:weatherapp_flutter/src/domain/repositories/weather_repository.dart';
import 'package:weatherapp_flutter/src/utils/errors/failure.dart';

class GetCurrWeather{
  final WeatherRepository repository;

  GetCurrWeather(this.repository);
  Future<Either<Failure, Weather>> call (String cityName){
    return repository.getCurrWeather(cityName);
  }
}