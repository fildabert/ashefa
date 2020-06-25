import 'package:flutter/material.dart';
import 'package:ashefa/models/session.dart';
import 'package:ashefa/components/custom_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:ashefa/store.dart';
import 'package:ashefa/screens/edit_session.dart';

class ActivityItem extends StatelessWidget {
  final Session session;

  ActivityItem({this.session});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            CustomAvatar(
              picture: session.counselors[0].picture,
              width: 45.0,
              height: 45.0,
            ),
            Expanded(
              child: ListTile(
                onTap: () {
                  Provider.of<Store>(context, listen: false)
                      .setSelectedSession(session);
                  Provider.of<Store>(context, listen: false).sessionAction =
                      'VIEW';
                  Navigator.pushNamed(context, EditSessionScreen.id);
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(session.name),
                    Text(
                      timeago.format(session.updatedAt),
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                ),
                subtitle: Text(
                    'A Session has been ${session.version > 0 ? "updated" : "created"} by ${session.counselors[0].firstName} ${session.counselors[0].lastName}'),
              ),
            )
          ],
        ),
        Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
