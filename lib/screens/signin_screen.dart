import 'package:escope/screens/reset_password.dart';
import 'package:escope/screens/signup_screen.dart';
import 'package:escope/screens/social_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../reusable_widgets/reusable_widget.dart';
import '../services/firebase_auth_methods.dart';
import '../utils/color_utils.dart';
import 'home_screen.dart';
import 'or_divider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();


  void loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
      email: _emailTextController.text,
      password:_emailTextController.text,
      context: context,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexStringToColor("FFFFFF"),
          hexStringToColor("FFFFFF"),
          hexStringToColor("FFFFFF")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.09, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/logo.png"),
                const SizedBox(
                  height: 10,
                ),
                reusableTextField("Enter email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                forgetPassword(context),
                firebaseUIButton(context, "Sign In", loginUser),
                orDivider(context, 'Or sign In with'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SocalIcon(
                      iconSrc: "assets/icons/google.svg",
                      press: ()  async {
                       bool res = await context.read<FirebaseAuthMethods>().signInWithGoogle(context);
                       if (res) {
                         Navigator.push(context,
                             MaterialPageRoute(builder: (context) => HomeScreen()));
                       }
                      },
                    ),
                    SocalIcon(
                      iconSrc: "assets/icons/facebook.svg",
                      press: () async {
                       bool res = await context.read<FirebaseAuthMethods>().signInWithFacebook(context);
                       if (res) {
                         Navigator.push(context,
                             MaterialPageRoute(builder: (context) => HomeScreen()));
                       }
                      },
                    ),

                    SocalIcon(
                      iconSrc: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Color.fromARGB(100, 0, 0, 0),)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Color.fromARGB(255, 245, 197, 190), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomLeft,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Color.fromARGB(255, 245, 197, 190)),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}

