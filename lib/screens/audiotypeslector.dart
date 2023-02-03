import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escope/screens/home_screen.dart';
import 'package:escope/screens/recorder.dart';
import 'package:escope/screens/setfilename.dart';
import 'package:escope/screens/upload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class AudioTypeselector extends StatefulWidget {

  String new_gender=global_gender;
  String new_name=global_name;
  String new_age=global_age;


  @override
  _AudioTypeselectorState createState() => _AudioTypeselectorState();
}


class _AudioTypeselectorState extends State<AudioTypeselector> {


  PlatformFile?pickedFile;
  String songpath="";

  @override
  Widget build(BuildContext context) {
    final Storage storage =Storage();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        backgroundColor:  Color.fromARGB(255, 245, 197, 190),
        title: Center(
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover,height: 70,width: 70,color: Colors.black,)),
      ),

      body:
      Container(
        alignment: Alignment.bottomRight,
        margin:EdgeInsets.symmetric(horizontal: 10,vertical: 60),
        child:
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: Container(
                        width: 300,
                        height: 230,
                        child: Column(
                          children: [
                               Container(
                                 alignment: Alignment.topCenter,
                                 margin: EdgeInsets.all(20),
                                 child: FloatingActionButton.extended(

                                  backgroundColor: Color.fromARGB(255, 245, 197, 190),
                                  foregroundColor: Colors.white,
                                  icon: const Icon(Icons.mic),
                                  label: const Text('Record'),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            RecorderScreen(new_name: widget.new_name,new_gender: widget.new_gender,new_age: widget.new_age,)));
                                  }
                              ),
                               ),

                            Column(
                              children: [
                                Container(

                                  alignment: Alignment.bottomCenter,
                                  margin: EdgeInsets.all(20),
                                  child: FloatingActionButton.extended(
                                    backgroundColor: Color.fromARGB(255, 245, 197, 190),
                                    foregroundColor: Colors.white,
                                    icon: const Icon(Icons.upload),
                                    label: const Text('Upload'),
                                    onPressed: () async{
                                      final result =await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.audio);
                                      if(result==null){
                                        ScaffoldMessenger.of(context).showSnackBar
                                          (const SnackBar(content: Text('No File Selected')));
                                        return null;
                                      }
                                      final path=result.files.single.path;
                                      print((path));
                                       storage.uploadFile(path!,widget.new_name);
                                      setState(() {

                                      });

                                    },

                                  ),
                                ),
                                Container(
                                  alignment:  Alignment.center,
                                  margin: EdgeInsets.all(10),

                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
    ),
    );
  }
}

//
// // Future selectfile() async {
//   final result =await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.custom,allowedExtensions: ['wav']);
//   if(result==null)return;
//
//   setState(() {
//     pickedFile=result.files.first;
//   };
//   }
//
// Future uploadFile() async{
//   final here_filename =widget.new_filename;
//   if(pickedFile==null) return;
//   final destination ='file/$here_filename';
//   final file= File(pickedFile!.name!);
//   final ref =FirebaseStorage.instance.ref().child(destination);
//   ref.putFile(file);
//   final snapshot =await uploadTask!.whenComplete((){});
//
// }
//
