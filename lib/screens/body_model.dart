import 'package:escope/screens/audiotypeslector.dart';
import 'package:flutter/material.dart';


class bodymodelselecter extends StatefulWidget {

  @override
  _bodymodelselecterState createState() => _bodymodelselecterState();
}
class _bodymodelselecterState extends State<bodymodelselecter> {
  String modelno='assets/models/male_front.png';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      body:
      Center(
        child:
        InkWell(
          onTap: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AudioTypeselector()));
          },
          child: Container(
            alignment: Alignment.bottomRight,
            margin:const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [
                    0.1,
                    0.4,
                    0.6,
                    0.9,
                  ],
                  colors: [
                    Color.fromARGB(255, 248, 148, 139),
                    Color.fromARGB(255, 245, 197, 190),
                    Color.fromARGB(255, 252, 252, 252),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                )
            ),
            child:
            Column(
              children: [
                Center(
                  child: Container(
                    padding:  const EdgeInsets.fromLTRB(0, 50, 0, 10),
                    height: 0.7*MediaQuery. of(context). size. height,
                    width: 0.8*MediaQuery. of(context). size. width,
                    child: Image.asset(modelno,fit: BoxFit.cover
                      ,),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration:  BoxDecoration(
                        border: Border.all(width: 5,color:Color.fromARGB(255, 245, 197, 190),),
                        borderRadius: BorderRadius.circular(10)


                      ),
                        child:ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child:
                      InkWell(
                          onTap :(){
                            modelno='assets/models/male_front.png';
                            setState(() {});
                          },
                          child: Image.asset('assets/models/male_front.png',fit: BoxFit.cover,)),
                    )
                    ),
                    Container(
                        height: 100,
                        width: 100,
                        decoration:  BoxDecoration(
                            border: Border.all(width: 5,color:Color.fromARGB(255, 245, 197, 190),),
                            borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child:
                          InkWell(
                              onTap :(){
                                modelno='assets/models/male_back.png';
                                setState(() {});
                              },
                              child: Image.asset('assets/models/male_back.png',fit: BoxFit.cover,)),
                        )
                    ),
                  ],

                )
              ],
            ),

          ),
        ),
      ),
    );
  }
}


