import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:ashefa/components/session_item.dart';
import 'package:ashefa/components/custom_timeline.dart';
import 'package:ashefa/screens/add_session.dart';
import 'package:ashefa/store.dart';
import 'package:ashefa/models/session.dart';
import 'package:ashefa/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ScheduleScreen extends StatefulWidget {
  static const String id = 'schedule_screen';

  final DateTime date;

  ScheduleScreen({this.date});
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool loading = false;

  void setLoading(bool input) {
    setState(() {
      loading = input;
    });
  }

  Future<void> fetchSessions(Store storeData) async {
    setLoading(true);
    await Future.delayed(Duration(seconds: 1));
    var response = await http.get(
        '${storeData.baseUrl}/sessions/getbydate/${widget.date.toIso8601String()}');
    if (response.statusCode == 200) {
      List<dynamic> result = jsonDecode(response.body);
      storeData.sessionList = Session.parseList(result);
    }
    setLoading(false);
  }

  List<Widget> buildTimelines(BuildContext context, Store storeData) {
    List<Widget> result = [];
    // TODO: fetch sessions based on selected date
    List<Session> sessions = storeData.sessionList;
    Map<DateTime, List<Session>> dividedSessions = {};

    sessions.sort((a, b) => a.time.compareTo(b.time));

    // Convert List to Map
    for (int i = 0; i < sessions.length; i++) {
      DateTime timeKey = sessions[i].time;
      if (!dividedSessions.containsKey(timeKey)) {
        dividedSessions[timeKey] = [];
        dividedSessions[timeKey].add(sessions[i]);
      } else {
        dividedSessions[timeKey].add(sessions[i]);
      }
    }

    int mapIndex = 0;
    dividedSessions.forEach((hourOfDay, sessions) {
      List<Widget> sessionsInTheSameHour = [];

      bool isDone = false;
      int sessionsDone = 0;

      // Arrange divider
      for (int i = 0; i < sessions.length; i++) {
        if (sessions[i].completed) {
          sessionsDone += 1;
        }
        if (sessions.length != 1 && i != sessions.length - 1) {
          sessionsInTheSameHour.addAll([
            SessionItem(session: sessions[i]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            )
          ]);
        } else {
          sessionsInTheSameHour.add(SessionItem(
            session: sessions[i],
          ));
        }
      }
      if (sessionsDone == sessions.length) {
        isDone = true;
      }

      // Arrange Timeline
      if (mapIndex == 0) {
        result.add(CustomTimeline(
          isFirst: true,
          isLast: false,
          isDone: isDone,
          time: DateFormat.Hm().format(hourOfDay),
          children: sessionsInTheSameHour,
        ));
      } else if (mapIndex == dividedSessions.length - 1) {
        result.add(CustomTimeline(
          isFirst: false,
          isLast: true,
          isDone: isDone,
          time: DateFormat.Hm().format(hourOfDay),
          children: sessionsInTheSameHour,
        ));
      } else {
        result.add(CustomTimeline(
          isFirst: false,
          isLast: false,
          isDone: isDone,
          time: DateFormat.Hm().format(hourOfDay),
          children: sessionsInTheSameHour,
        ));
      }
      mapIndex += 1;
    });

    return result;
  }

  @override
  void initState() {
    Provider.of<Store>(context, listen: false).selectedDate = widget.date;
    fetchSessions(Provider.of<Store>(context, listen: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, Store storeData, child) {
        return Container(
          child: ModalProgressHUD(
            inAsyncCall: loading,
            child: ListView(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 10, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            DateFormat.yMMMMd().format(widget.date),
                            style: TextStyle(fontSize: 25),
                          ),
                          FlatButton.icon(
                            onPressed: () {
                              storeData.selectedDate = widget.date;
                              Navigator.pushNamed(context, AddSessionScreen.id);
                            },
                            icon: Icon(Icons.add_circle),
                            label: Text('Add Session'),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: buildTimelines(context, storeData),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//CustomTimeline(
//isFirst: true,
//isLast: false,
//time: '09.00',
//isDone: true,
//children: <Widget>[
//SessionItem(session: 'Session 1'),
//Padding(
//padding: const EdgeInsets.symmetric(horizontal: 10),
//child: Divider(),
//),
//SessionItem(session: 'Session 2')
//],
//),
//CustomTimeline(
//isFirst: false,
//isLast: false,
//isDone: false,
//time: '10.00',
//children: <Widget>[
//SessionItem(sessionName: 'Session 3')
//],
//),
