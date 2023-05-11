import 'package:equatable/equatable.dart';

class Forecast extends Equatable {
  final int time;
  final double temp;
  final String icon;

  const Forecast({required this.time, required this.temp, required this.icon});

  @override
  // TODO: implement props
  List<Object?> get props => [
    time,
    temp,
    icon,
  ];

}
