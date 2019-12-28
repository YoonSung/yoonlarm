import 'package:yoonlarm/model/alarm.dart';
import 'package:flutter/material.dart';

abstract class AlarmState {
}

class AlarmLoading extends AlarmState {}

class AlarmLoaded extends AlarmState {
  final List<Alarm> alarms;

  AlarmLoaded({@required this.alarms});
}