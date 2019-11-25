import 'package:flutter/material.dart';
import 'package:yoonlarm/pages/current_alarm.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:yoonlarm/model/alarm_repository.dart';
import 'package:yoonlarm/model/alarm.dart';

class AlarmRegistrationWidget extends StatefulWidget {
  final bool creation;
  final CurrentAlarm alarm;

  AlarmRegistrationWidget({@required this.creation, @required this.alarm});

  @override
  State<StatefulWidget> createState() {
    return AlarmStateWidget(creation: creation, alarm: alarm);
  }
}

class AlarmStateWidget extends State<AlarmRegistrationWidget> {
  final TextEditingController controller = TextEditingController();
  final bool creation;
  final CurrentAlarm alarm;

  AlarmStateWidget({@required this.creation, @required this.alarm});

  @override
  Widget build(BuildContext context) {
    controller.value = TextEditingValue(text: alarm.title);
    return Container(
      child: ListView(children: <Widget>[
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: Text(
              "${creation != null && creation ? 'New' : 'Modify'} Alarm",
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
              ),
            )),
        Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: TextField(
            showCursor: true,
            cursorColor: Colors.black,
            controller: controller,
            decoration: InputDecoration(
                hintText: "title"
            ),
            onSubmitted: (value) {
              alarm.title = value;
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: RaisedButton(
              child: Text(
                "After ${alarm.alarmSeconds} seconds",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)
              ),
              onPressed: () {
                print("alarmSeconds $alarm.alarmSeconds");
                showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      return new NumberPickerDialog.integer(
                        minValue: 1,
                        maxValue: 100,
                        title: new Text("Seconds"),
                        initialIntegerValue: alarm.alarmSeconds,
                      );
                    }
                ).then((value) {
                  if (value != null) {
                    setState(() => alarm.alarmSeconds = value);
                  }
                });
              }
          ),
        ),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: FlatButton(
              child: Text("SAVE"),
              onPressed: () {
                controller.clear();
                Navigator.of(context).pop(alarm);
              },
            )
        )
      ]),
    );
  }
}

void showRegisterForm(CurrentAlarm alarm, BuildContext context) async {
  final newAlarm = await showModalBottomSheet<CurrentAlarm>(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return AlarmRegistrationWidget(
            creation: true,
            alarm: alarm
        );
      });
  if (newAlarm != null) {
    AlarmRepository.instance.insert(Alarm.createNew(newAlarm.title, newAlarm.alarmSeconds));
  }
}