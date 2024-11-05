import 'dart:convert';

import 'package:http/http.dart' as http;

Future<double?> fetchTemperature(String city, String apiKey) async {
  final url = Uri.parse(
      'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Access the temperature in Celsius
      return data['current']['temp_c']?.toDouble();
    } else {
      print('Failed to load weather data');
    }
  } catch (e) {
    print('Error: $e');
  }
  return null;
}
