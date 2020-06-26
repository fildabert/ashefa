import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ashefa/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:ashefa/store.dart';
import 'package:ashefa/screens/home.dart';

class SelectLocationScreen extends StatefulWidget {
  static const String id = 'select_location_screen';

  static List<String> locationList = ['Margasatwa', 'Antasari'];

  static final List<List<Color>> gradientList = [
    [Color(0xFF70e1f5), Color(0xFFffd194)],
    [Color(0xFF556270), Color(0xFFFF6B6B)],
    [Color(0xFFB3FFAB), Color(0xFF12FFF7)],
    [Color(0xFFF0C27B), Color(0xFF4B1248)],
    [Color(0xFFFF4E50), Color(0xFFF9D423)],
    [Color(0xFFFBD3E9), Color(0xFFBB377D)],
    [Color(0xFFC9FFBF), Color(0xFFFFAFBD)],
    [Color(0xFF649173), Color(0xFFDBD5A4)],
    [Color(0xFF5D4157), Color(0xFFA8CABA)],
    [Color(0xFF1F1C2C), Color(0xFF928DAB)],
  ];

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  int locationIndex = 0;

  final List<Widget> imageSliders = SelectLocationScreen.locationList
      .map((item) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.white, width: 0.4),
            ),
            child: Container(
              margin: EdgeInsets.all(20.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 100,
                        backgroundImage:
                            AssetImage('images/${item.toLowerCase()}.jpg'),
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          child: Text(
                            '${item}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: SelectLocationScreen.gradientList[
                  Random().nextInt(SelectLocationScreen.gradientList.length)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('userId');
                    Navigator.pushReplacementNamed(context, LoginScreen.id);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 40, top: 80),
                child: Text(
                  'Select Location',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  initialPage: 0,
                  onPageChanged: (index, changeReason) {
                    locationIndex = index;
                  },
                  autoPlay: false,
                  aspectRatio: 1.35,
                  enlargeCenterPage: true,
                ),
                items: imageSliders,
              ),
              SizedBox(
                height: 20,
              ),
              OutlineButton(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                color: Colors.white,
                highlightColor: Colors.white,
                highlightedBorderColor: Colors.white,
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
                onPressed: () async {
                  Provider.of<Store>(context, listen: false).location =
                      SelectLocationScreen.locationList[locationIndex];
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('location',
                      SelectLocationScreen.locationList[locationIndex]);
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
