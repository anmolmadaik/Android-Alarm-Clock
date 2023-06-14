import 'package:alarm/alarm.dart';
import 'package:andoidclock/alarmclass.dart';
import 'package:flutter/material.dart';


class Ringing extends StatefulWidget {

  @override
  State<Ringing> createState() => _RingingState();
}

class _RingingState extends State<Ringing> {

  AlarmSettings copyAlarm(AlarmSettings a, int duration){
    AlarmSettings newAlarm = AlarmSettings(id: a.id, dateTime: a.dateTime.add(Duration(days: duration)), assetAudioPath: a.assetAudioPath, loopAudio: a.loopAudio, stopOnNotificationOpen: a.stopOnNotificationOpen, notificationBody: a.notificationBody, notificationTitle: a.notificationTitle, enableNotificationOnKill: a.enableNotificationOnKill, vibrate: a.vibrate, fadeDuration: a.fadeDuration);
    return newAlarm;
  }

  AlarmSettings copyAlarmMinute(AlarmSettings a){
    AlarmSettings newAlarm = AlarmSettings(id: a.id, dateTime: a.dateTime.add(Duration(minutes: 5)), assetAudioPath: a.assetAudioPath, loopAudio: a.loopAudio, stopOnNotificationOpen: a.stopOnNotificationOpen, notificationBody: a.notificationBody, notificationTitle: a.notificationTitle, enableNotificationOnKill: a.enableNotificationOnKill, vibrate: a.vibrate, fadeDuration: a.fadeDuration);
    return newAlarm;
  }



  @override
  Widget build(BuildContext context) {
    int scale;
    final alarm = (ModalRoute.of(context)!.settings.arguments?? <String, dynamic>{}) as Map;
    print(alarm["alarm"]);
    AlarmClock a = alarm["alarm"];
    String bg;
    if(a.aset.dateTime.hour.toInt() >= 5 && a.aset.dateTime.hour.toInt() <12){
      bg = "background/morning.jpg";
      scale = 900;
    }
    else if(a.aset.dateTime.hour.toInt() >= 12 && a.aset.dateTime.hour.toInt() <17){
      bg = "background/noon.jpg";
      scale = 900;
    }
    else  if(a.aset.dateTime.hour.toInt() >= 17 && a.aset.dateTime.hour.toInt() <20){
      bg = "background/sunset.jpg";
      scale = 100;
    }
    else{
      bg = "background/night.jpg";
      scale = 100;
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bg),
            fit: BoxFit.cover
          ),
        ),
        child: Center(
          child: SafeArea(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                     a.aset.dateTime.minute<10 ? "${a.aset.dateTime.hour}:0${a.aset.dateTime.minute}" : "${a.aset.dateTime.hour}:${a.aset.dateTime.minute}",
                    style: TextStyle(
                      color: Colors.grey[scale],
                      fontSize: 75
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    a.aset.notificationTitle.toString(),
                    style: TextStyle(
                        color: Colors.grey[scale],
                        fontSize: 50,
                      letterSpacing: 1.5
                    ),
                  ),
                  SizedBox(
                    height: 42.5
                  ),
                  Text(
                    a.aset.notificationBody.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[scale],
                        fontSize: 22.5,

                    ),
                  ),
                  SizedBox(
                    height:175
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey.shade200),
                              padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)
                                )
                              )
                            ),
                            onPressed: (){
                              Alarm.stop(a.aset.id);
                              Alarm.set(alarmSettings: copyAlarmMinute(a.aset));
                              Navigator.pop(context);
                            },
                            child: Text("Snooze by 5 minutes",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.5
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30
                  ),
                  Row(
                    children: [
                      Expanded(

                        child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<Color>(Colors.red.shade700),
                                padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                                shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                    )
                                )
                            ),
                            child: Text(
                              "Cancel Alarm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.5
                              ),
                            ),
                            onPressed: (){
                              if(a.checkRepeat(a.aset.dateTime.weekday) == -1){
                                Alarm.stop(a.aset.id);
                              }
                              else{
                                Alarm.stop(a.aset.id);
                                int index = a.checkRepeat(a.aset.dateTime.weekday);
                                Alarm.set(alarmSettings: copyAlarm(a.aset,index));
                              }
                              Navigator.pop(context);
                            }
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
