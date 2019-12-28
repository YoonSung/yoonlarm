import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoonlarm/bloc/alarm_event.dart';
import 'package:yoonlarm/bloc/alarm_state.dart';
import 'package:yoonlarm/pages/preset_page.dart';
import 'package:yoonlarm/pages/alarm_registration.dart';
import 'package:yoonlarm/pages/current_alarm.dart';
import 'package:yoonlarm/bloc/alarm_bloc.dart';

void main() => runApp(BlocProvider(
 builder: (context) => AlarmBloc()..add(LoadAlarm()),
 child: Yoonlarm()
));

class Yoonlarm extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'No more No forget Alarm',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Widget> pages = [
    PresetTableWidget(),
    AlarmListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Container(
            child: Text(
              'nono alarm',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            alignment: Alignment.center,
          )),
      body: DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          body: TabBarView(
            children: pages,
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(bottom: 20),
            child: new TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                ),
                Tab(
                  icon: Icon(Icons.format_list_numbered),
                ),
              ],
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.indigo,
              indicatorColor: Colors.transparent,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showRegisterForm(CurrentAlarm(title: "", alarmSeconds: 50), context),
        tooltip: 'create new Alarm',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}

class AlarmListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmBloc, AlarmState>(builder: (context, state) {
      if (state is AlarmLoaded) {
        return ListView.builder(
            itemCount: state.alarms.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(state.alarms[index].title),
              );
            });
      } else {
        return Container();
      }
    });
  }
}