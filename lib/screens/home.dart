import 'package:ashefa/store.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ashefa/components/HomeTitle.dart';
import 'package:ashefa/components/activity_item.dart';
import 'package:ashefa/screens/schedule.dart';
import 'package:ashefa/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:ashefa/models/session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    super.initState();
    Provider.of<Store>(context, listen: false).getRecentActivities();

    _calendarController = CalendarController();
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

  Future<void> fetchSessions(Store storeData, DateTime date) async {
    var response = await http.get(
        '${storeData.baseUrl}/sessions/getbydate/${date.toIso8601String()}');
    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);

      storeData.sessionList = Session.parseList(result);
    }
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
