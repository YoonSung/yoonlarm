
class Alarm {
  int id;
  String title;
  int alarmSeconds;
  int createdTimestamp;

  Alarm({this.id, this.title, this.alarmSeconds, this.createdTimestamp});

  static Alarm createNew(String title, int alarmSeconds) {
    return Alarm(id: null, title: title, alarmSeconds: alarmSeconds, createdTimestamp: null);
  }
}