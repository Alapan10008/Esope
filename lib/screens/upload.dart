import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escope/screens/APIcall.dart';
import 'package:escope/screens/setfilename.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;


class Storage{

  final firebase_storage.FirebaseStorage storage= firebase_storage.FirebaseStorage.instance;

    Future<void> uploadFile(String filePath,String fileName)async{
    File file =File(filePath);
    try{
       firebase_storage.Reference ref =storage.ref('files/$fileName');
       await storage.ref('files/$fileName').putFile(file);
       print("uploaded");
       global_downurl=await ref.getDownloadURL();
       String downurl = await ref.getDownloadURL();
       print(downurl);
       await sendRequest(downurl, global_name+global_Datetime);
       creatUserdata(downurl: downurl);
       print("cpmpleted API");
       APIstate=true;

    }on firebase_core.FirebaseException catch(e){
      print("Not Uploaded");
      print(e);
    }
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
}