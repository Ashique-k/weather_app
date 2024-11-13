import 'package:flutter/material.dart';
import 'home_page.dart'; // Import the HOME_PAGE file here

class MainWeatherPage extends StatelessWidget {
  final List<String> cityNames;

  const MainWeatherPage({super.key, required this.cityNames});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cityNames.length,
      itemBuilder: (context, index) {
        return HOME_PAGE(cityName: cityNames[index]);
      },
    );
  }
}
