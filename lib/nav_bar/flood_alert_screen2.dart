import 'dart:io';

import 'package:flutter/material.dart';
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

  _loadPicker() async {
    await Permission.storage.request();
    var permissionStatus = await Permission.storage.status;
    if (permissionStatus.isGranted) {
      XFile? picked =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        pickedImage = File(picked.path);
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
    // await FirebaseStorage.instance.ref('uploads/file-to-upload.png').putFile(pickedImage);
   Future.delayed(const Duration(seconds: 2), () {
       setState(() {
        isUploading = false;
        isUploaded = true;
        isFilePicked = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File Uploaded'),
        ),
      );
    });
  }

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
                              'The precipitation is 0.5 mm',
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
                              'The above image shows that the location is highly blocked due to a vast amount of garbage being collected there. There may be a chance of flood here.',
                              style: TextStyle(
                                fontSize: 22,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.1,
                                color: Colors.red
                              ),
                              textAlign: TextAlign.center,
                            ),
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
