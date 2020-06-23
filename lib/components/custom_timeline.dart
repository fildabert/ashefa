import 'package:flutter/material.dart';
import 'package:ashefa/components/session_item.dart';
import 'package:timeline_tile/timeline_tile.dart';

class CustomTimeline extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isDone;
  final List<Widget> children;
  final String time;

  CustomTimeline(
      {this.isFirst, this.isLast, this.children, this.time, this.isDone});

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.left,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        indicator: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 12,
              child: Icon(
                isDone ? Icons.check_circle : Icons.timelapse,
                color: isDone ? Colors.green : Colors.orange,
              ),
            ),
            Container(
              child: Text(time),
              color: Colors.white,
            )
          ],
        ),
        width: 40,
        height: 40,
        color: Colors.purple,
        indicatorY: 0.5,
      ),
      rightChild: Card(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
