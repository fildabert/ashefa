import 'package:ashefa/store.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ashefa/components/HomeTitle.dart';
import 'package:ashefa/components/activity_item.dart';
import 'package:ashefa/screens/schedule.dart';
import 'package:ashefa/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:ashefa/models/session.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ashefa/models/user.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedBottomNavigation = 0;

  CalendarController _calendarController;
  @override
  void initState() {
    getCurrentLocationAndUser();
    super.initState();
    Store storeData = Provider.of<Store>(context, listen: false);
    storeData.getRecentActivities(storeData.location);

    _calendarController = CalendarController();
  }

  void getCurrentLocationAndUser() async {
    Store storeData = Provider.of<Store>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.get('userId');
    storeData.location = prefs.getString('location');
    Dio dio = Dio();

    var response = await dio.get('${storeData.baseUrl}/users/$userId');
    if (response.statusCode == 200) {
      storeData.loggedInUser = User.parseObject(response.data);
    }
  }

  List<Widget> getRecentActivities() {
    List<Widget> result = [];
    List<Session> recentActivities =
        Provider.of<Store>(context).recentActivities;
    recentActivities.forEach((session) {
      result.add(ActivityItem(
        session: session,
      ));
    });
    return result;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                HomeTitle(),
                Card(
                  child: TableCalendar(
                    calendarController: _calendarController,
                    onDaySelected: (selectedDay, list) async {
                      showModalBottomSheet(
                        useRootNavigator: true,
                        context: context,
                        builder: (context) {
                          return ScheduleScreen(
                            date: selectedDay,
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Recent Activities',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w400),
                      ),
                      Column(
                        children: getRecentActivities(),
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavigation,
        onTap: (index) {
          setState(() {
            _selectedBottomNavigation = index;
          });
          if (index == 1) {
            Navigator.pushNamed(
              context,
              ProfileScreen.id,
            );
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
