import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:escope/screens/APIcall.dart';
import 'package:escope/screens/Menubar.dart';
import 'package:escope/screens/UserdataCard.dart';
import 'package:escope/screens/body_model.dart';
import 'package:escope/screens/searchbar.dart';
import 'package:escope/screens/setfilename.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import 'navbar.dart';

const  List<String> list = <String>['One', 'Two', 'Three', 'Four'];
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  String gender="male";
  String name = "";
  String age = "";
  String radioButtonItem = 'ONE';
  int id = 1;
  List<Object> _userdata=[];

  String dropdownValue = list.first;

  Future getUserdataList() async{
    final uid = FirebaseAuth.instance.currentUser?.uid;
    var data = await FirebaseFirestore.instance.collection('Userdata').doc(uid).collection('testdata').orderBy('DateTime',descending: true).get();
    setState((){
      _userdata=List.from(data.docs.map((doc) => Userdata.fromSnapshot(doc)));
    });
  }
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    getUserdataList();
  }
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color.fromARGB(255, 245, 197, 190),
        title: Center(
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover,
              height: 70,
              width: 70,
              color: Colors.black,)),
        actions: [
        AnimSearchBar(
          boxShadow: false,
        width: MediaQuery. of(context). size. width,
        textController: textController,
        textFieldColor: const Color.fromARGB(255, 245, 197, 190),
        color: const Color.fromARGB(255, 245, 197, 190),
        searchIconColor: Colors.white,
        textFieldIconColor: Colors.white,
        onSuffixTap: () {
          setState(() {
            textController.clear();
          });
        }, onSubmitted: (String ) {

        },
      ),
        ]
      ),
      drawer: NavDrawer(),
      body :
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child:
            Column(
              children:<Widget> [
                SizedBox(height: 0),
                Expanded(
                  child: ListView.builder(
                    itemCount: _userdata.length,
                      itemBuilder: (context,index){
                      return Userdatacard(_userdata[index] as Userdata);
                      }),
                ),
              ],
            ),
          ),

      floatingActionButton:
      Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: FloatingActionButton.extended(
          heroTag: "btn2",
          backgroundColor:  const Color.fromARGB(255, 245, 197, 190),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: Text('NEW ',
          style: GoogleFonts.montserrat(),),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: BackdropFilter(
                          filter:ImageFilter.blur(
                            sigmaX: 6.0,
                            sigmaY: 6.0,
                          ),

                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(0),
                              border: Border.all(width: 2,color: Colors.pinkAccent.withOpacity(0.1))
                          ),
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text("Patient Detail",
                              style: GoogleFonts.montserrat(fontSize: 24),),
                            content: SizedBox(
                              width: 0.8*MediaQuery. of(context). size. width,
                              height: 0.4*MediaQuery. of(context). size. height,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: const EdgeInsets.all(10),
                                    child: Text("Name",
                                      style: GoogleFonts.montserrat(fontSize: 20),),),
                                  TextField(
                                    controller: _nameTextController,
                                    cursorColor: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    style: const TextStyle(fontSize: 20, height: 1.5),
                                    decoration: textfielddecoration(),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: const EdgeInsets.all(10),
                                    child: Text("Gender",
                                      style: GoogleFonts.montserrat(fontSize: 20),),),

                                Container(
                                  margin: EdgeInsets.all(0),
                                  alignment: Alignment.bottomLeft,
                                  child:  RadioGroup(),
                                ),

                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    alignment: Alignment.bottomLeft, child: Text(
                                    "Age",
                                    style: GoogleFonts.montserrat(fontSize: 20),),),
                                  TextField(
                                    controller: _ageTextController,
                                    cursorColor: const Color.fromARGB(255, 245, 197, 190),
                                    style: const TextStyle(fontSize: 20, height: 1.5,),
                                    keyboardType: TextInputType.number,
                                    decoration: textfielddecoration(),

                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      name = _nameTextController.text;
                                      age = _ageTextController.text;
                                      global_gender=gender;
                                      DateTime now =DateTime.now();
                                      global_Datetime='$now';
                                      global_Year='${now.year}';
                                      global_Month ='${now.month}';
                                      global_Day='${now.day}';
                                      global_name=name;
                                      global_age=age;
                                      APIstate=false;

                                    });

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) =>
                                            bodymodelselecter()));
                                  },
                                  child: Text("ADD", style: GoogleFonts.montserrat(
                                    fontSize: 20, color: const Color.fromARGB(
                                      255, 245, 197, 190),),))
                            ],
                          ),
                        ),
                      ),
                    );
                }
            );
          },
        ),
      ),


    );
  }
}



class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class RadioGroup extends StatefulWidget {
  const RadioGroup({Key? key}) : super(key: key);

  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}

class RadioGroupWidget extends State {

  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'ONE';

  // Group Value for Radio Button.
  int id = 1;

  Widget build(BuildContext context) {
    return
      Container(
        alignment: Alignment.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: id,
              onChanged: (val) {
                setState(() {
                  radioButtonItem = 'Male';
                  id = 1;
                });
              },
            ),
            Icon(Icons.male),
            Radio(
              value: 2,
              groupValue: id,
              onChanged: (val) {
                setState(() {
                  radioButtonItem = 'TWO';
                  id = 2;
                });
              },
            ),
            Icon(Icons.female),

            Radio(
              value: 3,
              groupValue: id,
              onChanged: (val) {
                setState(() {
                  radioButtonItem = 'non-binary';
                  id = 3;
                });
              },
            ),
            Icon(Icons.transgender),
          ],
        ),
      );
  }
}




