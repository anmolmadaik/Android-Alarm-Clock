import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:permission_handler/permission_handler.dart';

class Add extends StatefulWidget {


  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {


  late DateTime selectedTime = DateTime.now();
  List<bool> values = List.filled(7, false);
  bool? isChecked = false;
  bool tomorrow = false;

  late int id;
  late String audiopath;
  bool vibrate = true;
  late String title;
  late String body;
  String sound = '';

  final NameControl = TextEditingController();
  final bodyControl = TextEditingController();

  late AlarmSettings a;



  List<bool> everyday(bool b){
    if(b){
      return List.filled(7, true);
    }
    else{
      return List.filled(7, false);
    }
  }

  AlarmSettings createAlarm(int i,bool v, String t, String b, String s){
    if(s==''){
      s='sounds/default.wav';
    }
    return AlarmSettings(id: i, dateTime: selectedTime, assetAudioPath: s, vibrate: v, enableNotificationOnKill: true, notificationTitle: t, notificationBody: b, stopOnNotificationOpen: false, loopAudio: true);
  }

  Future<void> soundPicked() async{
    final result = await Navigator.pushNamed(context, '/music');
    String audio = result.toString();
    setState(() {
     this.sound = audio;
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

  @override
  Widget build(BuildContext context) {
    isLightMode = Light(context);
    final arguments = (ModalRoute.of(context)?.settings.arguments?? <String, dynamic>{}) as Map;
    return Scaffold(
      backgroundColor: isLightMode ? Colors.grey[200] : Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            children: [
              SizedBox(
                height: 20,
              ),
              // Center(
              //   child: Text("${hour(this.selectedTime)}${selectedTime.hour.toString()} : ${minute(this.selectedTime)}${selectedTime.minute.toString()}",
              //     style: TextStyle(
              //       fontSize: 60,
              //       wordSpacing: 4
              //     ),
              //   ),
              // ),
              // TextButton(
              //     onPressed: (){},
              //     child: Text('Select Time',
              //           style: TextStyle(
              //             fontSize: 15,
              //             color: Colors.grey[700]
              //           ),
              //     )
              // ),
              Center(
                child: tomorrow? Text('Alarm will ring tomorrow') :  Text('Alarm will ring today')
              ),
              SizedBox(
                height: 10,
              ),
              TimePickerSpinner(
                is24HourMode: false,
                spacing: 40,
                highlightedTextStyle: TextStyle(
                        fontSize: 32.5,
                        wordSpacing: 4

                      ),
                normalTextStyle: TextStyle(
                    color: isLightMode ? Colors.grey[700] : Colors.grey[300],
                    fontSize: 17.5,
                    wordSpacing: 4

                ),
                onTimeChange: (time) {
                  if(time.isBefore(DateTime.now())){
                      tomorrow = true;
                  }
                  else{
                    tomorrow = false;
                  }
                  setState(() {
                    selectedTime = time;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(13, 10, 10, 10),
                child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [Text("Repeat Alarm on:",
                    style: TextStyle(
                      fontSize: 15
                    )
                    ),
                      SizedBox(width: 120),
                      Checkbox(
                          checkColor: isLightMode ? Colors.white : Colors.black,
                          value: this.isChecked,
                          onChanged: (value) {
                            setState(() {
                              this.isChecked = value;
                              values = everyday(value!);
                            });
                          }

                      ),
                      Text("Repeat Everyday",
                          style: TextStyle(
                            fontSize: 13,
                            color: isLightMode ? Colors.grey[800] : Colors.grey[200],
                          ),
                      )

                    ]
                ),
              ),
              WeekdaySelector(onChanged: (int day) {
                setState(() {
                  final index = day % 7;
                  values[index] = !values[index];
                });
              },
                  values: values,
                fillColor: isLightMode? Colors.white : Colors.grey[900],
                selectedColor: isLightMode ? Colors.white : Colors.black,
                selectedFillColor: isLightMode?  Color.fromRGBO(122,104,193, 1) : Color.fromRGBO(100,255,218, 1),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 3.0,
                shadowColor: isLightMode ? Colors.grey[800] : Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
                  child: TextField(
                    controller: NameControl,
                    decoration: InputDecoration(
                      hintText: "Alarm Name",
                      hintStyle: TextStyle(
                        fontSize: 15
                      ),

                      )
                    ),
                  )
                ),
              SizedBox(height: 5),
              Card(
                  elevation: 3.0,
                  shadowColor: isLightMode ? Colors.grey[800] : Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
                    child: TextField(
                        controller: bodyControl,
                        decoration: InputDecoration(
                          hintText: "Alarm Body",
                          hintStyle: TextStyle(
                              fontSize: 12.55
                          ),

                        )
                    ),
                  )
              ),
              SizedBox(height: 5),
              Card(
                elevation: 3.0,
                shadowColor: isLightMode ? Colors.grey[800] : Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                              color: Color(0x7A68C1)
                            )
                          )
                        ),
                        child: this.sound == ''? Text('Select Audio',style: TextStyle(color: isLightMode ? Color.fromRGBO(122, 104, 193, 1): Color.fromRGBO(100, 255, 218, 1))  ,) : Text(this.sound, style: TextStyle(color: isLightMode ? Color.fromRGBO(122, 104, 193, 1): Color.fromRGBO(100, 255, 218, 1))) != null ? Text(this.sound,style: TextStyle(color: isLightMode ? Color.fromRGBO(122, 104, 193, 1): Color.fromRGBO(100, 255, 218, 1)),) : Text("sounds/default.wav",style: TextStyle(color: isLightMode ? Color.fromRGBO(122, 104, 193, 1): Color.fromRGBO(100, 255, 218, 1)),),
                        onPressed: () {
                          soundPicked();
                        }
                      ),
                    ),

                  )
                ),
              ),
              SizedBox(height: 5),
              Card(
                elevation: 3.0,
                shadowColor: isLightMode ? Colors.grey[800] : Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Vibration"),

                      Switch(value: vibrate, onChanged: (value){
                        setState(() {
                          vibrate = value;
                        });
                      })
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: TextButton(onPressed: (){
                  Navigator.pop(context);
                },
                    child: Text('Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15.0,
                      letterSpacing: 1.25,
                    )
                    )
                    ),
              ),
              VerticalDivider(
                color: Colors.grey[350],
                thickness: 1,
              ),
              Expanded(
                flex: 1,
                child: TextButton(onPressed: (){
                    setState(() {
                      this.title = NameControl.text;
                      this.body = bodyControl.text;
                      this.a = createAlarm(++arguments['alarm_no'], this.vibrate, this.title, this.body, this.sound);
                      Map<String,dynamic> data = {"Alarm": a, "Repeat": values};
                      Navigator.pop(context,data);
                    });
                },
                    child: Text('Save',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15.0,
                          letterSpacing: 1.25,
                        ) )
                    ),
              )
            ],
          ),
        ),
        elevation: 4.0,
      ),
    );
  }
}

