import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp_flutter/src/domain/usecase/get_daily_forecast.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/daily_forecast/daily_forecast_event.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/daily_forecast/daily_forecast_state.dart';

class DailyForecastBloc extends Bloc<DailyForecastEvent, DailyForecastState> {
  final GetDailyForecast _getDailyForecast;

  DailyForecastBloc(this._getDailyForecast) : super(DailyForecastEmpty()) {
    on<DailyForecast>((event, emit) async {
      final num lat = event.lat;
      final num lon = event.lon;
      emit(DailyForecastLoading());
      final result = await _getDailyForecast.call(lat, lon);
      result.fold((failure) => emit(DailyForecastError(failure.message)),
          (result) => emit(DailyForecastHasData(result)));
    });
  }
}
