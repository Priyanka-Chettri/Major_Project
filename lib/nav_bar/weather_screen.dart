import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/5_days_model.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;



class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}
late WeatherModel _weather;
bool _loading = false;


class _WeatherScreenState extends State<WeatherScreen> {

  void  WeatherApiCall()async{
    print('Entereing weather api call');
    var response;
    var api_url='https://api.openweathermap.org/data/2.5/weather?lat=26.369275&lon=91.679765&appid=e4b7e9a7c209d3153d1964b820ffa2f3&units=metric';
    print('here $api_url');
    response = await http.get(Uri.parse(api_url), headers: {'Accept': 'application/json'}).then((val){
      print('val $val');

      if (val.statusCode == 200) {
        var data = json.decode(val.body);
        print('dataaa $data');
        _weather = WeatherModel.fromJson(data);
      //  print("Model Name"+ _weather.weather[0].main);
       // return _weather;
        setState(() {
          _loading=false;
        });
      }
    });

     // return null;

  }

  final List<String> days = [
    'Thursday, 6 April',
    'Friday, 7 April',
    'Saturday, 8 April',
    'Sunday, 9 April',
    'Monday, 10 April'
  ];

  final List<String> conditions = [
    'Sunny',
    'Partly Cloudy',
    'Rainy',
    'Thunderstorms',
    'Cloudy'
  ];
  final List<String> temperatures = ['25°C', '27°C', '21°C', '20°C', '22°C'];

  @override
  void initState() {
   // _loading=true;

    super.initState();
    setState(() {
      _loading=true;
    });
   WeatherApiCall();
   print('out of init');


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_loading) ?
      const Center(
        child: CircularProgressIndicator(),
      ):Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff3366ff),
              Color(0xff00ccff),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 150),
             Text(
             // 'Monday, 12 April',
              'Wednesday, ${DateTime.now().toString().substring(0,10)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 18),
             Text(
              //'Sunny',
              _weather.weather![0].main??"",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Temperature',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '25°C',
                     // "${_weather.main.temp.toInt()} \u2103",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Humidity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '60%',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Wind',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '5 km/h',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
                height: 80
            ),
            const Padding(
              padding: EdgeInsets.only(left:15),
              child: Text('Weather for next five days',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 120,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(left:8),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5.0,
                      child: Container(
                        width: 180.0,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue, Colors.purple],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              days[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              temperatures[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],),
      ),
    );
  }
}

