import 'package:flutter/material.dart';
import 'package:ashefa/models/session.dart';
import 'package:ashefa/components/custom_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(session.name),
                    Text(
                      timeago.format(session.createdAt),
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    )
                  ],
                ),
                subtitle: Text(
                    'A Session has been created by ${session.counselors[0].firstName} ${session.counselors[0].lastName}'),
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
