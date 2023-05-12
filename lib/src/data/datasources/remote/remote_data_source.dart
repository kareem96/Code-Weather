import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weatherapp_flutter/src/data/datasources/model/daily_forcast_model.dart';
import 'package:weatherapp_flutter/src/data/datasources/model/forecast_model.dart';
import 'package:weatherapp_flutter/src/data/datasources/model/weather_model.dart';
import 'package:weatherapp_flutter/src/data/datasources/remote/services/dio_client.dart';
import 'package:weatherapp_flutter/src/utils/constants/api_url.dart';
import '../../../utils/errors/exception.dart';

abstract class RemoteDataSource {
  Future<WeatherModel> getCurrWeather(String cityName);

  Future<List<ForecastModel>> getHourForecast(num lat, num lon);

  Future<List<DailyForecastModel>> getDailyForecast(num lat, num lon);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final DioClient dioClient;
  const RemoteDataSourceImpl(this.dioClient);

  /*@override
  Future<WeatherModel> getCurrWeather(String cityName) async {
    // TODO: implement getCurrWeather
    final response = await client.get(Uri.parse(ApiUrl.currentWeatherByName(cityName)));
    if(response.statusCode == 200){
      return WeatherModel.fromJson(jsonDecode(response.body));
    }else{
      throw ServerException();
    }
  }*/

  /*Future<List<DailyForecastModel>> getDailyForecast(num lat, num lon) async{
    // TODO: implement getDailyForecast
    final response = await client.get(Uri.parse(ApiUrl.weatherDailyForecast(lat, lon)));
    if(response.statusCode == 200){
      final List responseData = jsonDecode(response.body)["daily"] as List;
      return responseData.map((e) => DailyForecastModel.fromJson(e)).toList();
    }else{
      throw response.body;
    }
  }*/

  /*@override
  Future<List<ForecastModel>> getHourForecast(num lat, num lon) async{
    // TODO: implement getHourForecast
    final response = await client.get(Uri.parse(ApiUrl.weatherHourlyForecast(lat, lon)));
    if(response.statusCode == 200){
      final List responseData = jsonDecode(response.body)["hourly"] as List;
      return responseData.map((e) => ForecastModel.fromJson(e)).toList();
    }else{
      throw response.body;
    }
  }*/

  @override
  Future<WeatherModel> getCurrWeather(String cityName) async {
    // TODO: implement getCurrWeather
    final _response = await dioClient.getRequest(ApiUrl.currentWeatherByName(cityName));
    // final _result = WeatherModel.fromJson(_response.data);
    if(_response.statusCode == 200){
      // return _result;
      return WeatherModel.fromJson(_response.data);
    }else{
      throw ServerException();
    }
  }

  @override
  Future<List<DailyForecastModel>> getDailyForecast(num lat, num lon) async{
    // TODO: implement getDailyForecast
    final response = await dioClient.getRequest(ApiUrl.weatherDailyForecast(lat, lon));
    if(response.statusCode == 200){
      final List responseData = (response.data)["daily"] as List;
      return responseData.map((e) => DailyForecastModel.fromJson(e)).toList();
    }else{
      throw response.data;
    }
  }

  @override
  Future<List<ForecastModel>> getHourForecast(num lat, num lon) async{
    // TODO: implement getHourForecast
    final response = await dioClient.getRequest(ApiUrl.weatherHourlyForecast(lat, lon));
    if(response.statusCode == 200){
      final List responseData = (response.data)["hourly"] as List;
      return responseData.map((e) => ForecastModel.fromJson(e)).toList();
    }else{
      throw response.data;
    }
  }
}
