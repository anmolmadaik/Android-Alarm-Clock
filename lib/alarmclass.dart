import 'package:alarm/alarm.dart';

class AlarmClock{
    late Alarm alrm;
    late AlarmSettings aset;
    late List<bool> repeat;
    bool set = true;
    int checkRepeat(int index){
      int k = -1;
      int start = index+1;
      int end = index;
      while(start != end){
        if(this.repeat[start%7] == true){
          return start%7;
        }
        else{
          ++start;
          start%=7;
        }
      }
      return k;
    }

    AlarmClock(AlarmSettings a, List<bool> r){
      this.aset = a;
      this.repeat = r;
    }
}