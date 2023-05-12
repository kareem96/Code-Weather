import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weatherapp_flutter/src/data/datasources/remote/remote_data_source.dart';

import 'package:weatherapp_flutter/src/domain/entities/weather.dart';
import 'package:weatherapp_flutter/src/utils/errors/exception.dart';

import 'package:weatherapp_flutter/src/utils/errors/failure.dart';
import '../../../domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final RemoteDataSource remoteDataSource;

  // WeatherRepositoryImpl({required this.remoteDataSource});
  WeatherRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Weather>> getCurrWeather(String cityName) async {
    // TODO: implement getCurrWeather
    try {
      final result = await remoteDataSource.getCurrWeather(cityName);
      return Right(result.toEntity());
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(
        ConnectionFailure('Failed connect to network'),
      );
    }
  }
}
