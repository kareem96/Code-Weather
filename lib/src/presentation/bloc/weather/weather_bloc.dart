import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp_flutter/src/domain/usecase/get_curr_weather.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/weather/weather_event.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/weather/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrWeather _getCurrWeather;

  WeatherBloc(this._getCurrWeather) : super(WeatherEmpty()) {
    on<OnCityChanged>((event, emit) async {
      final cityName = event.cityName;
      emit(WeatherLoading());
      final result = await _getCurrWeather.call(cityName);
      result.fold((failure) => emit(WeatherError(failure.message)),
          (data) => emit(WeatherHasData(data)));
    });
  }
}
