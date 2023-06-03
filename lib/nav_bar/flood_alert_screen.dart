import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tflite_flutter/tflite_flutter.dart';


class FloodAlertScreen extends StatefulWidget {
  const FloodAlertScreen({Key? key}) : super(key: key);

  @override
  State<FloodAlertScreen> createState() => _FloodAlertScreenState();
}
bool _loading = false;


class _FloodAlertScreenState extends State<FloodAlertScreen> {
  var response_body;
  late Map<String, dynamic>value;
  var predValue=0.44;


  @override
   void initState() {
    // TODO: implement initState
    super.initState();
     predData();


  }

  Future<void> predData() async {
    final interpreter = await Interpreter.fromAsset('first_model.tflite');
    var input = [
      [96.44, 96.39, 13.06, 1.49, ]
    ];
    var output = List.filled(1, 0).reshape([1, 1]);
    interpreter.run(input, output);
    print(output[0][0]);

    setState(() {
      predValue = output[0][0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text('Flood Alert'
            )
      ),
      body: Column(
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
              'The precipitation is ${predValue.toString()}'
            )
          ),
        ],
      ),
    );
  }
}

