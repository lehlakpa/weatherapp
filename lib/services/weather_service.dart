import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const apiKey = "ca4fb7bd85c4330ec05bbbb7b490d732";

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    final response = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
      ),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getForecast(String city) async {
    final response = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric",
      ),
    );

    return jsonDecode(response.body);
  }
}
