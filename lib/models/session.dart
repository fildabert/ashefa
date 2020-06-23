import 'dart:io';
import 'user.dart';

class Session {
  String id;
  String name;
  DateTime time;
  bool completed;
  String type;
  String report;
  List<String> pictures = [];
  List<User> counselors = [];
  List<User> clients = [];
  List<File> imagesToUpload = [];
  String location;
  DateTime createdAt;

  static List<Session> parseList(List<dynamic> rawSessions) {
    List<Session> result = [];

    rawSessions.forEach((session) {
      result.add(Session(
        id: session['_id'],
        name: session['name'],
        time: DateTime.parse(session['time']),
        completed: session['completed'] == 'true',
        type: session['type'],
        report: session['report'],
        pictures:
            List<String>.from(session['pictures'].where((i) => i is String)),
        counselors: User.parseList(session['counselors']),
        clients: User.parseList(session['clients']),
        createdAt: DateTime.parse(
          session['createdAt'],
        ),
      ));
    });
    return result;
  }

  Session(
      {this.name,
      this.id,
      this.counselors,
      this.clients,
      this.time,
      this.completed,
      this.type,
      this.report,
      this.pictures,
      this.createdAt,
      this.imagesToUpload,
      this.location});
}
