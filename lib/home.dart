import 'dart:async';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/scheduler.dart';
import 'alarmclass.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int no_of_alarms = 0;
  late int rings;
  late List<AlarmClock> alarms = [];
  late Map<String,dynamic> data;

  static StreamSubscription? subscription;

  AlarmSettings copyAlarm(AlarmSettings a, int duration){
    AlarmSettings newAlarm = AlarmSettings(id: a.id, dateTime: a.dateTime.add(Duration(days: duration)), assetAudioPath: a.assetAudioPath, loopAudio: a.loopAudio, stopOnNotificationOpen: a.stopOnNotificationOpen, notificationBody: a.notificationBody, notificationTitle: a.notificationTitle, enableNotificationOnKill: a.enableNotificationOnKill, vibrate: a.vibrate, fadeDuration: a.fadeDuration);
    return newAlarm;
  }

  void AlarmRings(AlarmClock a){
    Alarm.set(alarmSettings: a.aset);
    AlarmSettings alarmsetting = a.aset;
    // Alarm.ringStream.stream.asBroadcastStream(
    //   onListen: (alarmsetting) {
    //     Navigator.pushNamed(context, '/ringing', arguments: {"Alarm":a});
    //   }
    // );
    subscription ??= Alarm.ringStream.stream.listen((alarmsetting){
      Navigator.pushNamed(context, '/ringing',arguments: {"alarm":a});
      }
    );
  }

  Future<void> alarmData(BuildContext context) async{
    final result = await Navigator.pushNamed(context, '/add', arguments: {"alarm_no": no_of_alarms})!;
    data = Map<String,dynamic>.from(result as Map);
    //print(data);
    AlarmClock a = new AlarmClock(data["Alarm"], data["Repeat"]);
    if(a.aset.dateTime.isBefore(DateTime.now())){
      if(a.checkRepeat(a.aset.dateTime.weekday) == -1){
        a.aset = copyAlarm(a.aset, 1);
      }
      else if(a.checkRepeat(a.aset.dateTime.weekday) != -1){
        a.aset = copyAlarm(a.aset, a.checkRepeat(a.aset.dateTime.weekday));
      }
    }
    print(a.aset);
    setState(() {
      alarms.add(a);
      no_of_alarms = alarms.length;
      alarms.sort((a, b){return a.aset.dateTime.compareTo(b.aset.dateTime);});
      AlarmRings(a);
    });

  }

  Future<void> editAlarm(BuildContext context, int index) async{
    final result = await Navigator.pushNamed(context, '/add', arguments: {"alarm_no": index});
    alarms.removeAt(index);
    data = Map<String,dynamic>.from(result as Map);
    AlarmClock a = new AlarmClock(data["Alarm"], data["Repeat"]);
    if(a.aset.dateTime.isBefore(DateTime.now())){
      if(a.checkRepeat(a.aset.dateTime.weekday) == -1){
        a.aset = copyAlarm(a.aset, 1);
      }
      else if(a.checkRepeat(a.aset.dateTime.weekday) != -1){
        a.aset = copyAlarm(a.aset, a.checkRepeat(a.aset.dateTime.weekday));
      }
    }
    print(a.aset);
    setState(() {
      alarms.add(a);
      no_of_alarms = alarms.length;
      alarms.sort((x, y){return x.aset.dateTime.compareTo(y.aset.dateTime);});
      AlarmRings(a);
    });
  }

  late bool isLightMode;

  bool Light(BuildContext context){
    var brightness = MediaQuery.of(context).platformBrightness;
    print(brightness);
    if(brightness == Brightness.light){
      return true;
    }
    else{
      return false;
    }
  }

  initState(){
    Alarm.init();
  }


  @override
  Widget build(BuildContext context) {

    bool isLightMode = Light(context);
    if(isLightMode){
      print("Dark Mode is disabled");
    }
    else{
      print("Dark Mode is enabled");
    }

    return Scaffold(
        appBar: AppBar(

          title: Text(
              "Alarm Clock",
              style: TextStyle(
              color: isLightMode ? Colors.black : Colors.white
              ),
          ),
          centerTitle: true,

          // actions: [
          //   IconButton(
          //       onPressed: (){},
          //       icon: Icon(Icons.add_alarm),
          //       color: Colors.black,
          //   )
          // ],
          backgroundColor: isLightMode ? Colors.white : Colors.black,
          elevation: 3.0,
        ),
        body: Container(
          child: no_of_alarms == 0 ?
            Center(
              child: Column(
                children: [
                  Text("No alarms added",
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 1.25,
                      color: isLightMode ? Colors.grey[650] : Colors.grey[350]
                    )

                      ),
                  SizedBox(
                    height: 12.5,
                  ),
                  Text(
                      "Tap add alarm button to add an alarm",
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isLightMode ? Colors.grey[600] : Colors.grey[400],
                      ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
              )
            ) :

            ListView.builder(

                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                itemCount: this.no_of_alarms,
                itemBuilder: (context, index){

                  return Card(

                    child: ListTile(

                      leading: IconButton(
                          icon: alarms[index].set? isLightMode ? Icon(Icons.alarm_outlined, color: Colors.blue) : Icon(Icons.alarm_outlined, color: Colors.indigoAccent) : Icon(Icons.alarm_outlined),
                          onPressed: () {
                              if(alarms[index].set == true){
                                Alarm.stop(alarms[index].aset.id);
                                setState(() {
                                  alarms[index].set = false;
                                });
                              }
                              else{
                                AlarmRings(alarms[index]);
                                setState(() {
                                  alarms[index].set = true;
                                });

                              }

                          },
                      ),
                      title: Text('${alarms[index].aset.dateTime.day}-${alarms[index].aset.dateTime.month}-${alarms[index].aset.dateTime.year} ${alarms[index].aset.dateTime.hour}:${alarms[index].aset.dateTime.minute}', overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(alarms[index].aset.notificationTitle.toString(), overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize:15
                        ),
                      ),

                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: (){
                                  editAlarm(context, index);
                              },
                              icon: Icon(Icons.edit_outlined)
                          ),
                          IconButton(
                              onPressed: (){
                                Alarm.stop(this.alarms[index].aset.id);
                                setState(() {
                                  --no_of_alarms;
                                  alarms.removeAt(index);
                                });

                              },
                              icon: Icon(Icons.delete_outline_outlined)
                          ),
                        ],
                      ),
                    )
                  );
                }
            ),
        ),
        backgroundColor: isLightMode ? Colors.grey[200] : Colors.grey[800],
        bottomNavigationBar: BottomAppBar(
          child: TextButton(
            onPressed: () {
              alarmData(context);
            },
            child: Text("Add Alarm",
              style: TextStyle(
                color: isLightMode ? Colors.black : Colors.white,
                letterSpacing: 4,
                fontSize: 18
              ),
            ),
          ),
          elevation: 10.0,
          shadowColor: isLightMode ? Colors.grey[900] : Colors.grey[100],
        )

      );
  }
}