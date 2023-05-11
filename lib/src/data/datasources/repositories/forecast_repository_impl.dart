import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:weatherapp_flutter/src/data/datasources/remote/remote_data_source.dart';

import 'package:weatherapp_flutter/src/domain/entities/daily_forecast.dart';

import 'package:weatherapp_flutter/src/domain/entities/forecast.dart';
import 'package:weatherapp_flutter/src/utils/errors/exception.dart';

import 'package:weatherapp_flutter/src/utils/errors/failure.dart';

import '../../../domain/repositories/forecast_repository.dart';

class ForecastRepositoryImpl implements ForecastRepository{
  final RemoteDataSource remoteDataSource;

  const ForecastRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Either<Failure, List<DailyForecast>>> getDailyForecast(num lat, num lon) async{
    // TODO: implement getDailyForecast
    try{
      final result = await remoteDataSource.getDailyForecast(lat, lon);
      return Right(result.map((e) => e.toEntity()).toList());
    }on ServerException{
      return const Left(ServerFailure(''));
    }on SocketException{
      return const Left(ConnectionFailure('Failed connect network'));
    }
  }

  @override
  Future<Either<Failure, List<Forecast>>> getHourForecast(num lat, num lon) async {
    // TODO: implement getHourForecast
    try{
      final result = await remoteDataSource.getHourForecast(lat, lon);
      return Right(result.map((e) => e.toEntity()).toList());
    }on ServerException{
       return const Left(ServerFailure(''));
    }on SocketException{
      return const Left(ConnectionFailure('Failed connect Network'));
    }
  }

}