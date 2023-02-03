import 'dart:convert';
import 'package:escope/screens/setfilename.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'upload.dart';


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


