import 'package:flutter/material.dart';
import 'package:ashefa/screens/home.dart';
import 'package:ashefa/components/custom_avatar.dart';
import 'package:ashefa/store.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ashefa/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile_screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = false;
  int _selectedBottomNavigation = 1;
  final picker = ImagePicker();
  File _image;

  void setLoading(bool input) {
    setState(() {
      loading = input;
    });
  }

  void getUser() async {
    Store storeData = Provider.of<Store>(context, listen: false);
    if (storeData.loggedInUser == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.get('userId');
      storeData.location = prefs.getString('location');

      Dio dio = Dio();

      var response = await dio.get('${storeData.baseUrl}/users/$userId');
      if (response.statusCode == 200) {
        storeData.loggedInUser = User.parseObject(response.data);
      }
    }
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }
//  Store storeData = Provider.of<Store>(context,listen: false);

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _image != null
                      ? Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.done,
                            ),
                            onPressed: () async {
                              setLoading(true);
                              Store storeData =
                                  Provider.of<Store>(context, listen: false);
                              Dio dio = Dio();
                              FormData formData = FormData.fromMap({
                                'file':
                                    await MultipartFile.fromFile(_image.path)
                              });
                              Map<String, String> headers = {
                                "content-type": "multipart/form-data"
                              };
                              var response = await dio.post(
                                '${storeData.baseUrl}/users/editProfilePicture/${storeData.loggedInUser.id}',
                                data: formData,
                                options: Options(headers: headers),
                              );
                              if (response.statusCode == 200) {
                                print(response.data);
                                storeData.loggedInUser =
                                    User.parseObject(response.data);
                              }
                              setLoading(false);
                              setState(() {
                                _image = null;
                              });
                            },
                          ),
                        )
                      : Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                            ),
                            onPressed: () {
                              getImage();
                            },
                          ),
                        ),
                  SizedBox(
                    height: 40,
                  ),
                  _image != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(_image),
                          radius: 100,
                        )
                      : CustomAvatar(
                          picture: Provider.of<Store>(context, listen: false)
                              .loggedInUser
                              .picture,
                          height: 200,
                          width: 200,
                        ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    '${Provider.of<Store>(context, listen: false).loggedInUser.firstName} ${Provider.of<Store>(context, listen: false).loggedInUser.lastName}',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    Provider.of<Store>(context, listen: false)
                        .loggedInUser
                        .userType,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            )
          ],
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
      ),
    );
  }
}
