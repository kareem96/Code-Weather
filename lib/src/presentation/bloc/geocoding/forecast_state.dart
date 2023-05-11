import 'package:equatable/equatable.dart';

import '../../../domain/entities/forecast.dart';

abstract class ForecastState extends Equatable {
  const ForecastState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ForecastEmpty extends ForecastState {}

class ForecastLoading extends ForecastState {}

class ForecastError extends ForecastState {
  final String message;

  const ForecastError(this.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class ForecastHasData extends ForecastState {
  final List<Forecast> result;

  const ForecastHasData(this.result);

  @override
  // TODO: implement props
  List<Object?> get props => [result];
}
