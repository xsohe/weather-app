import 'package:fordi3/model/cuaca_model.dart';
import 'package:fordi3/service/cuaca_service.dart';
import 'package:flutter/cupertino.dart';

class CuacaProvider extends ChangeNotifier {
  TextEditingController cityNameText = TextEditingController();
  CuacaService cuacaService = CuacaService();
  CuacaModel? cuacaModel;
  List<HourlyForecast> hourlyForecast = [];

  List<String> indonesianCities = [
    'Jakarta',
    'Pamulang',
    'Depok',
    'Bekasi',
    'Surabaya',
    'Medan',
    'Bandung',
    'Semarang',
  ];

  String selectedCity = 'Jakarta';

  void changeCity(String newCity) {
    selectedCity = newCity;
    showWeatherData();
  }

  Future<void> showWeatherData() async {
    try {
      cuacaModel = await cuacaService.getCurrentWeather(selectedCity);
      hourlyForecast = await cuacaService.getHourlyForecast(selectedCity);
      notifyListeners();
    } catch (e) {
      print('Error fetching weather data: $e');
    }
  }
}
