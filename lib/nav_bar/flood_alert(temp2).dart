import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class FloodAlertScreen extends StatefulWidget {
  const FloodAlertScreen({Key? key}) : super(key: key);

  @override
  State<FloodAlertScreen> createState() => _FloodAlertScreenState();
}
bool _loading = false;


class _FloodAlertScreenState extends State<FloodAlertScreen> {
  var response_body;
  late Map<String, dynamic>value;

  void getData()  async {
    print("Entering the get Data function");
    final url =Uri.parse('http://10.0.2.2:5000/predict');
    print("Url is $url");
    var input_model_data={
      'TEMPERATURE': 13.06,
      'HUMIDITY': 96.44,
      'WINDSPEED': 1.49,
      'WINDDIRECTION':228.62,
      'PRESSURE':96.39
    };
    String json_body=json.encode(input_model_data);
    http.Response response = await http.post(url,body:json_body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }).then((val){
      // if (val.statusCode == 200) {
      value = json.decode(val.body);
      setState(() {
        _loading=false;
      });
      // }
      return val;
    });
    // response_body=response.body;
    // val = json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _loading=true;
    });
    getData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Flood Alert'
          )
      ),
      body: (_loading) ?
      const Center(
        child: CircularProgressIndicator(),
      ):Column(
        children: [
          SizedBox(
              height:30
          ),
          Container(
            //color: Colors.blue,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)),
              width: 415,
              height: 200,
              child: Text(
                  'The precipitation is ${value["Prediction"].toString()}'
              )
          ),
        ],
      ),
    );
  }
}

