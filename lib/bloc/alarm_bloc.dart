import 'package:bloc/bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yoonlarm/bloc/alarm_event.dart';
import 'package:yoonlarm/bloc/alarm_state.dart';
import 'package:yoonlarm/model/alarm_repository.dart';


class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  @override
  AlarmState get initialState => AlarmLoading();

  @override
  Stream<AlarmState> mapEventToState(AlarmEvent event) async* {
    if (event is LoadAlarm) {
      yield* _mapLoadAlarms();
    } else if (event is AddAlarm) {
      yield* _mapAddAlarm(event);
    } else if (event is RemoveAlarm) {
      // TODO
    }
  }

  Stream<AlarmState> _mapLoadAlarms() async* {
    yield AlarmLoaded(alarms: await AlarmRepository.instance.queryAllRows());
  }

  Stream<AlarmState> _mapAddAlarm(AddAlarm event) async* {
    await AlarmRepository.instance.insert(event.entity);
    yield* _mapLoadAlarms();
  }
}