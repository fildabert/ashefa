import 'package:flutter/material.dart';
import 'package:ashefa/models/session.dart';
import 'package:ashefa/models/user.dart';
import 'package:provider/provider.dart';
import 'package:ashefa/store.dart';
import 'package:ashefa/screens/edit_session.dart';
import 'package:ashefa/components/custom_avatar.dart';

class SessionItem extends StatelessWidget {
  final Session session;

  SessionItem({this.session});

  List<Widget> overlapClients() {
    List<Widget> result = [];
    List<User> clients = session.clients;
    for (int i = 0; i < clients.length; i++) {
      result.add(CustomAvatar(
        picture: clients[i].picture,
        width: 45.0,
        height: 45.0,
      ));
      if (i == 2) {
        break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(session.name),
//          Row(
//            children: overlapClients(),
//          )
        ],
      ),
      leading: CustomAvatar(
          picture: session.counselors[0].picture, height: 45.0, width: 45.0),
      onTap: () {
        Provider.of<Store>(context, listen: false).selectedSession = session;
        Provider.of<Store>(context, listen: false)
            .selectedSession
            .imagesToUpload = [];
        Provider.of<Store>(context, listen: false).sessionAction = 'EDIT';
        Navigator.pushNamed(context, EditSessionScreen.id);
      },
    );
  }
}

//NetworkImage(session.counselors[0].picture)
