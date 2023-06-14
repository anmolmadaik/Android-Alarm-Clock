import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

class Music extends StatefulWidget {
  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {

  String selectedmusic= "sounds/default.wav";
  List<FileSystemEntity> musiclist = [];

  Directory findRoot(Directory entity) {
    final Directory parent = entity.parent;
    if (parent.path == entity.path) return parent;
    return findRoot(parent);
  }


  List<FileSystemEntity> getMusic(){
    Directory dir = Directory('/storage/emulated/0');

    if(dir.existsSync()) {
      String mp3path = dir.toString();
      //print(mp3path);
      print("Directory ${mp3path} exists");
      List<FileSystemEntity> home = dir.listSync(recursive: false, followLinks: false);
      List<FileSystemEntity> songs = [];
      //print(home);
      for (FileSystemEntity e in home) {
        if (e.path == '/storage/emulated/0/Android') {
          Directory And = e as Directory;
          List<FileSystemEntity> Andd = And.listSync(
              recursive: false, followLinks: false);
          //print(Andd);
          for (FileSystemEntity a in Andd) {
            if (a.path == '/storage/emulated/0/Android/data' ||
                a.path == '/storage/emulated/0/Android/obb') {
              continue;
            }
            else {
              if (a is File) {
                String path = a.path;
                if (path.endsWith('.mp3')) {
                  songs.add(a);
                }
              }
              else if (a is Directory) {
                List<FileSystemEntity> files = a.listSync(
                    recursive: true, followLinks: false);
                // print(files);
                for (FileSystemEntity f in files) {
                  String path = f.path;
                  if (path.endsWith('.mp3') || path.endsWith('.m4a') || path.endsWith('.flac') || path.endsWith('.wav') || path.endsWith('.wma') || path.endsWith('.aac') || path.endsWith('.ogg')) {
                    songs.add(f);
                  }
                }
              }
            }
          }
        }
        else {
          if (e is File) {
            String path = e.path;
            if (path.endsWith('.mp3') || path.endsWith('.m4a') || path.endsWith('.flac') || path.endsWith('.wav') || path.endsWith('.wma') || path.endsWith('.aac') || path.endsWith('.ogg')) {
              songs.add(e);
            }
          }
          else if (e is Directory) {
            List<FileSystemEntity> files = e.listSync(
                recursive: true, followLinks: false);
            // print(files);
            for (FileSystemEntity f in files) {
              String path = f.path;
              if (path.endsWith('.mp3') || path.endsWith('.m4a') || path.endsWith('.flac') || path.endsWith('.wav') || path.endsWith('.wma') || path.endsWith('.aac') || path.endsWith('.ogg')) {
                songs.add(f);
              }
            }
          }
        }
        // for(FileSystemEntity entity in files){
        //   String path = entity.path;
        //   if(path.endsWith('.mp3')){
        //     songs.add(entity);
        //   }
        // }
      }
      return songs;
    }
    else{
      print("Unable to find required directory");
      return [];
    }
  }



  int returnLength(){
    this.musiclist = getMusic();
    return musiclist.length;
  }

  void reqStorage() async{
    PermissionStatus storage = await Permission.storage.request();
    if(storage == PermissionStatus.granted){
      print('Permission granted');
    }
    else if(storage == PermissionStatus.denied){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Require storage permission to change alarm sounds")));
    }
    else if(storage == PermissionStatus.permanentlyDenied){
      openAppSettings();
    }
  }

  Future<String> createFiles(FileSystemEntity f) async{
    Directory dd = Directory("sounds/");
    var file = File(p.join(dd.path,"selectedaudio.mp3"));
    Uint8List bytes = await File(f.path).readAsBytes();
    file.writeAsBytes(bytes);
    return file.path;
  }

  bool playing = false;
  final player = AudioPlayer();

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
    reqStorage();
  }

  @override
  Widget build(BuildContext context) {
    bool isLightMode = Light(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Select Song"),
      ),
      body: ListView.builder(
          itemCount: returnLength(),
          itemBuilder: (context, index){
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(
                            TextStyle(
                                color: Color(0x7A68C1)
                            )
                        )
                    ),
                    child: Text(p.basename(musiclist[index].path),style: TextStyle(color: isLightMode ? Color.fromRGBO(122, 104, 193, 1): Color.fromRGBO(100, 255, 218, 1)),),
                    onPressed: () async{
                        String path = await createFiles(musiclist[index]);
                        print(path);
                        Navigator.pop(context,path);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(Icons.play_circle_outline_outlined),
                          onPressed: () async{
                            final duration = await player.setUrl(musiclist[index].path);
                            player.play();

                          },
                      ),
                      IconButton(
                        icon: Icon(Icons.pause_circle_outline_outlined),
                        onPressed: () async{
                          await player.pause();
                        },
                      )
                    ],
                  ),

                ],
              )
            );
          }
      )
    );
  }
}
