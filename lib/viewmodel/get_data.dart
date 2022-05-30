import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_forecast/model/hourly_data_class.dart';
import 'package:weather_forecast/viewmodel/my_location.dart';

import 'useful_data.dart';

class GetData {
  var latitude = MyLocation.latitude;
  var longitude = MyLocation.longitude;
  String city = MyLocation.cityName;

  Future<void> updateWeatherData() async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/onecall?lat=$latitude&lon=$longitude&units=metric&appid=86fb5ee6347a1dd0d1054468963d7a8c&exclude=daily,minutely,alerts'));

      if (response.statusCode == 200) {
        List<HourlyData> hourlyData = hourlyDataFromJson(response.body);
        UsefulData.current = currentDataFromJson(response.body);
        UsefulData.second = hourlyData[7];
        UsefulData.third = hourlyData[15];

        //trim hourly data to only the necessary ones.
        return;
      } else
        return;
    } catch (e) {
      return;
    }
  }

  Future<void> getCityName() async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=86fb5ee6347a1dd0d1054468963d7a8c'));

      Map data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        MyLocation.cityName = data['name'];
        //trim hourly data to only the necessary ones.
        return;
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  Future<bool> checkCity(String city) async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=86fb5ee6347a1dd0d1054468963d7a8c'));

      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        MyLocation.cityName = data['name'];
        MyLocation.latitude = data['coord']['lat'].toString();
        MyLocation.longitude = data['coord']['lon'].toString();
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }
}
