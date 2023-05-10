import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:swap_store/components/Input.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/screens/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  final String id = "login_screen";
  final int index = 1;
  late bool? logged_in = false;
  late void Function(String) onButtonPressed;

  LoginScreen();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email = "";
  String password = "";
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: 200,
                      height: 270,
                      child: Lottie.network(
                          'https://assets1.lottiefiles.com/packages/lf20_mjlh3hcy.json',
                          repeat: false,
                          fit: BoxFit.contain),
                    ),
                  ),
                  const Center(
                      child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  )),
                  Input(label: "Your email", is_Password: false, onChange:  (value) {
                    //Do something with the user input.
                    email = value;
                  }),

                  const SizedBox(
                    height: 8.0,
                  ),
                  Input(label: "Your password", is_Password: true, onChange:  (value) {
                    //Do something with the user input.
                    password = value;
                  }),

                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Material(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      elevation: 5.0,
                      textStyle: TextStyle(color: Colors.white),
                      child: MaterialButton(
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {
                              // Navigator.pushNamed(context, ChatScreen().id);

                            }
                          } on FirebaseAuthException catch (e){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        },
                        minWidth: 200.0,
                        height: 42.0,
                        child: Text(
                          'Log In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
