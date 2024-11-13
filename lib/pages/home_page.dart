
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:weather_application/Const.dart';

class HOME_PAGE extends StatefulWidget {
  final String cityName;

  const HOME_PAGE({super.key, required this.cityName});

  @override
  State<HOME_PAGE> createState() => _HOME_PAGEState();
}

class _HOME_PAGEState extends State<HOME_PAGE> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    _fetchWeather(widget.cityName);
  }

  void _fetchWeather(String cityName) async {
    try {
      Weather w = await _wf.currentWeatherByCityName(cityName);
      setState(() {
        _weather = w;
      });
    } catch (e) {
      // Error handling if city not found or API request fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Could not fetch weather for $cityName')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather in ${widget.cityName}'),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _locationHeader(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.08),
          _dateTimeInfo(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
          _weatherIcon(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          _currentTemp(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
          extraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat('h:mm a').format(now),
          style: TextStyle(fontSize: 35),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('EEEE').format(now),
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              "  ${DateFormat("dd/MM/yyyy").format(now)}",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://openweathermap.org/img/wn/${_weather?.weatherIcon}@2x.png"),
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: TextStyle(
          color: Colors.black, fontSize: 80, fontWeight: FontWeight.w400),
    );
  }

  Widget extraInfo() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      width: MediaQuery.sizeOf(context).width * 0.80,
      decoration: BoxDecoration(
        color: Colors.indigo.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Max ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              Text(
                "Min ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Wind ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              Text(
                "Humidity ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
