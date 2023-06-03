import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maj_project/nav_bar/flood_alert_screen.dart';
import 'package:maj_project/nav_bar/maps_screen.dart';
import 'package:maj_project/nav_bar/profile_screen.dart';
import 'package:maj_project/nav_bar/weather_screen.dart';

import 'nav_bar/flood_alert_screen2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex=0;
  final List<Widget> _childrens =[
    WeatherScreen(),
    MapsScreen(),
    FloodAlertScreen2(title: 'Flood Alert',),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
    _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Bar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        /*appBar: AppBar(
          title: Text('Home Screen'),
          elevation: 5,
        ),*/
   body: _childrens[_selectedIndex],
   /* Container(
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
    SizedBox(height: 50),
    const Text(
    'Monday, 12 April',
    textAlign: TextAlign.center,
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    const SizedBox(height: 18),
    const Text(
    'Sunny',
    textAlign: TextAlign.center,
    style: TextStyle(
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
      ),*/
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Maps',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.water_damage),
              label: 'Flood Alert',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
