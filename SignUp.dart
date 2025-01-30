import 'package:ebookslibrary/screens/SignUp/SignUpform.dart';
import 'package:flutter/material.dart';

class OurSignUp extends StatelessWidget {
  const OurSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(40),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30, right: 20), // Adjust padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 40, // Larger icon size
                      color: Colors.black, // Themed color
                      onPressed: () {
                        Navigator.pop(context); // Navigate back on press
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              OurSignUpForm(),
            ],
          ))
        ],
      ),
    );
  }
}
