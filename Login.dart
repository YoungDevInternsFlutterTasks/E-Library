import 'package:ebookslibrary/screens/login/loginform.dart';
import 'package:flutter/material.dart';

class OurLogin extends StatelessWidget {
  const OurLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(40),
                child: Container(
                    height: 200, child: Image.asset('assets/image.jpg')),
              ),
              SizedBox(
                height: 20,
              ),
              OurLoginForm(),
            ],
          ))
        ],
      ),
    );
  }
}
