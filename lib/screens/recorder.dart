import 'dart:async';
import 'package:escope/screens/setfilename.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:io';
import 'package:escope/screens/upload.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'auduioplayer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:loading_animation_widget/loading_animation_widget.dart';





String filepath="";
bool processing=false;

class RecorderScreen extends StatefulWidget {

  String new_gender="";
  String new_name="";
  String new_age="";

  RecorderScreen({
    Key?key,
    required this.new_name, required  this.new_gender, required this.new_age
  }):super(key:key);

  @override
  _RecorderScreenState createState() => _RecorderScreenState();

}




class _RecorderScreenState extends State<RecorderScreen> {

  bool _isRecording = false;


  StreamSubscription<NoiseReading>? _noiseSubscription;
  late NoiseMeter _noiseMeter;
  double? maxDB;
  double? meanDB;
  List<_ChartData> chartData = <_ChartData>[];
  // ChartSeriesController? _chartSeriesController;
  late int previousMillis;
  final firebase_storage.FirebaseStorage storage= firebase_storage.FirebaseStorage.instance;



  Future sendRequest(String s_forapi,String filename_forapi) async {

    Map data = {
      "name": filename_forapi,
      "url": s_forapi,
    };
    var body = json.encode(data);
    var url = "http://alapan.pythonanywhere.com/predict";
    var response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    var x=response.body.toString();
    global_response=x;
    return x;
  }

  uploadFile(String filePath,String fileName)async{

    File file =File(filePath);
    firebase_storage.Reference ref =storage.ref('files/$fileName');
    await storage.ref('files/$fileName').putFile(file);
    print("uploaded");
    global_downurl=await ref.getDownloadURL();
    String downurl = await ref.getDownloadURL();
    print(downurl);
    await sendRequest(downurl, global_name+global_Datetime);
    creatUserdata(downurl: downurl);
    print("cpmpleted API");

  }



  Future creatUserdata ({ required String downurl}) async{
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final json ={
      'name':global_name,
      'age':global_age,
      'downurl': downurl,
      'day':global_Day,
      'month':global_Month,
      'year':global_Year,
      'DateTime':global_Datetime,
      'gender':global_gender,
      'response':global_response,
    };

    final docuser =await FirebaseFirestore.instance.collection('Userdata').doc(uid).collection("testdata").add(json);

  }




  void onData(NoiseReading noiseReading) {
    setState(() {
      if (!this._isRecording) this._isRecording = true;
    });
    maxDB = noiseReading.maxDecibel;
    meanDB = noiseReading.meanDecibel;

    chartData.add(
      _ChartData(
        maxDB,
        meanDB,
        ((DateTime.now().millisecondsSinceEpoch - previousMillis) / 1000)
            .toDouble(),
      ),
    );
  }

  void onError(Object e) {
    print(e.toString());
    _isRecording = false;
  }

  void start() async {
    previousMillis = DateTime.now().millisecondsSinceEpoch;
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } catch (e) {
      print(e);
    }
  }

  void stop() async {
    try {
      _noiseSubscription!.cancel();
      _noiseSubscription = null;

      setState(() => this._isRecording = false);
    } catch (e) {
      print('stopRecorder error: $e');
    }
    previousMillis = 0;
    chartData.clear();
  }

  void copyValue(
      bool theme,
      ) {
    Clipboard.setData(
      ClipboardData(
          text: 'It\'s about ${maxDB!.toStringAsFixed(1)}dB loudness'),
    ).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 2500),
          content: Row(
            children: [
              Icon(
                Icons.check,
                size: 14,
                color: theme ? Colors.white70 : Colors.black,
              ),
              SizedBox(width: 10),
              Text('Copied')
            ],
          ),
        ),
      );
    });
  }

  final recorder =SoundRecorder();
  double? frequency;
  String? note;
  int? octave;
  bool? isRecording;

  @override
  void initState(){
    super.initState();
    recorder.init();
    _noiseMeter = NoiseMeter(onError);
  }
  @override
  void dispose(){
    super.dispose();
    recorder.dispose();
  }
  Duration duration=Duration();

  int minutes=00;
  int seconds =00;

  Timer? timer;
  void reset() =>setState(() =>duration=Duration());
  void startTimer({bool resets=true}){
    if(!mounted)return;
    if(resets){
      reset();
    }
    timer=Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds>58) {
        setState(()=>{minutes++,seconds=0,});
      }
      else {setState(()=>seconds++);

      }

    },
    );
  }
  void stopTimer({bool resets=true}){
    if(!mounted)return;
    if(resets){
      reset();
    }
    setState(() => timer?.cancel());

  }

  @override
  Widget build(BuildContext context) {
    if (chartData.length >= 25) {
      chartData.removeAt(0);
    }

    final isRecording= recorder.isRecording;

    final icon= isRecording ?Icons.stop:Icons.mic;

    final text=isRecording?'${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}':'START';



    return Scaffold(
      extendBodyBehindAppBar: true,

      body:

      Container(
        margin: const EdgeInsets.fromLTRB(0, 300, 5, 10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Visibility(
              visible: processing,
                child:
                Center(
                    child:
                    Column(
                      children: [
                        LoadingAnimationWidget.staggeredDotsWave(
                          size: 100,
                          color: const Color.fromARGB(255, 245, 197, 190),
                        ),
                        const Text("Processing...",),
                      ],

                    ),
                )),
            Visibility(
              visible: APIstate,
              child: Container(
                alignment: Alignment.center,
                child: FloatingActionButton.extended(
                  backgroundColor: Color.fromARGB(255, 245, 197, 190),
                  foregroundColor: Colors.white,
                  icon: Icon(Icons.monitor_heart),
                  label:
                  Text("Result"),
                  onPressed: ()
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                            Audioplayerscreen(new_filename: global_name, new_username: global_name, audio_url: global_downurl, new_userage: global_age, new_response: global_response,new_gender: global_gender,)));
                },
                ),


              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.2,
              alignment: Alignment.topCenter,
              child: Expanded(
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  enableAxisAnimation: true,
                  primaryXAxis: NumericAxis(
                    isVisible: false,
                    majorGridLines: MajorGridLines(width: 0),
                    axisLine: AxisLine(width: 0),

                  ),

                  primaryYAxis: NumericAxis(
                      maximum: 100,
                      minimum: 10,
                      isVisible: false,
                      majorGridLines: MajorGridLines(width: 0),
                      axisLine: AxisLine(width: 0)

                  ),

                  series: <LineSeries<_ChartData, double>>[
                    LineSeries<_ChartData, double>(
                        animationDelay: 2000,
                        dataSource: chartData,
                        xAxisName: 'Time',
                        yAxisName: 'dB',
                        name: 'dB values over time',
                        xValueMapper: (_ChartData value, _) => value.frames,
                        yValueMapper: (_ChartData value, _) => value.maxDB,
                        animationDuration: 0),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 68,
            ),
          ],
        ),
      ),

      floatingActionButton:
      Container(
        margin: EdgeInsets.fromLTRB(30, 10, 10, 10),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(

              margin: EdgeInsets.fromLTRB(3, 10, 5, 10),
              padding:EdgeInsets.fromLTRB(0, 10, 5, 10),

              child: FloatingActionButton.extended(
                backgroundColor: Color.fromARGB(255, 245, 197, 190),
                foregroundColor: Colors.white,
                label: Text(_isRecording ? 'Stop Tuning' : 'Tuning'),
                onPressed: _isRecording ? stop : start,
                icon: !_isRecording ? Icon(Icons.circle) : Icon(Icons.stop_circle),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(3, 10, 5, 10),
              padding:EdgeInsets.fromLTRB(0, 10, 5, 10),

              child: FloatingActionButton.extended(
                backgroundColor: Color.fromARGB(255, 245, 197, 190),
                foregroundColor: Colors.white,
                icon: Icon(icon),
                label:
                Text(text), onPressed: () async {

                setState((){
                  _isRecording ?
                   stop : start;
                  recorder.new_gender=widget.new_gender;
                  recorder.new_name=widget.new_name;
                  recorder.new_age=widget.new_age;
                });
                await recorder.toggleRecording();
                final theRecording =recorder.isRecording;

                if(theRecording){
                  startTimer();
                }
                else {
                  stopTimer();
                }


              },
              ),
            ),
          ],
        ),
      ),

    );

  }

}

class _ChartData {
  final double? maxDB;
  final double? meanDB;
  final double frames;

  _ChartData(this.maxDB, this.meanDB, this.frames);
}


class SoundRecorder {

  String new_gender=global_gender;
  String new_name=global_name;
  String new_age=global_age;

  FlutterSoundRecorder?_audioRecorder;
  bool _isRecorderInitialised=false;
  bool get isRecording  =>_audioRecorder!.isRecording;
  final Storage storage =Storage();


  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted){
      throw RecordingPermissionException('Microphone permission denied');
    }
    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised=true;

  }



  void dispose(){
    _audioRecorder!.closeAudioSession();
    _audioRecorder=null;
    _isRecorderInitialised=false;
  }



  Future _record() async {
    Directory directory = await getApplicationDocumentsDirectory();
    filepath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.wav';
    print(filepath);

    if(!_isRecorderInitialised)return;
    await _audioRecorder!.startRecorder(toFile: filepath);
    print("started Recording");
  }

  Future _stop() async {
    await _audioRecorder!.stopRecorder();
    print("stoped recording");
    processing=true;
    await storage.uploadFile(filepath,new_name);
    processing=false;
    APIstate=true;
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    }
    else {
      await _stop();
      print("complete stop");
      final Storage storage =Storage();

    }
  }

}