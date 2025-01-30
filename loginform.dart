import 'package:ebookslibrary/screens/Home/HomeScreen.dart';
import 'package:ebookslibrary/screens/SignUp/SignUp.dart';
import 'package:ebookslibrary/states/currentUser.dart';
import 'package:ebookslibrary/utils/OurTheme.dart';
import 'package:ebookslibrary/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurLoginForm extends StatefulWidget {
  const OurLoginForm({super.key});

  @override
  State<OurLoginForm> createState() => _OurLoginFormState();
}

class _OurLoginFormState extends State<OurLoginForm> {
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();

  void _LoginUser(String email, String password, BuildContext context) async {
    Currentuser _currentUser = Provider.of<Currentuser>(context, listen: false);

    try {
      String _returnString =
          await _currentUser.LoginUserWithEmail(email, password);
      if (_returnString == "success") {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            _returnString,
          ),
          duration: Duration(seconds: 3),
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final OurTheme theme = OurTheme();
    return OurContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Log In',
              style: TextStyle(
                  color: Theme.of(context).canvasColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            controller: _EmailController,
            decoration: theme.inputDecoration(context).copyWith(
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _PasswordController,
            decoration: theme.inputDecoration(context).copyWith(
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              _LoginUser(
                  _EmailController.text, _PasswordController.text, context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).canvasColor),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                'Log In',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => OurSignUp()));
            },
            child: Text(
              "Dont have an account? Sign Up here ",
              style: TextStyle(color: Theme.of(context).canvasColor),
            ),
          ),
        ],
      ),
    );
  }
}
