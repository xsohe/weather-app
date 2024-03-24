import 'package:dio/dio.dart';
import 'package:fordi3/model/cuaca_model.dart';

class CuacaService {
  final dio = Dio();

  Future<CuacaModel> getCurrentWeather(String cityName) async {
    final response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=ceffd3e61c0ca15426918c16c05c4462');
    print(response.requestOptions.path);
    return CuacaModel.fromJson(response.data);
  }
}
