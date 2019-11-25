import 'package:flutter/material.dart';
import 'package:yoonlarm/pages/preset_page.dart';
import 'package:yoonlarm/model/alarm.dart';
import 'package:yoonlarm/model/alarm_repository.dart';
import 'package:yoonlarm/pages/alarm_registration.dart';
import 'package:yoonlarm/pages/current_alarm.dart';

void main() => runApp(Yoonlarm());

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
    return FutureBuilder<List<Alarm>>(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            !projectSnap.hasData) {
          print(projectSnap.data);
          return Container();
        }
        return ListView.builder(
            itemCount: projectSnap.data == null ? 0 : projectSnap.data.length,
            itemBuilder: (context, index) => _buildItem(context, projectSnap.data[index])
        );
      },
      future: AlarmRepository.instance.queryAllRows(),
    );
  }

  Widget _buildItem(BuildContext context, Alarm alarm) {
    return ListTile(
      title: Text(alarm.title),
    );
  }
}
/*
class AlarmListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AlarmListState(getAllAlarms());

  Future<List<Alarm>> getAllAlarms() {
    return AlarmRepository.instance.queryAllRows();
  }
}

class _AlarmListState extends State<AlarmListPage> {

  Future<List<Alarm>> alarms;

  _AlarmListState(this.alarms);

  Widget _buildItem(BuildContext context, Alarm alarm) {
    return ListTile(
      title: Text(alarm.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Alarm>>(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            !projectSnap.hasData) {
          print(projectSnap.data);
          return Container();
        }
        return ListView.builder(
          itemCount: projectSnap.data == null ? 0 : projectSnap.data.length,
          itemBuilder: (context, index) => _buildItem(context, projectSnap.data[index])
        );
      },
      future: alarms,
    );
  }

}
*/