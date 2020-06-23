import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async';
import 'package:ashefa/models/user.dart';
import 'package:ashefa/components/chip_field.dart';
import 'package:ashefa/store.dart';
import 'package:provider/provider.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:ashefa/models/session.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:ashefa/screens/home.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditSessionScreen extends StatefulWidget {
  static const String id = 'edit_session_screen';

  @override
  _EditSessionScreenState createState() => _EditSessionScreenState();
}

class _EditSessionScreenState extends State<EditSessionScreen> {
  bool loading = false;
  String baseUrl = 'http://192.168.0.149:3000';
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
//      _image = File(pickedFile.path);
      imgList.add(File(pickedFile.path));
    });
  }

  TextEditingController sessionTypeController = TextEditingController();
  TextEditingController sessionNameController = TextEditingController();
  TextEditingController sessionTimeController = TextEditingController();
  TextEditingController sessionReportController = TextEditingController();

  Map<String, bool> validator = {
    'name': true,
    'time': true,
    'counselors': true,
    'clients': true,
  };

  List<User> counselorList;
  List<User> clientList;

  void getClients() async {
    clientList = [];

    var response = await http.get('$baseUrl/users/activeClients');
    if (response.statusCode == 200) {
      List<dynamic> responseArr = jsonDecode(response.body);
      responseArr.forEach((element) {
        Map<String, dynamic> userObject = element;
        clientList.add(User(
            id: userObject['_id'],
            firstName: userObject['firstName'],
            lastName: userObject['lastName'],
            email: userObject['email'],
            picture: userObject['picture'],
            userType: userObject['userType']));
      });
    }
  }

  void getCounselors() async {
    counselorList = [];

    var response = await http.get('$baseUrl/users/activeCounselors');
    if (response.statusCode == 200) {
      List<dynamic> responseArr = jsonDecode(response.body);
      responseArr.forEach((element) {
        Map<String, dynamic> userObject = element;
        counselorList.add(User(
            id: userObject['_id'],
            firstName: userObject['firstName'],
            lastName: userObject['lastName'],
            email: userObject['email'],
            picture: userObject['picture'],
            userType: userObject['userType']));
      });
    }
  }

  void setLoading(bool input) {
    setState(() {
      loading = input;
    });
  }

  @override
  void dispose() {
    sessionNameController.dispose();
    sessionTimeController.dispose();
    sessionReportController.dispose();
    sessionTypeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Store storeData = Provider.of<Store>(context, listen: false);

    if (storeData.selectedSession.pictures != null) {
      storeData.selectedSession.pictures.forEach((pic) {
        imgList.add(pic);
      });
    }

    super.initState();
    DateTime time = storeData.selectedSession.time;
    sessionTypeController.text = storeData.selectedSession.type;
    sessionNameController.text = storeData.selectedSession.name;

    if (time != null) {
      sessionTimeController.text = DateFormat.Hm().format(time);
    }
    sessionReportController.text = storeData.selectedSession.report;
    getClients();
    getCounselors();
//    print(counselorList.length);
//    print(clientList.length);
  }

  List<dynamic> imgList = [];

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("HH:mm");
    return Consumer(
      builder: (BuildContext context, Store storeData, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              storeData.selectedDate != null
                  ? DateFormat.yMMMMd().format(storeData.selectedDate)
                  : 'Session',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        title: new Text("Confirm Delete"),
                        content: new Text(
                            "Are you sure you want to delete this session?"),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          FlatButton(
                            child: new Text("Yep"),
                            onPressed: () async {
                              setLoading(true);
                              await Provider.of<Store>(context, listen: false)
                                  .deleteSelectedSession();
                              setLoading(false);
                              Navigator.popUntil(
                                  context, ModalRoute.withName(HomeScreen.id));
                            },
                          ),
                          FlatButton(
                            child: new Text("Nah"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.file_upload),
                onPressed: () {
                  getImage();
                  // TODO: upload photo
                },
              ),
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () async {
                  int validateCount = 0;

                  setState(() {
                    sessionNameController.text.isNotEmpty
                        ? validator['name'] = true
                        : validator['name'] = false;
                    sessionTimeController.text.isNotEmpty
                        ? validator['time'] = true
                        : validator['time'] = false;
                    storeData.selectedSession.counselors.length > 0
                        ? validator['counselors'] = true
                        : validator['counselors'] = false;
                    storeData.selectedSession.clients.length > 0
                        ? validator['clients'] = true
                        : validator['clients'] = false;
                    validator.forEach((key, value) {
                      if (value) {
                        validateCount += 1;
                      }
                    });
                  });
                  if (validateCount == validator.length) {
                    setLoading(true);
                    storeData.selectedSession.imagesToUpload =
                        List<File>.from(imgList.where((file) => file is File));

                    await storeData.saveSelectedSession();
                    setLoading(false);
                    Navigator.popUntil(
                        context, ModalRoute.withName(HomeScreen.id));
                  }
                  print(validator);
                },
              ),
            ],
          ),
          body: ModalProgressHUD(
            inAsyncCall: loading,
            child: SafeArea(
              child: ListView(
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(),
                    items: imgList.map((item) {
                      if (item is File) {
                        return Container(
                          child: Center(
                              child: Image.file(item,
                                  fit: BoxFit.cover, width: 1000)),
                        );
                      } else if (item is String) {
                        return Container(
                          child: Center(
                              child: Image.network(item,
                                  fit: BoxFit.cover, width: 1000)),
                        );
                      }
                    }).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          controller: sessionNameController,
                          onChanged: (input) {
                            storeData.selectedSession.name = input;
                          },
                          decoration: InputDecoration(
                              errorText: validator['name']
                                  ? null
                                  : 'Value Can\'t Be Empty',
                              labelText: 'Session Name',
                              border: OutlineInputBorder(),
                              isDense: true),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: ChipField(
                            labelText: 'Select Counselors',
                            userList: counselorList,
                            errorText: validator['counselors']
                                ? null
                                : 'Value Can\'t Be Empty',
                            initialValue:
                                storeData.selectedSession.counselors != null
                                    ? storeData.selectedSession.counselors
                                    : [],
                            onChanged: (List<User> counselors) {
                              storeData.selectedSession.counselors = counselors;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: ChipField(
                            labelText: 'Select Clients',
                            userList: clientList,
                            errorText: validator['clients']
                                ? null
                                : 'Value Can\'t Be Empty',
                            initialValue:
                                storeData.selectedSession.clients != null
                                    ? storeData.selectedSession.clients
                                    : [],
                            onChanged: (List<User> clients) {
                              storeData.selectedSession.clients = clients;
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          readOnly: true,
                          controller: sessionTypeController,
                          decoration: InputDecoration(
                              labelText: 'Session Type',
                              enabled: false,
                              border: OutlineInputBorder(),
                              isDense: true),
                        ),
                        SizedBox(height: 10),
                        DateTimeField(
                          controller: sessionTimeController,
                          format: format,
                          decoration: InputDecoration(
                              labelText: 'Time',
                              errorText: validator['time']
                                  ? null
                                  : 'Value Can\'t Be Empty',
                              border: OutlineInputBorder(),
                              isDense: true),
                          onShowPicker: (context, currentValue) async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            DateTime selectedTime = DateTimeField.convert(time);
                            DateTime today = storeData.selectedDate;
                            Session selectedSession = storeData.selectedSession;
                            selectedSession.time = DateTime.parse(
                                '${today.year}-${today.month < 10 ? "0${today.month}" : today.month}-${today.day}T${selectedTime.hour < 10 ? "0${selectedTime.hour}" : selectedTime.hour}:${selectedTime.minute < 10 ? "0${selectedTime.minute}" : selectedTime.minute}:00.000Z');
                            return DateTimeField.convert(time);
                          },
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: sessionReportController,
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (input) {
                            Session selectedSession = storeData.selectedSession;
                            selectedSession.report = input;
                          },
                          maxLines: 8,
                          decoration: InputDecoration(
                            labelText: 'Session Report',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        SwitchListTile(
                          title: storeData.selectedSession.completed
                              ? Text('Completed')
                              : Text('Ongoing'),
                          value: storeData.selectedSession.completed,
                          onChanged: (bool value) {
                            setState(() {
                              storeData.selectedSession.completed = value;
                            });
                          },
                          secondary: Icon(
                            storeData.selectedSession.completed
                                ? Icons.check_circle
                                : Icons.timelapse,
                            color: storeData.selectedSession.completed
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
