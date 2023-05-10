import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:swap_store/components/Input.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Utilisateur.dart';
import 'package:swap_store/screens/chat_screen.dart';
import 'package:swap_store/screens/home.dart';
import 'package:swap_store/screens/login_screen.dart';
import 'package:swap_store/screens/main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  final String id = "register_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _controller = TextEditingController();
  String email = "";
  String password = "";
  String name = "";
  int phone = 0;

  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Form(
          child: ListView(
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
                        height: 150,
                        child: Lottie.network(
                            'https://assets1.lottiefiles.com/packages/lf20_ntdmh9RIUC.json',
                            repeat: false,
                            fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(
                      height: 22.0,
                    ),
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Create account",
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    )),
                    Input(
                        label: "You name",
                        is_Password: false,
                        onChange: (value) {
                          setState(() {
                            name = value;
                          });
                        }),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Input(
                        label: "Email",
                        is_Password: false,
                        onChange: (value) {
                          setState(() {
                            email = value;
                          });
                        }),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Input(
                        label: "Phone",
                        is_Password: false,
                        onChange: (value) {
                          setState(() {
                            phone = int.parse(value);
                          });
                        }),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Input(
                        label: "Password",
                        is_Password: true,
                        onChange: (value) {
                          setState(() {
                            password = (value);
                          });
                        }),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        color: kPrimaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30.0)),
                        elevation: 5.0,
                        child: MaterialButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              final new_user =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              if (new_user != null) {
                                Utilisateur user = Utilisateur(
                                    name: name,
                                    password: password,
                                    email: email,
                                    tel: phone,
                                    uid: new_user.user!.uid);
                                Map<String, dynamic> userData = user.toMap();
                                await usersCollection
                                    .add(userData)
                                    .whenComplete(() => {
                                          Alert(
                                            context: context,
                                            type: AlertType.success,
                                            title: "Done",
                                            desc: "Account successfully created",
                                          ).show()
                                        });
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
                          child: const Text(
                            'Register',
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
      ),
    );
  }
}
