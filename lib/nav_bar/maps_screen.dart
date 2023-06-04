import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {

  static const CameraPosition _kGooglePlex=CameraPosition(
      target: LatLng(26.1295, 91.6204752),
      zoom: 14,
  );

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Maps',
        ),
      ),
      body:
      GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        initialCameraPosition: _kGooglePlex,
        circles: {
          Circle(
            circleId: CircleId('circle'),
            center: LatLng(26.1295, 91.6204752),
            radius: 140,
            fillColor: Colors.redAccent.shade100.withOpacity(0.5),
            strokeWidth: 5,
            strokeColor: Colors.redAccent.shade100,
          ),
        }
      )
    );
  }
}
