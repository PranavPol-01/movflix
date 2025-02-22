
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movflix/widgets/header_widget.dart';
import 'sign_in_page.dart';
import 'package:movflix/screens/homescreen.dart';
import 'package:movflix/widgets/bottom_bar_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isCheck = false;
  String _errorMessage = "";
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // Check if the user already exists in Firestore
      var existingUser = await _firestore
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      if (existingUser.docs.isNotEmpty) {
        setState(() {
          _errorMessage = "User already exists. Please log in.";
          _isLoading = false;
        });
        return;
      }

      // Create user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Store user details in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text.trim(),
        'password':_passwordController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Navigate to Home Page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );

    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "Error signing up";
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
          SizedBox(height: 19),
          Text(
            "Sign up to start your\nmembership.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "Create your account",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: InputBorder.none,
                labelStyle: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: InputBorder.none,
                labelStyle: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Checkbox(
                value: _isCheck,
                onChanged: (value) {
                  setState(() {
                    _isCheck = value ?? false;
                  });
                },
              ),
              Text("Please do not email me Netflix special offers."),
            ],
          ),
          SizedBox(height: 15),
          InkWell(
            onTap: _signUp,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 15),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey[600] ?? Colors.grey, width: 2),
              ),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text("Sign Up"),
            ),
          ),
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInPage()));
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
