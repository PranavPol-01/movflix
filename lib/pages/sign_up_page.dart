import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movflix/widgets/header_widget.dart';
import 'sign_in_page.dart';
import 'package:movflix/screens/homescreen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isCheck=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            HeaderWidget(),
            _formWidget(),
          ],
        ),
      ),
    );
  }

  Widget _formWidget() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            height: 19,
          ),
          Text(
            "Sign up to start your\nmembership.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(
            height: 10,
          ),
          Text(
            "Create your account",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
              decoration: InputDecoration(
                labelText: "Email",
                border: InputBorder.none,
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
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
                labelText: "Password",
                border: InputBorder.none,
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Checkbox(
                value: _isCheck,
                onChanged: (value) {
                  setState(() {
                    _isCheck = value ?? false; // ✅ Ensures non-null value
                  });
                },

              ),
              Text("Please do not email me Netflix special offers.")
            ],
          ),
          SizedBox(height: 15,),
          InkWell(
            onTap: () {
              // Navigate to Home Page and remove all previous routes (SignInPage)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                    (route) => false, // Remove all previous routes from the stack
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
              child: Text("Sign Up"),
            ),
          ),
          SizedBox(height: 15,),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
            child: Text(
              "Already have an account? Sign in.",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}