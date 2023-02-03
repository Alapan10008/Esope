import 'package:audioplayers/audioplayers.dart';


String global_gender="";
String global_name="";
String global_age="";
String global_Datetime="";
String global_Year="";
String global_Month="";
String global_Day="";
String global_response="";
String global_downurl="";
bool APIstate=false;

class Userdata{
  String? gender;
  String? response;
  String? filename;
  String? name;
  String? age;
  String? Datetime;
  String? year;
  String? month;
  String? day;
  String? downurl;

  Userdata();
  Map<String,dynamic> toJson() =>{'filename':name,'name':name,'age':age,'DateTime':DateTime,'year':year,'month':month,'day':day,'downurl':downurl,'gender':gender,'response':response};
  Userdata.fromSnapshot(snapshot)
     : filename=snapshot.data()['filename'],
        name=snapshot.data()['name'],
        age=snapshot.data()['age'],
        Datetime =snapshot.data()['DateTime'],
        year=snapshot.data()['year'],
        month=snapshot.data()['month'],
        day=snapshot.data()['day'],
        downurl=snapshot.data()['downurl'],
        gender=snapshot.data()['gender'],
        response=snapshot.data()['response'];
}

String formatTime(Duration duration){
  String twoDigits(int n)=> n.toString().padLeft(2,'0');
  final hours =twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inMinutes.remainder(60));
  return [
    if(duration.inHours>0)hours,
    minutes,
    seconds,
  ].join(':');
}
