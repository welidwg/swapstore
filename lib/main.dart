import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/screens/cart_screen.dart';

import 'package:swap_store/screens/chat_screen.dart';
import 'package:swap_store/screens/fullscreen_image.dart';
import 'package:swap_store/screens/home.dart';
import 'package:swap_store/screens/login_screen.dart';
import 'package:swap_store/screens/main_screen.dart';
import 'package:swap_store/screens/product_screen.dart';
import 'package:swap_store/screens/registration_screen.dart';
import 'package:swap_store/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(SwapStore());
}

class SwapStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
          canvasColor: Colors.white,
          textTheme: TextTheme(
            bodyMedium: GoogleFonts.adventPro(
              textStyle: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: GoogleFonts.adventPro(),
            hintStyle: GoogleFonts.adventPro(),
          )),
      home: const WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        CartScreen().id: (context) => CartScreen(),
        RegistrationScreen().id: (context) => RegistrationScreen(),
        ChatScreen().id: (context) => ChatScreen(),
        MainScreen().id: (context) => MainScreen(),
        ProductScreen().id: (context) => ProductScreen(),
        WelcomeScreen.id: (context) => const WelcomeScreen(),
      },
    );
  }
}
