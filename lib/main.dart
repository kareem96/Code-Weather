import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/daily_forecast/daily_forecast_bloc.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/weather/weather_bloc.dart';
import 'package:weatherapp_flutter/src/presentation/views/home.dart';
import 'package:weatherapp_flutter/src/utils/theme.dart';
import 'src/presentation/bloc/geocoding/forecast_bloc.dart';
import 'src/utils/routes.dart' as route;
import 'src/di/injection.dart' as injector;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  injector.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => injector.locator<WeatherBloc>()),
          BlocProvider(create: (_) => injector.locator<ForecastBloc>()),
          BlocProvider(create: (_) => injector.locator<DailyForecastBloc>()),
        ],
        child: MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: themeData,
          home: const Home(),
          onGenerateRoute: route.controller,
          initialRoute: route.home,
        ));
  }
}
