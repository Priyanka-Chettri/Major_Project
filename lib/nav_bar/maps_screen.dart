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
      target: LatLng(26.369275,91.679765),
      zoom:14.4746,
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
      const GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        initialCameraPosition: _kGooglePlex,
      )
    );
  }
}
