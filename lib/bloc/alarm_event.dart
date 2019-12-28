import 'package:flutter/material.dart';
import 'package:yoonlarm/model/alarm.dart';

abstract class AlarmEvent {
}

class AddAlarm extends AlarmEvent {
  final Alarm entity;

  AddAlarm({@required this.entity});
}

class LoadAlarm extends AlarmEvent {
}

class RemoveAlarm extends AlarmEvent {
}