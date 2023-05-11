import 'package:equatable/equatable.dart';
import 'package:weatherapp_flutter/src/domain/entities/daily_forecast.dart';

abstract class DailyForecastState extends Equatable {
  const DailyForecastState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DailyForecastEmpty extends DailyForecastState {}

class DailyForecastLoading extends DailyForecastState {}

class DailyForecastError extends DailyForecastState {
  final String message;

  const DailyForecastError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class DailyForecastHasData extends DailyForecastState {
  final List<DailyForecast> result;

  const DailyForecastHasData(this.result);

  @override
  // TODO: implement props
  List<Object?> get props => [result];
}
