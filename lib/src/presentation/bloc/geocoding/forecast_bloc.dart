import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp_flutter/src/domain/usecase/get_hour_forecast.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/geocoding/forecast_event.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/geocoding/forecast_state.dart';

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  final GetHourForecast _getHourForecast;

  ForecastBloc(this._getHourForecast) : super(ForecastEmpty()) {
    on<ForecastHour>((event, emit) async {
      final num lat = event.lat;
      final num lon = event.lon;
      emit(ForecastLoading());
      final result = await _getHourForecast.call(lat, lon);
      result.fold((failure) => emit(ForecastError(failure.message)),
          (result) => emit(ForecastHasData(result)));
    });
  }
}
