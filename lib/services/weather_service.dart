import 'dart:convert';
import 'package:http/http.dart' as http;
import 'error_handler.dart';

class WeatherService {
  static const apiKey = "ca4fb7bd85c4330ec05bbbb7b490d732";
  static const Duration timeoutDuration = Duration(seconds: 10);

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
        ),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw response; // Throw response to be handled by ErrorHandler
      }
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<Map<String, dynamic>> getForecast(String city) async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric",
        ),
      ).timeout(timeoutDuration);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw response;
      }
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}

