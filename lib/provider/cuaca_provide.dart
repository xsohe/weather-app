import 'package:fordi3/model/cuaca_model.dart';
import 'package:fordi3/service/cuaca_service.dart';
import 'package:flutter/cupertino.dart';

class CuacaProvider extends ChangeNotifier {
  TextEditingController cityNameText = TextEditingController();
  CuacaService cuacaService = CuacaService();
  CuacaModel cuacaModel = CuacaModel();

  showWeatherData() async {
    cuacaModel = await cuacaService.getCurrentWeather(cityNameText.text);
    notifyListeners();
  }
}
