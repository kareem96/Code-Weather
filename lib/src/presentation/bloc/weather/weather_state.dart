import 'package:equatable/equatable.dart';
import 'package:weatherapp_flutter/src/domain/entities/weather.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WeatherEmpty extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class WeatherHasData extends WeatherState {
  final Weather result;

  const WeatherHasData(this.result);

  @override
  // TODO: implement props
  List<Object?> get props => [result];
}
