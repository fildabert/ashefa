import 'dart:convert';

import 'models/user.dart';
import 'models/session.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

class Store extends ChangeNotifier {
  String baseUrl = 'http://192.168.0.149:3000';
  String test = 'testing123';
  String location = 'Margasatwa';
  List<User> counselorList;
  List<User> clientList;
  DateTime selectedDate;
  User loggedInUser;
  List<Session> sessionList = [];
  List<Session> recentActivities = [];
  Session selectedSession;
  String sessionAction;

  void setSelectedSession(Session input) {
    selectedSession = input;
    notifyListeners();
  }

  Future<void> getRecentActivities() async {
    var response = await http.get('$baseUrl/sessions/recent');
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      recentActivities = Session.parseList(body);
      notifyListeners();
    }
  }

  Future<void> deleteSelectedSession() async {
    Dio dio = Dio();

    var response =
        await dio.post('$baseUrl/sessions/delete/${selectedSession.id}');

    if (response.statusCode == 200) {
      print(response.data);
    }
  }

  Future<void> saveSelectedSession() async {
    List<String> clientIds = [];
    List<String> counselorIds = [];

    selectedSession.clients.forEach((client) {
      clientIds.add(client.id);
    });

    selectedSession.counselors.forEach((counselor) {
      counselorIds.add(counselor.id);
    });
    print(selectedSession.location);
    Map data = {
      'name': selectedSession.name,
      'counselors': counselorIds,
      'clients': clientIds,
      'completed': selectedSession.completed,
      'type': selectedSession.type,
      'time': selectedSession.time.toIso8601String(),
      'report': selectedSession.report,
      'location': selectedSession.location,
      'pictures':
          selectedSession.pictures != null ? selectedSession.pictures : [],
    };

    var body = jsonEncode(data);
    Map<String, String> headers = {"content-type": "multipart/form-data"};

    Dio dio = Dio();

    if (sessionAction == 'CREATE') {
      FormData formData = FormData.fromMap({
        ...data,
      });

      formData.files.addAll(selectedSession.imagesToUpload.map(
          (file) => MapEntry('files', MultipartFile.fromFileSync(file.path))));

      var response = await dio.post('$baseUrl/sessions/create',
          data: formData, options: Options(headers: headers));
      print(response.data);
    } else if (sessionAction == 'EDIT') {
      FormData formData = FormData.fromMap({
        ...data,
      });

      formData.files.addAll(selectedSession.imagesToUpload.map(
          (file) => MapEntry('files', MultipartFile.fromFileSync(file.path))));

      var response = await dio.put(
          '$baseUrl/sessions/edit/${selectedSession.id}',
          data: formData,
          options: Options(headers: headers));
      print(response.data);
    }

    sessionAction = '';
    selectedDate = null;
    await getRecentActivities();
    notifyListeners();
  }
}
