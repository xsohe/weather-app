import 'package:dio/dio.dart';
import 'package:fordi3/model/cuaca_model.dart';

class CuacaService {
  final dio = Dio();

  Future<CuacaModel> getCurrentWeather(String cityName) async {
    final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName,ID&appid=ceffd3e61c0ca15426918c16c05c4462&units=metric');
    return CuacaModel.fromJson(response.data);
  }

  Future<List<HourlyForecast>> getHourlyForecast(String cityName) async {
    final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,ID&appid=ceffd3e61c0ca15426918c16c05c4462&units=metric');
    List<dynamic> list = response.data['list'];
    return list.take(24).map((item) => HourlyForecast.fromJson(item)).toList();
  }
}
