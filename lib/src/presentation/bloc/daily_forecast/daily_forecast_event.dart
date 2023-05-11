import 'package:equatable/equatable.dart';

abstract class DailyForecastEvent extends Equatable {
  const DailyForecastEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DailyForecast extends DailyForecastEvent {
  final num lat, lon;

  const DailyForecast(this.lat, this.lon);

  @override
  // TODO: implement props
  List<Object?> get props => [lat, lon];
}
