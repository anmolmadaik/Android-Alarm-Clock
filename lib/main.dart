import 'package:flutter/material.dart';
import 'home.dart';
import 'add.dart';
import 'music.dart';
import 'ringingScreen.dart';

Map<int, Color> color = {
   50:Color.fromRGBO(122,104,193, .1),
  100:Color.fromRGBO(122,104,193, .2),
  200:Color.fromRGBO(122,104,193, .3),
  300:Color.fromRGBO(122,104,193, .4),
  400:Color.fromRGBO(122,104,193, .5),
  500:Color.fromRGBO(122,104,193, .6),
  600:Color.fromRGBO(122,104,193, .7),
  700:Color.fromRGBO(122,104,193, .8),
  800:Color.fromRGBO(122,104,193, .9),
  900:Color.fromRGBO(122,104,193, 1),
};

void main() {
  runApp(MaterialApp(
    title: "Alarm Clock",
    themeMode: ThemeMode.system,
    theme: ThemeData(
      primarySwatch: MaterialColor(0x7A68C1,color),
      brightness: Brightness.light,
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.white
      ),
    ),
    darkTheme: ThemeData(
      primarySwatch: MaterialColor(0x7A68C1,color),
      brightness: Brightness.dark,
      bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.black,
      ),
      cardTheme: CardTheme(
        color: Colors.grey[900],
        elevation: 2,
    )
    ),
    routes: {
      '/': (context) => Home(),
      '/add': (context) => Add(),
      '/music': (context) => Music(),
      '/ringing': (context) => Ringing()
    },
  ));
}

