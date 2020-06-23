import 'package:flutter/material.dart';
import 'package:ashefa/screens/home.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedBottomNavigation = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Screen'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavigation,
        onTap: (index) {
          setState(() {
            _selectedBottomNavigation = index;
          });
          if (index == 0) {
            Navigator.pushNamed(context, HomeScreen.id);
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          )
        ],
      ),
    );
  }
}
