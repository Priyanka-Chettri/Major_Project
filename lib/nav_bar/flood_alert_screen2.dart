import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FloodAlertScreen2 extends StatefulWidget {
  const FloodAlertScreen2({super.key, required this.title});

  final String title;

  @override
  State<FloodAlertScreen2> createState() => FloodAlertScreen2State();
}

class FloodAlertScreen2State extends State<FloodAlertScreen2> {

  File pickedImage = File("");
  bool isUploading = false;
  bool isUploaded = false;
  bool isFilePicked = false;
  bool isimagegarbage=true;
  var res;
  var response;


  _loadPicker() async {
    await Permission.storage.request();
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      XFile? picked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      print("picked:${picked}");
      if (picked != null) {
        pickedImage = File(picked.path);
        print("picked image:${pickedImage}");
        setState(() {
          isFilePicked = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission not granted. Try Again with permission access'),
        ),
      );
      Permission.storage.request();
    }
  }

  _uploadImage() async{
    setState(() {
      isUploading = true;
      isUploaded = false;
    });
    await FirebaseStorage.instance.ref('drainage_images/${DateTime.now().millisecondsSinceEpoch}.png').putFile(pickedImage).then((p0){
      setState(() {
        isUploading = false;
        isUploaded = true;
        imageNumber++;
        imageNumber %= 2;
        isFilePicked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File Uploaded'),
        ),
      );
    });
  }

  Future getData(
    {
      required double humidity,
      required double temperature,
      required double windspeed,
      required double pressure,
      required double waterLevel,
      Function(dynamic data)? onSuccess,
      Function(dynamic error)? onError,
      Map<String, String> headers = const {},
      String clientId = "",
    }
  ) async {
    Map<String, dynamic> reqBody = {
      'Temperature': temperature,
      'Humidity': humidity,
      'Windspeed': windspeed,
      'Pressure': pressure
    };
    print("Request body is $reqBody");
    // url is 
    try{
      headers = {
        'Content-Type': 'application/json',
      };
        response = await http.post(
        Uri.parse('http://192.168.0.104:5000/predict-rainfall-lstms/'),
        headers: headers,
        body: jsonEncode(reqBody)
      );
      if (response.statusCode == 200) {
        print("Response is ${response.body}");
        return (response.body);
      } else {
        print("Response is ${response.body}");
      }
    } catch (error) {
      print("Error is $error");
    }
    return 'hey';
  }

  var humidity=0.0, temperature=0.0, windspeed=0.0, pressure=0.0, waterLevel=0.0;
  Future getDataFromDB()async{
    final firebaserealtimeDB = FirebaseDatabase.instance.ref();
    Map<String, dynamic> data = {};
    await firebaserealtimeDB.root.once().then((DatabaseEvent event) {
      var json = jsonEncode(event.snapshot.value);
      humidity = jsonDecode(json)['Humidity']?.toDouble();
      temperature = jsonDecode(json)['Temperature']?.toDouble();
      windspeed = jsonDecode(json)['Windspeed']?.toDouble();
      pressure = jsonDecode(json)['Pressure']?.toDouble();
      waterLevel = jsonDecode(json)['water_level']?.toDouble();
    }).then((value) {
      return getData(humidity: humidity, temperature: temperature, windspeed: windspeed, pressure: pressure, waterLevel: waterLevel);
    });
  }

  @override
  void initState() {
    super.initState();
    helper();
  }
  var res1;
  helper() async
  {
    await getDataFromDB().then((value) async{
      res = await getData(humidity: humidity, temperature: temperature, windspeed: windspeed, pressure: pressure, waterLevel: waterLevel);
      print(res);
      res1=json.decode(res);
      print(res1);
    }).then((value) {
      setState(() {
        
      });
    });

  }

  int imageNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - 100,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                      alignment: Alignment.topCenter,
                      child: isUploaded ? 
                        Column(
                          children: [
                            const Text(
                              'Data based on the uploaded image',
                              style: TextStyle(
                                fontSize: 28,
                                height: 1.5,
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'The precipitation is ${res1["Prediction"].toString()}  mm',
                              style: TextStyle(
                                fontSize: 22,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.1,
                                color: Colors.blue
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                             Text(
                              imageNumber==1 && double.parse(res1["Prediction"].toString()) >= 0.3 && waterLevel >= 40?
                              "The above image shows that the location is highly blocked due to garbage being collected there. There is high probability of rain, so there will be a chance of flood here." :
                               (imageNumber==1 && double.parse(res1["Prediction"].toString()) < 0.3 && waterLevel >= 40?
                              'The above image shows that the location is highly blocked due to garbage being collected there, but no rain. So There may not be a chance of flood here.' : 
                              imageNumber==1 && double.parse(res1["Prediction"].toString()) < 0.3 && waterLevel < 40?
                              'The above image shows that the location is highly blocked due to garbage being collected there, but no chances of rain & flood.' : 
                              imageNumber==1 && double.parse(res1["Prediction"].toString()) > 0.3 && waterLevel < 40?
                              'The above image shows that the location is highly blocked due to garbage being collected there, but with high probability of rain there may be chance of flood.' :
                              imageNumber==0 && double.parse(res1["Prediction"].toString()) >= 0.3 && waterLevel >= 40?
                              "The above image shows that the location has no garbage here. There is high probability of rain, so there will be a chance of flood here." : 
                              imageNumber==0 && double.parse(res1["Prediction"].toString()) < 0.3 && waterLevel >= 40?
                              "The above image shows that the location has no garbage here. There is low probability of rain, so there may not be a chance of flood here." : 
                              imageNumber==0 && double.parse(res1["Prediction"].toString()) < 0.3 && waterLevel < 40?
                              "The above image shows that the location has no garbage here. There is low probability of rain, so there may not be a chance of flood here." : 
                              imageNumber==0 && double.parse(res1["Prediction"].toString()) > 0.3 && waterLevel < 40?
                              "The above image shows that the location has no garbage here. There is high probability of rain, so there may be a chance of flood here." : ""
                            ),
                               style: TextStyle(
                                   fontSize: 22,
                                   height: 1.5,
                                   fontWeight: FontWeight.bold,
                                   letterSpacing: 0.1,
                                   color: Colors.red
                               ),
                               textAlign: TextAlign.center,),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              radius: 0,
                              splashColor: Colors.transparent,
                              onTap: () {
                                isUploaded = false;
                                _loadPicker();
                              },
                              child: Container(
                                height: 50,
                                width: 250,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue[100],
                                  border: Border.all(
                                    color: Colors.blue,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Choose Another Image',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ) :
                        isUploading ?
                        Column(
                          children: [
                            const Text(
                              'Uploading Image',
                              style: TextStyle(
                                fontSize: 28,
                                height: 1.5,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const CircularProgressIndicator(),
                          ],
                        ) :
                       isFilePicked ? 
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              const Text(
                                'Selected Image :',
                                style: TextStyle(
                                  fontSize: 28,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Image.file(
                                pickedImage,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                radius: 0,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  _uploadImage();
                                },
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue[100],
                                    border: Border.all(
                                      color: Colors.blue,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.upload,
                                        size: 30,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Upload Image',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ) :
                       Column(
                        children: [
                          const Text(
                            'Select an Image to start',
                            style: TextStyle(
                              fontSize: 28,
                              height: 1.5,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            radius: 0,
                            splashColor: Colors.transparent,
                            onTap: () {
                              _loadPicker();
                            },
                            child: Container(
                              height: 50,
                              width: 250,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.lightBlue[100],
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    'Pick Image from Gallery',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
