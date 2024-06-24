import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fordi3/provider/cuaca_provide.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CuacaProvider(),
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CuacaProvider>(context, listen: false).showWeatherData());
  }

  String getWeatherIconUrl(String? iconCode, {bool isLarge = false}) {
    if (iconCode == null)
      return 'https://openweathermap.org/img/wn/unknown@2x.png';
    return isLarge
        ? 'https://openweathermap.org/img/wn/$iconCode@4x.png'
        : 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CuacaProvider>(context);

    return Scaffold(
      body: Container(
        color: Colors.blue[400],
        child: SafeArea(
          child: SingleChildScrollView(
            // Added SingleChildScrollView here
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 20, top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('d, MMMM yyyy').format(DateTime.now()),
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Select City'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: provider.indonesianCities
                                          .map((String city) {
                                        return GestureDetector(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Text(city),
                                          ),
                                          onTap: () {
                                            provider.changeCity(city);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text(
                              provider.selectedCity,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 200, // Set the height of the content
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            '°${provider.cuacaModel?.main?.temp?.round() ?? '--'}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 100,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Positioned(
                            top: 50, // Adjust this value to move the image down
                            child: Image.network(
                              getWeatherIconUrl(
                                  provider.cuacaModel?.weather?.first?.icon,
                                  isLarge: true),
                              width: 200, // Adjust width
                              height: 200, // Adjust height
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator());
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Icon(Icons.error, size: 200);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      Positioned.fill(
                        top: MediaQuery.of(context).size.height * 15 / 100,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 50),
                          Container(
                            margin: EdgeInsets.only(left: 24, right: 24),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 62, 62, 62)
                                      .withOpacity(0.1),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(0,
                                      2), // changes position // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                WeatherInfoItem(
                                  icon: Icons.air,
                                  value:
                                      '${provider.cuacaModel?.wind?.speed ?? '--'}m/s',
                                  label: 'Wind',
                                ),
                                WeatherInfoItem(
                                  icon: Icons.water_drop,
                                  value:
                                      '${provider.cuacaModel?.main?.humidity ?? '--'}%',
                                  label: 'Humidity',
                                ),
                                WeatherInfoItem(
                                  icon: Icons.remove_red_eye,
                                  value:
                                      '${(provider.cuacaModel?.visibility ?? 0) / 1000}km',
                                  label: 'Visibility',
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Today',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  if (provider.hourlyForecast.isEmpty)
                                    Center(
                                      child: Text(
                                        'No hourly forecast available',
                                        style:
                                            TextStyle(color: Colors.blue[800]),
                                      ),
                                    )
                                  else
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: provider.hourlyForecast
                                            .map((hourly) => HourlyForecastItem(
                                                  time: DateFormat('HH:00')
                                                      .format(hourly.dt),
                                                  temp:
                                                      '${hourly.temp.round()}°',
                                                  icon: hourly.weather.icon,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WeatherInfoItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const WeatherInfoItem(
      {Key? key, required this.icon, required this.value, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final String temp;
  final String? icon;

  const HourlyForecastItem({
    Key? key,
    required this.time,
    required this.temp,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 62, 62, 62).withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            temp,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.network(
            (context.findAncestorStateOfType<_HomeScreenState>()
                    as _HomeScreenState)
                .getWeatherIconUrl(icon),
            width: 70,
            height: 50,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Icon(Icons.error);
            },
          ),
          Text(time, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
