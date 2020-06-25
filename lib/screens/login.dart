import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:ashefa/store.dart';
import 'package:ashefa/models/user.dart';
import 'package:ashefa/screens/home.dart';
import 'package:ashefa/screens/select_location.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  LoginScreen({Key key, this.title}) : super(key: key);

  Map<String, String> userField = {
    'username': '',
    'password': '',
  };
  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool validate = true;

  void login() async {
    String baseUrl = Provider.of<Store>(context, listen: false).baseUrl;
    Map<String, String> headers = {"content-type": "application/json"};
    Map<String, String> data = {
      'username': widget.userField['username'],
      'password': widget.userField['password']
    };

    var body = jsonEncode(data);
    var response =
        await http.post('$baseUrl/users/login', headers: headers, body: body);

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      Provider.of<Store>(context, listen: false).loggedInUser =
          User.parseObject(result);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', result['_id']);
      Navigator.pushReplacementNamed(context, SelectLocationScreen.id);
    } else if (response.statusCode == 400) {
      setState(() {
        validate = false;
      });

      print(response.body);
    }
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              onChanged: (value) {
                widget.userField[title.toLowerCase()] = value;
              },
              obscureText: isPassword,
              decoration: InputDecoration(
                  errorText: validate ? null : 'Invalid Username/Password',
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        login();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(text: 'd',
//          style: GoogleFonts.portLligatSans(
//            textStyle: Theme.of(context).textTheme.display1,
//            fontSize: 30,
//            fontWeight: FontWeight.w700,
//            color: Color(0xffe46b10),
//          ),
          children: [
            TextSpan(
              text: 'Ash',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'efa',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Username"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  void checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String loggedIn = prefs.getString('userId');
    if (loggedIn != null) {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: Container()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(height: 50),
                    _emailPasswordWidget(),
                    SizedBox(height: 20),
                    _submitButton(),
//                  _divider(),
                    SizedBox(height: height * .055),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
