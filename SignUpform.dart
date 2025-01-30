import 'package:ebookslibrary/states/currentUser.dart';
import 'package:ebookslibrary/utils/OurTheme.dart';
import 'package:ebookslibrary/widgets/container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurSignUpForm extends StatefulWidget {
  const OurSignUpForm({super.key});

  @override
  State<OurSignUpForm> createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  TextEditingController _FullNameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();
  TextEditingController _ConfirmPasswordController = TextEditingController();

  void _signUpUser(String email, String password, BuildContext context) async {
    Currentuser _currentUser = Provider.of<Currentuser>(context, listen: false);

    try {
      String _returnString = await _currentUser.signUpUser(email, password);
      if (_returnString == "success") {
        Navigator.pop(context);
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
    return Center(
      // Centers the entire form
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: OurContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Shrinks to fit content
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontSize: 30, // Larger font size for emphasis
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: _FullNameController,
                decoration: theme.inputDecoration(context).copyWith(
                      hintText: "Full Name",
                      prefixIcon: Icon(
                        Icons.person_outlined,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
              ),
              SizedBox(
                height: 10,
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
              SizedBox(
                height: 10,
              ),
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
              SizedBox(height: 10),
              TextFormField(
                controller: _ConfirmPasswordController,
                decoration: theme.inputDecoration(context).copyWith(
                      hintText: "Confirm Password",
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
                  if (_PasswordController.text ==
                      _ConfirmPasswordController.text) {
                    _signUpUser(_EmailController.text, _PasswordController.text,
                        context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Password do not match",
                      ),
                      duration: Duration(seconds: 3),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).canvasColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: Size(200, 60), // Larger button
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 22, // Bigger font size
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
