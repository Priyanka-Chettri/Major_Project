import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloodAlertScreen extends StatefulWidget {
  const FloodAlertScreen({Key? key}) : super(key: key);

  @override
  State<FloodAlertScreen> createState() => _FloodAlertScreenState();
}

class _FloodAlertScreenState extends State<FloodAlertScreen> {

  // final databaseRef = FirebaseDatabase.instance.ref();
  dynamic snapshot1;
  dynamic snapshot2;
  bool loading=false;
  //final Future<FirebaseApp> _future = Firebase.initializeApp();

  void printFirebase()async{

    final ref = await FirebaseDatabase.instance.ref();
    snapshot1 = await ref.child('water_level').get();
    snapshot2=await ref.child('water_drop_count').get();
    if (snapshot1.exists && snapshot2.exists) {
      print(snapshot1.value);
      setState(() {
        loading=false;
      });
    } else {
      print('No data available.');
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading=true;
    });
    printFirebase();
    //print("Now value: $snapshot1.value");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Flood Alert'
          )
      ),
      body: Center(
        child:(loading)?CircularProgressIndicator(): Column(
          children: [
            SizedBox(
                height: 80
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.5)),
                ),
              ),
              child: Text(
                'The water level value is:  ${snapshot1.value.toString()}cm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Text(
                'The water drop count in the area value is : ${snapshot2.value.toString()}mm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 50,),
            (snapshot1.value<70)?Center(
              child: Text('Out of Danger',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            )

                : Center(
              child: Text('In danger zone',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            ),
            /*SizedBox(
              height: 150,
            ),
            (loading)? CircularProgressIndicator():Text(
             'The water value is:  ${snapshot1.value.toString()}',
            ),
            const SizedBox(
              height:20,
            ),
            (loading)?CircularProgressIndicator():Text(
                'The water drop count in the area value is : ${snapshot2.value.toString()}'
            )*/
          ],
        ),
      ),

    );
  }
}

