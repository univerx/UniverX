import 'package:univerx/models/class.dart';

const String version_number = 'v1.0.3';

// create class for time with setter and getter with Datetime
class CurrentTime{
  DateTime _time = DateTime.now();
  //DateTime _time = DateTime(2024,09,02,8,40);

  DateTime get_time(){
    updateTime();
    return _time;
  }


  // update time with datetime.now
  void updateTime(){
    _time = DateTime.now();
    //_time = DateTime(2024,09,02,8,40);
  }
}


//final DateTime set_time = DateTime.now();
