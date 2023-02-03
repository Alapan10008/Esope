import 'dart:ui';
import 'package:escope/screens/auduioplayer.dart';
import 'package:escope/screens/setfilename.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Userdatacard extends StatelessWidget{
  final Userdata _data;
  Userdatacard(this._data);


  @override
  Widget build(BuildContext context){
    return 
      InkWell(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                 Audioplayerscreen(new_filename: _data.filename.toString(), new_username: _data.name.toString(), audio_url: _data.downurl.toString(), new_userage: _data.age.toString(),new_response: _data.response.toString(),new_gender: _data.gender.toString(),)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child:
          BackdropFilter(
            filter:ImageFilter.blur(
              sigmaX: 16.0,
              sigmaY: 16.0,
            ),
            child: Container(
            height: 80,
            margin: EdgeInsets.fromLTRB(8, 25, 8, 12),
            decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 2,color: Colors.grey.shade200.withOpacity(0.3))
            ),
            child:
            Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 5, 5),
              child:  Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text("${_data.name}",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color.fromARGB(171, 0, 0, 0),
                            letterSpacing:1.5,

                          ),
                        )),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Gender: ${_data.gender}  Age:${_data.age}" ,style:TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(237, 2, 0, 0)
                      ),),
                      Spacer(),
                      Text("Date: ${_data.day}/${_data.month}/${_data.year}",
                          style:TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(237, 0, 0, 0)
                          ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    ),
          ),
        ),
      );
  }

}
