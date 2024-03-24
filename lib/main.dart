import 'package:flutter/material.dart';
import 'package:fordi3/provider/cuaca_provide.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CuacaProvider(),
      child: MaterialApp(
        title: 'Aplikasi Cuaca',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CuacaProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Aplikasi Cuaca"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: provider.cityNameText,
              decoration: InputDecoration(
                hintText: "Masukan Nama Kota",
                labelText: "Nama Kota",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                provider.showWeatherData();
              },
              child: Text("Tampilkan Data Cuaca"),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                provider.cuacaModel?.name ?? "Waiting Data",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(provider.cuacaModel?.weather?.first?.main ?? "Waiting Data"),
            SizedBox(
              width: 200,
              height: 200,
              child: Image.network(
                "https://openweathermap.org/img/w/${provider.cuacaModel?.weather?.first?.icon}.png",
                fit: BoxFit.contain,
              ),
            ),
            Text("Temp : ${provider.cuacaModel?.main?.temp} Celcius")
          ],
        ),
      ),
    );
  }
}
