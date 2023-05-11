import 'package:dartz/dartz.dart';
import 'package:weatherapp_flutter/src/domain/entities/weather.dart';

import '../../utils/errors/failure.dart';

abstract class WeatherRepository{
  Future<Either<Failure, Weather>> getCurrWeather(String cityName);
}