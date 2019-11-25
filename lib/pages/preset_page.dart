import 'package:flutter/material.dart';
import 'package:yoonlarm/pages/current_alarm.dart';
import 'package:yoonlarm/pages/alarm_registration.dart';
import 'package:yoonlarm/model/alarm.dart';
import 'package:yoonlarm/model/alarm_repository.dart';

class PresetTableWidget extends StatefulWidget {
  PresetTableWidget({Key key}) : super(key: key);

  @override
  _PresetTableWidgetState createState() => _PresetTableWidgetState();
}

class _PresetTableWidgetState extends State<PresetTableWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.only(top: 12),
        child: Table(
          border: null,
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: presetList(),
        )
    );
  }

  List<TableRow> presetList() {
    return <TableRow>[
      TableRow(
        children: <Widget>[
          createButton("3초", Icons.timer_3, 3),
          createButton("10초", Icons.timer_10, 10),
        ],
      ),
      TableRow(
          children: <Widget>[
            createButton("일", Icons.work, 3600),
            createButton("휴식", Icons.healing, 600),
          ]
      ),
      TableRow(
          children: <Widget>[
            createButton("계정", Icons.account_box, 5),
            createButton("와이파이", Icons.wifi, 2),
          ]
      )
    ];
  }

  Widget createButton(String title, IconData iconData, int seconds) {
    return IconButton(
      onPressed: () => showRegisterForm(CurrentAlarm(title: title, alarmSeconds: seconds), context),
      color: null,
      padding: EdgeInsets.all(50.0),
      iconSize: 60,
      icon: Icon(iconData),
    );
  }
}