import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 300,
    height: 300,

  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(

    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Color.fromARGB(255, 0, 0, 0),
    style: TextStyle(color:Color.fromARGB(255, 0, 0, 0),fontSize: 15),
    decoration: InputDecoration(
      fillColor: Colors.white,
      focusedBorder:OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromARGB(255, 245, 197, 190), width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      filled: true,

      prefixIcon: Icon(
        icon,
        color: Color.fromARGB(255, 245, 197, 190),
      ),
      labelText: text,
      labelStyle: TextStyle(color:  Color.fromARGB(255, 245, 197, 190),fontSize: 15),

      floatingLabelBehavior: FloatingLabelBehavior.never,

      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 10, style: BorderStyle.none,color: Colors.black,)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Color.fromARGB(255, 245, 197, 190);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

Container HomeScreenButton(BuildContext context, String title ,Function onTap){
  return  Container(

    margin: EdgeInsets.fromLTRB(15, 10,10, 10),
    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    width: MediaQuery.of(context).size.width*0.9,
    height: 100,

    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)
    ),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style:GoogleFonts.montserrat(
          textStyle: TextStyle(fontSize:20,color: Color.fromARGB(255, 5, 0, 0), letterSpacing: .5),
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Color.fromARGB(255, 245, 197, 190);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

InputDecoration textfielddecoration(){
  return
    InputDecoration(
      contentPadding:
      EdgeInsets.symmetric(vertical: 1, horizontal: 10),

   fillColor: Colors.white,

  focusedBorder:OutlineInputBorder(
  borderSide: const BorderSide(color: Color.fromARGB(255, 245, 197, 190), width: 2.0),
  borderRadius: BorderRadius.circular(10.0),
  ),
  filled: true,

  labelStyle: TextStyle(color:  Color.fromARGB(255, 245, 197, 190),fontSize: 25),

  floatingLabelBehavior: FloatingLabelBehavior.never,

  border: OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0),
  borderSide: const BorderSide(width: 10, style: BorderStyle.none,color: Colors.black,)),
  );
}
