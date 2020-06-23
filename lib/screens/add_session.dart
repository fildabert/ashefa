import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'edit_session.dart';
import 'package:ashefa/store.dart';
import 'package:provider/provider.dart';
import 'package:ashefa/models/session.dart';

class AddSessionScreen extends StatefulWidget {
  static const String id = 'add_session_screen';

  @override
  _AddSessionScreenState createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  int _selectedBottomNavigation = 0;
  bool expandedKah = false;
  List expandedList = [
    'Session1',
    'Session2',
    'Session3',
    'Session4',
    'Session5'
  ];

  List<String> sessionNames = [
    'Cleaning Activity',
    'Sports Activity',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
//    initSessionType();
  }

  List<Widget> initSessionType(BuildContext context) {
    List<Widget> sessionTypeList = [];
    for (String session in sessionNames) {
      sessionTypeList.add(Card(
        elevation: 2,
        child: ListTile(
          title: Text(session),
          trailing: Icon(Icons.navigate_next),
          onTap: () {
            Navigator.pushNamed(context, EditSessionScreen.id);
            Provider.of<Store>(context, listen: false).sessionAction = 'CREATE';
            Provider.of<Store>(context, listen: false).setSelectedSession(
                Session(
                    type: session,
                    completed: false,
                    clients: [],
                    counselors: [],
                    imagesToUpload: [],
                    location:
                        Provider.of<Store>(context, listen: false).location));
          },
        ),
      ));
    }
    return sessionTypeList;
  }

  List<Widget> buildExpandedList(BuildContext context) {
    List<Widget> result = [];
    for (int i = 0; i < expandedList.length; i++) {
      if (i != expandedList.length - 1) {
        result.addAll([
          ListTile(
            title: Text(expandedList[i]),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pushNamed(context, EditSessionScreen.id);
              Provider.of<Store>(context, listen: false).sessionAction =
                  'CREATE';
              Provider.of<Store>(context, listen: false).setSelectedSession(
                  Session(
                      type: 'Psychodeducation',
                      name: expandedList[i],
                      completed: false,
                      clients: [],
                      counselors: [],
                      imagesToUpload: [],
                      location:
                          Provider.of<Store>(context, listen: false).location));
            },
          ),
          Divider()
        ]);
      } else {
        result.add(
          ListTile(
            title: Text(expandedList[i]),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              Navigator.pushNamed(context, EditSessionScreen.id);
              Provider.of<Store>(context, listen: false).sessionAction =
                  'CREATE';
              Provider.of<Store>(context, listen: false).setSelectedSession(
                  Session(
                      type: 'Psychodeducation',
                      name: expandedList[i],
                      completed: false,
                      clients: [],
                      counselors: [],
                      imagesToUpload: [],
                      location:
                          Provider.of<Store>(context, listen: false).location));
            },
          ),
        );
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Choose Session Type',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  expandedKah = !expandedKah;
                });
              },
              children: [
                ExpansionPanel(
                    isExpanded: expandedKah,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Text('Psychodeducation'),
                      );
                    },
                    canTapOnHeader: true,
                    body: Column(
                      children: buildExpandedList(context),
                    ))
              ],
            ),
            Column(
              children: initSessionType(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedBottomNavigation,
        onTap: (index) {
          if (index == 0) {
            Navigator.popAndPushNamed(context, HomeScreen.id);
          } else if (index == 1) {
            Navigator.popAndPushNamed(context, ProfileScreen.id);
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
