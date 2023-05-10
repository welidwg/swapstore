import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/Controllers/UserController.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Utilisateur.dart';
import 'package:swap_store/screens/cart_screen.dart';
import 'package:swap_store/screens/login_screen.dart';
import 'package:swap_store/screens/main_screen.dart';
import 'package:swap_store/screens/myexchanges_received.dart';
import 'package:swap_store/screens/myproduct_screen.dart';
import 'package:swap_store/screens/product_screen.dart';
import 'package:swap_store/screens/profile_screen.dart';
import 'package:swap_store/screens/registration_screen.dart';
import 'package:swap_store/screens/search_screen.dart';
import 'package:swap_store/screens/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  static String id = "home_screen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selected = 0;
  bool logged_in = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  late List<Widget> _widgetOptions = <Widget>[];
  final List<Widget> authWidget = <Widget>[
    MainScreen(), //0
    const MyProductsScreen(), //1
    CartScreen(), //2
    const ExchangesReceived(),
    const ProfileScreen()
  ];

  late List<PersistentBottomNavBarItem> currentItems = [];
  late AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = _auth.currentUser;

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        logged_in = user != null;
        if (logged_in) {
          _selected = 0;
        } else {
          _selected = 0;
        }
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selected = index;
      animationController.reset();
      animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Hero(
                              tag: "logo",
                              child: Image.asset("images/logo_main.png",
                                  height: 50)),
                          const Text(
                            "SwapStore",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19),
                          )
                        ]),
                        Row(
                          children: [
                            SizedBox(
                                width: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showMaterialModalBottomSheet(context: context, builder: (context){
                                      return SearchScreen();
                                    });
                                  },
                                  style: ButtonStyle(
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero),
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.transparent)),
                                  child: Lottie.network("https://assets3.lottiefiles.com/packages/lf20_LKXG6QRgtE.json",height: 50),
                                )),
                            logged_in
                                ? SizedBox(
                                    width: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _auth.signOut();
                                        setState(() {
                                          logged_in = false;
                                          _selected = 0;
                                        });
                                      },
                                      style: ButtonStyle(
                                          padding: MaterialStatePropertyAll(
                                              EdgeInsets.zero),
                                          elevation:
                                              MaterialStatePropertyAll(0),
                                          backgroundColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) =>
                                                      Colors.transparent)),
                                      child: Lottie.network("https://assets6.lottiefiles.com/packages/lf20_nd0kgpl6.json",height: 40)
                                    ),
                                  )
                                : Text("")
                          ],
                        ),
                      ],
                    )),
                  ],
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: _buildSelectedPage(),
                    ),
                  ),
                )
              ],
            )),
      ),
      bottomNavigationBar: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: SizedBox(
              child: CircularProgressIndicator(),
              width: 10,
              height: 10,
            ));
          } else {
            return Container(
              decoration: const BoxDecoration(color: kPrimaryColor),
              child: snapshot.hasData
                  ? BottomNavigationBar(
                      selectedItemColor: kPrimaryColor,
                      selectedFontSize: 14,
                      unselectedItemColor: kPrimaryColor.withOpacity(0.3),
                      currentIndex: _selected,
                      onTap: (index) {
                        setState(() {
                          _selected = index;
                        });
                      },
                      items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: AnimatedBuilder(
                                animation: animationController,
                                builder: (BuildContext context, Widget? child) {
                                  return Transform.scale(
                                    scale: 1 + animationController.value * 0.1,
                                    child: Icon(Icons.home),
                                  );
                                }),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.cases),
                              label: 'Your products',
                              tooltip: "Your products"),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.shopping_cart),
                              label: 'Cart',
                              tooltip: "Your cart"),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.compare_arrows),
                              label: 'Exchanges',
                              tooltip: "Exchanges proposals received"),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.person),
                            label: 'Profile',
                          ),
                        ])
                  : BottomNavigationBar(
                      selectedItemColor: kPrimaryColor,
                      selectedFontSize: 14,
                      unselectedItemColor: kPrimaryColor.withOpacity(0.3),
                      currentIndex: _selected,
                      onTap: _onItemTapped,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person_add_alt_1_sharp),
                          label: 'Create account',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.login),
                          label: 'Login',
                        )
                      ],
                    ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSelectedPage() {
    switch (_selected) {
      case 0:
        return MainScreen();
      case 1:
        return logged_in ? MyProductsScreen() : RegistrationScreen();
      case 2:
        return logged_in ? CartScreen() : LoginScreen();
      case 3:
        return logged_in ? ExchangesReceived() : Text('Unknown Page');
      case 4:
        return logged_in ? ProfileScreen() : Text('Unknown Page');

      default:
        return Text('Unknown Page');
    }
  }
}
