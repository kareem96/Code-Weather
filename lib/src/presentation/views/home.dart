import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/daily_forecast/daily_forecast_bloc.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/daily_forecast/daily_forecast_event.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/geocoding/forecast_bloc.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/geocoding/forecast_event.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/weather/weather_bloc.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/weather/weather_event.dart';
import 'package:weatherapp_flutter/src/presentation/bloc/weather/weather_state.dart';
import 'package:weatherapp_flutter/src/presentation/widgets/custom_snackbar.dart';
import 'package:weatherapp_flutter/src/presentation/widgets/search_field.dart';

import '../../utils/constants/api_url.dart';
import '../../utils/helpers/capitalizer.dart';
import '../bloc/daily_forecast/daily_forecast_state.dart';
import '../bloc/geocoding/forecast_state.dart';
import '../widgets/data_loader.dart';
import '../widgets/default_result.dart';
import '../widgets/error_response.dart';
import '../widgets/weather_attribute.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isSearchIcon = false;

  void _toggleSearch() {
    setState(() {
      _isSearchIcon = !_isSearchIcon;
    });
  }

  TextEditingController searchController = TextEditingController();
  ConnectivityResult _connectivityStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Could not check connectivity status => $e');
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectivityStatus(result);
  }

  Future<void> _updateConnectivityStatus(ConnectivityResult result) async {
    setState(() {
      _connectivityStatus = result;
      _connectivityStatus == ConnectivityResult.wifi ||
              _connectivityStatus == ConnectivityResult.mobile
          ? CustomSnackBar.buildSnackBar(
              "Internet is connected",
              Colors.green,
              context,
            )
          : CustomSnackBar.buildSnackBar(
              "Internet is not connected", Colors.red, context);
    });
  }

  List? locationData = [];

  String? daysDate;

  Future<String> todaysDate() async {
    var today = DateTime.now();
    var dateFormat = DateFormat("yMMMEd");
    String currentDate = dateFormat.format(today);
    setState(() {
      daysDate = currentDate.toString();
    });
    log(daysDate.toString());
    return daysDate!;
  }

  Future<List?> getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.unableToDetermine) {
        return Future.error('Unable to determine location');
      } else if (permission == LocationPermission.deniedForever) {
        return Future.error('Unable to access location');
      } else {
        throw Exception("Unknown Error");
      }
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final coordinates = Coordinates(position.latitude, position.longitude);
      var address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = address.first;
      log(first.locality.toString());
      setState(() {
        locationData = [
          first.locality.toString(),
          first.countryName.toString(),
        ];
      });
      log(locationData![0].toString());
      context
          .read<WeatherBloc>()
          .add(OnCityChanged(locationData![0].toString()));
      return locationData;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    searchController;
    initConnectivity();
    getLocation();
    todaysDate();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectivityStatus);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _connectivitySubscription.cancel();
    super.dispose();
  }

  final form = FormGroup({
    'searchLocation':
        FormControl<String>(value: '', validators: [Validators.required])
  });

  Widget searchField() {
    return SearchField(
        formGroup: form,
        onFocusChange: (focus) => _toggleSearch(),
        controller: searchController,
        onSubmitted: () {
          context.read<WeatherBloc>().add(OnCityChanged(searchController.text));
        },
        suffixIcon: (_isSearchIcon
            ? GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    "Cancel",
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              )
            : SvgPicture.asset(
                "assets/icons/search.svg",
                color: Colors.grey,
              )));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
                if (state is WeatherLoading) {
                  return const DataLoader(height: 0.4);
                } else if (state is WeatherHasData) {
                  late num _lat, _lon;
                  _lat = state.result.lat;
                  _lon = state.result.lon;
                  context.read<ForecastBloc>().add(ForecastHour(_lat, _lon));
                  context
                      .read<DailyForecastBloc>()
                      .add(DailyForecast(_lat, _lon));
                  final weather = state.result;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(18, 36, 18, 12),
                    child: Column(
                      children: [
                        searchField(),
                        const SizedBox(
                          height: 42,
                        ),
                        Text(
                          weather.cityName,
                          style: textTheme.headline6,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          "${weather.temperature.round()}\u{00B0}c",
                          style:
                              Theme.of(context).textTheme.headline1?.copyWith(
                                    fontSize: 68,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          capitalizeLetter(state.result.description),
                          style: textTheme.subtitle1?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is WeatherError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 26, horizontal: 18),
                    child: Column(
                      children: [
                        searchField(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: const Center(
                            child: DefaultResult(
                              icon: "assets/images/location.png",
                              response: "Not Available",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  const ErrorResponse(
                      height: 0.4, title: "Preparing Location Data...");
                }
                return const SizedBox();
              }),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "24 Hour Forecast",
                      style: textTheme.subtitle2?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              BlocBuilder<ForecastBloc, ForecastState>(
                  builder: (context, state) => state is ForecastLoading
                      ? const DataLoader(height: 0.2)
                      : state is ForecastHasData
                      ? SizedBox(
                    height: 88,
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 22),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18),
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.result.length,
                      itemBuilder: (context, index) {
                        final hour = state.result[index];
                        return Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('ha').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  hour.time * 1000,
                                  isUtc: false,
                                ),
                              ),
                              style: textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            CachedNetworkImage(
                              imageUrl: ApiUrl.weatherIcon(
                                hour.icon,
                              ),
                              placeholder: (context, url) =>
                              const Center(
                                child: CupertinoActivityIndicator(),
                              ),
                              filterQuality: FilterQuality.high,
                              fit: BoxFit.cover,
                              width: 36,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${state.result[index].temp.round().toString()}\u{00B0}c",
                              style: textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                      : state is ForecastError
                      ? const ErrorResponse(
                      height: 0.2,
                      title: "24 Hour Forecast is Unavailable!")
                      : const ErrorResponse(
                      height: 0.2,
                      title: "Preparing 24 Hour Forecast...")),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Text(
                      "7 Days Forecast",
                      style: textTheme.subtitle2?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  BlocBuilder<DailyForecastBloc, DailyForecastState>(
                      builder: (context, state) => state
                      is DailyForecastLoading
                          ? const DataLoader(height: 0.2)
                          : state is DailyForecastHasData
                          ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18),
                        child: Column(
                          children: [
                            for (var day in state.result)
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DateFormat('MMMM d,EEEE').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                day.dailyTime
                                                    .toInt() *
                                                    1000,
                                                isUtc:
                                                false)) ==
                                            DateFormat(
                                                'MMMM d,EEEE')
                                                .format(DateTime
                                                .now())
                                            ? "Today"
                                            : DateFormat.EEEE()
                                            .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              day.dailyTime
                                                  .toInt() *
                                                  1000,
                                              isUtc: false),
                                        ),
                                        style: textTheme.bodyText1
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(
                                          top: 6,
                                        ),
                                        child: Image.network(
                                          ApiUrl.weatherIcon(
                                            day.dailyIcon,
                                          ),
                                          width: 36,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "${day.dailyMinTemp.round().toString()}\u{00B0}c to ${day.dailyMaxTemp.round().toString()}\u{00B0}c",
                                        textAlign: TextAlign.end,
                                        style: textTheme.bodyText1
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                          : state is DailyForecastError
                          ? const ErrorResponse(
                          height: 0.2,
                          title: "7 Days Forecast is Unavailable!")
                          : const ErrorResponse(
                          height: 0.2,
                          title: "Preparing 7 Days Forecast...")),
                ],
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: BlocBuilder<WeatherBloc, WeatherState>(
                    builder: (context, state) => state is WeatherLoading
                        ? const DataLoader(height: 0.4)
                        : state is WeatherHasData
                        ? Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Attribute(
                              title: "WIND",
                              value:
                              "${state.result.windSpeed.toString()} MPH",
                            ),
                            Attribute(
                              title: "HUMIDITY",
                              value:
                              "${state.result.humidity.toString()}%",
                            ),
                            Attribute(
                              title: "PRESSURE",
                              value:
                              "${state.result.pressure.toString()} inHg",
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Attribute(
                              title: "SUNRISE",
                              value: DateFormat('h:mma').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  state.result.sunrise.toInt() * 1000,
                                  isUtc: false,
                                ),
                              ),
                            ),
                            Attribute(
                              title: "SUNSET",
                              value: DateFormat('h:mma').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  state.result.sunset.toInt() * 1000,
                                  isUtc: false,
                                ),
                              ),
                            ),
                            Attribute(
                              title: "FEELS LIKE",
                              value:
                              "${state.result.feelsLike.round().toString()}\u{00B0}c",
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                      ],
                    )
                        : state is ForecastError
                        ? const ErrorResponse(
                        height: 0.4,
                        title: "Attributes are Unavailable!")
                        : const ErrorResponse(
                        height: 0.4,
                        title: "Preparing Attributes...")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
