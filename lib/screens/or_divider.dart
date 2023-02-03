import 'package:flutter/material.dart';

// import 'package:flutter_auth/constants.dart';

Container orDivider(BuildContext context, String title ){

  return Container(
    margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
    width: MediaQuery.of(context).size.width*0.9,
    child: Row(
      children: <Widget>[
        buildDivider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: TextStyle(
              color: Color.fromARGB(100, 0, 0, 0),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        buildDivider(),
      ],
    ),
  );
}


  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }

