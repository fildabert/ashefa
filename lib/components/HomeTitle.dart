import 'package:flutter/material.dart';
import 'package:ashefa/screens/select_location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:ashefa/store.dart';

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('images/margasatwa.jpg'),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  Provider.of<Store>(context, listen: false).location,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  Navigator.pushReplacementNamed(
                      context, SelectLocationScreen.id);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
