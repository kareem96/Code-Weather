import 'package:equatable/equatable.dart';
import '../../../domain/entities/daily_forecast.dart';

class DailyForecastModel extends Equatable {
  final int dailyTime;
  final num dailyMinTemp, dailyMaxTemp;
  final String dailyIcon;

  const DailyForecastModel(
      {required this.dailyTime,
      required this.dailyMinTemp,
      required this.dailyMaxTemp,
      required this.dailyIcon});

  factory DailyForecastModel.fromJson(Map<String, dynamic> json) =>
      DailyForecastModel(
        dailyTime: json["dt"],
        dailyMinTemp: json['feels_like']['day'],
        dailyMaxTemp: json['feels_like']['night'],
        dailyIcon: json["weather"][0]["icon"],
      );

  DailyForecast toEntity() => DailyForecast(
      dailyTime: dailyTime,
      dailyMinTemp: dailyMinTemp,
      dailyMaxTemp: dailyMaxTemp,
      dailyIcon: dailyIcon);

  @override
  // TODO: implement props
  List<Object?> get props => [dailyTime, dailyMinTemp, dailyMaxTemp, dailyIcon];
}
