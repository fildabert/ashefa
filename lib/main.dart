import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/add_session.dart';
import 'screens/login.dart';
import 'screens/profile.dart';
import 'screens/schedule.dart';
import 'screens/edit_session.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/select_location.dart';
import 'store.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Store>(
      create: (context) => Store(),
      child: MaterialApp(
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SelectLocationScreen.id: (context) => SelectLocationScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          AddSessionScreen.id: (context) => AddSessionScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          ScheduleScreen.id: (context) => ScheduleScreen(),
          EditSessionScreen.id: (context) => EditSessionScreen()
        },
        initialRoute: SelectLocationScreen.id,
      ),
    );
  }
}

//loggedIn ? HomeScreen.id : LoginScreen.id
