import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {

  dynamic snapshot1;
  dynamic snapshot2;
  bool loading=false;


  static const CameraPosition _kGooglePlex=CameraPosition(
      target: LatLng(26.1295, 91.6204752),
      zoom: 14,
  );

  void printFirebase()async{

    final ref = await FirebaseDatabase.instance.ref();
    snapshot1 = await ref.child('water_level').get();
    if (snapshot1.exists) {
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
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Maps',
        ),
      ),
      body:
     loading?CircularProgressIndicator(): GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        initialCameraPosition: _kGooglePlex,
        circles: {
          snapshot1.value>40? Circle(
            circleId: CircleId('circle'),
            center: LatLng(26.1295, 91.6204752),
            radius: 140,
            fillColor: Colors.redAccent.shade100.withOpacity(0.5),
            strokeWidth: 5,
            strokeColor: Colors.redAccent.shade100,
          ):
     Circle(
     circleId: CircleId('circle'),
     center: LatLng(26.1295, 91.6204752),
     radius: 140,
     fillColor: Colors.blueAccent.shade100.withOpacity(0.5),
     strokeWidth: 5,
     strokeColor: Colors.blueAccent.shade100,
     ),
        }
      )
    );
  }
}
