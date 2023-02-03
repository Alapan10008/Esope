import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:escope/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Audioplayerscreen extends StatefulWidget {

  String new_filename="";
  String new_username="";
  String new_userage="";
  String audio_url="";
  String new_response="";
  String new_gender="";


  Audioplayerscreen({
    Key?key,
    required this.new_filename, required  this.new_username, required this.audio_url, required this.new_userage,required this.new_response,required this.new_gender,
  }):super(key:key);

  @override
  _AudioplayerscreenState createState() => _AudioplayerscreenState();
}

class _AudioplayerscreenState extends State<Audioplayerscreen>{

  final audioPlayer = AudioPlayer();
  bool idPlaying =false;
  Duration duration = Duration.zero;
  Duration position =Duration.zero;

  @override
  void initState(){
    super.initState();

    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState((){
        idPlaying=state==PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuartion) {
      setState((){
        duration =newDuartion;
      });
      audioPlayer.onAudioPositionChanged.listen((newPosition) {
        setState((){
          position =newPosition;
        });
      });
    });

  }
  @override
  void dispose(){
    audioPlayer.dispose();
    super.dispose();
  }
  String formatTime(Duration duration){

    String twoDigits(int n)=> n.toString().padLeft(2,'0');
    final hours =twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if(duration.inHours>0)hours,
      minutes,
      seconds,
    ].join(':');
  }
  Future setAudio()async{
    audioPlayer.setReleaseMode(ReleaseMode.LOOP);
    audioPlayer.setUrl(widget.audio_url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Color.fromARGB(255, 245, 197, 190),
          leading: IconButton(icon: Icon(Icons.arrow_back),
              onPressed: ()
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                      HomeScreen()));
              }
          )
      ),
      body :Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:  BorderRadius.circular(20),
              child: Image.asset("assets/images/logo.png",
              width: double.infinity,
              height: 300,
              fit : BoxFit.cover),

            ),
            SizedBox(height: 5,),
            Text(widget.new_username,
              style: GoogleFonts.montserrat(
                  fontSize: 40,
                color: Color.fromARGB(255, 245, 197, 190),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              alignment: Alignment.centerLeft,
              child: Text("${widget.new_response}",
                style: GoogleFonts.montserrat(
                    color: Color.fromARGB(255, 245, 197, 190),
                    fontSize: 20),),
            ),
            SizedBox(height: 10,),
            Container(
              alignment: Alignment.centerLeft,
              child: Text("Gender: ${widget.new_gender}",
                style: GoogleFonts.montserrat(
                    color: Color.fromARGB(255, 245, 197, 190),
                    fontSize: 20),),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Age: ${widget.new_userage}",
                    style: GoogleFonts.montserrat(
                        color: Color.fromARGB(255, 245, 197, 190),
                        fontSize: 20),),
                ),

                Container(
                  alignment:  Alignment.topRight,
                  child: FloatingActionButton.extended(
                      backgroundColor: Color.fromARGB(255, 245, 197, 190),
                      foregroundColor: Colors.white,
                      icon: Icon(Icons.share,size: 20,),
                      label:  const Text("Share"),
                      onPressed: () async{
                        final audiourl= widget.audio_url;
                        final url =Uri.parse(audiourl);
                        final response =await  http.get(url);
                        final bytes = response.bodyBytes;
                        final temp =await getTemporaryDirectory();
                        final path ='${temp.path}/${widget.new_filename}.wav';
                        File(path).writeAsBytes(bytes);
                        Share.shareFiles([path],text: "Name: "+widget.new_username);
                      }
                  ),
                ),

              ],
            ),





            SizedBox(height: 10,),

            SliderTheme(
              data: SliderThemeData(
                thumbColor: Color.fromARGB(255, 255, 149, 137),
                activeTrackColor: Color.fromARGB(255, 245, 197, 190),
                activeTickMarkColor: Color.fromARGB(237, 245, 154, 141),
                inactiveTrackColor: Color.fromRGBO(245,197, 190, 0.7),
              ),


              child: Slider(
                min :0,
                max : duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                divisions: 100,

                onChanged: (value)async{
                  position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);

                },

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration -position)),

                ],
              ),
            ),

                  Container(
                    alignment: Alignment.center,
                    child: FloatingActionButton.extended(
                              backgroundColor: Color.fromARGB(255, 245, 197, 190),
                              foregroundColor: Colors.white,
                              icon: Icon(idPlaying ? Icons.pause : Icons.play_arrow,),
                              label:  Text(idPlaying? "Pause": "Play"),
                              onPressed: () async{
                              if(idPlaying){
                              await audioPlayer.pause();}
                              else{
                              await audioPlayer.resume();
                            }
    }
    ),
                  ),




          ],
        ),
      ),
    );
  }

}

