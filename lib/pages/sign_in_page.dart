

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_up_page.dart';
import 'package:movflix/screens/homescreen.dart';
import 'package:movflix/widgets/bottom_bar_nav.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = "";
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Ensure user document exists before updating
        var userDoc = await _firestore.collection("users").doc(user.uid).get();
        if (userDoc.exists) {
          await _firestore.collection("users").doc(user.uid).update({
            "lastLogin": FieldValue.serverTimestamp(),
          });
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Error signing in";
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


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
              controller: _emailController,
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 14, color: Colors.white),
                border: InputBorder.none,
                labelText: "Email or phone number",
              ),
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
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 14, color: Colors.white),
                border: InputBorder.none,
                labelText: "Password",
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          InkWell(
            onTap: _isLoading ? null : _signIn,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 15),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: _isLoading ? Colors.grey : Colors.transparent,
                border: Border.all(
                    color: Colors.grey[600] ?? Colors.grey, width: 2),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Sign In"),
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
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
            style: TextStyle(
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
