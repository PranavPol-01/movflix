import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'sign_up_page.dart';
import 'package:movflix/screens/homescreen.dart';
import 'package:movflix/widgets/bottom_bar_nav.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            _headerWidget(),
            SizedBox(
              height: 10,
            ),
            _formWidget(),
          ],
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          height: 40,
          child: Image.asset('assets/logo.png'),
        )
      ],
    );
  }

  Widget _formWidget() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  labelText: "Email or phone number"),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                  labelText: "Password"),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: () {

              // Navigate to Home Page and remove all previous routes (SignInPage)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false, // Remove all previous routes from the stack
              );
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const BottomNavBar(),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 15),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey[600] ?? Colors.grey, width: 2),
              ),
              child: Text("Sign In"),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text("Need Help?"),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            child: Text(
              "New to Netflix? Sign up now.",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Sign-in is protected by Google reCAPTCHA to ensure you're not a bot. Learn more.",
            style: TextStyle(fontSize: 12,),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}