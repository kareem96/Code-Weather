import 'package:equatable/equatable.dart';

class DailyForecast extends Equatable {
  final int dailyTime;
  final num dailyMinTemp, dailyMaxTemp;
  final String dailyIcon;

  const DailyForecast({
    required this.dailyTime,
    required this.dailyMinTemp,
    required this.dailyMaxTemp,
    required this.dailyIcon
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    dailyIcon,
    dailyMaxTemp,
    dailyMinTemp,
    dailyTime,
  ];
}
