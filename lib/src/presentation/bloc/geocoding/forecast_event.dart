import 'package:equatable/equatable.dart';

abstract class ForecastEvent extends Equatable {
  const ForecastEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ForecastHour extends ForecastEvent {
  final num lat, lon;

  const ForecastHour(this.lat, this.lon);

  @override
  // TODO: implement props
  List<Object?> get props => [lat, lon];
}
