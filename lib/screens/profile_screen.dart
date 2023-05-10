import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/Controllers/UserController.dart';
import 'package:swap_store/components/MyActionButton.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Utilisateur.dart';
import 'package:swap_store/screens/myexchanges_sent.dart';
import 'package:swap_store/screens/order_received.dart';
import 'package:swap_store/screens/orders_placed.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserController ctrl = UserController();
  late Utilisateur? user = null;

  Future initUser() async {
    Utilisateur tempUser = await ctrl.getUser();
    setState(() {
      user = tempUser;
    });
  }

  XFile? image;
  final ImagePicker picker = ImagePicker();
  UserController userController = UserController();

  Future selectImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
    final current = await userController.getUser();
    String? currentAvatar = current.avatar;
    if (currentAvatar != null) {
      final directory = Directory.systemTemp.parent;
      final file = File('${directory.path}/app_flutter/uploads/$currentAvatar');
      if (await file.exists()) {
        await file.delete();
      }
    }

    Directory directory = await getApplicationDocumentsDirectory();
    final uploadsDirectory = Directory('${directory.path}/uploads/');
    if (!await uploadsDirectory.exists()) {
      await uploadsDirectory.create(recursive: true).then((dir) {});
    }
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '${uploadsDirectory.path}/$fileName';
    await File(img!.path).copy(filePath);
    await userController.setAvatar(fileName);
    final temp = await userController.getUser();
    setState(() {
      user = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    initUser();
    super.initState();
  }

  Future settingImage(String? avatar) {
    return showMaterialModalBottomSheet(
        context: context,
        expand: false,
        builder: (context) {
          return Container(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: MyActionButton(
                        label: "From gallery",
                        icon: Icons.image,
                        onPressed: () async {
                          Navigator.pop(context);
                          await selectImage(ImageSource.gallery);
                          setState(() {
                            avatar = image!.name;
                          });
                        },
                        color: CupertinoColors.activeBlue),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: MyActionButton(
                      label: "From camera",
                      icon: Icons.camera,
                      color: CupertinoColors.activeBlue,
                      onPressed: () async {
                        Navigator.pop(context);
                        await selectImage(ImageSource.camera);
                        setState(() {
                          avatar = image!.name;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ProductController pc = ProductController();
    String? avatar = user == null ? "" : user!.avatar;
    if (user == null) {
      return ModalProgressHUD(inAsyncCall: true, child: Text(""));
    } else {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                user!.avatar != null
                    ? GestureDetector(
                        onTap: () async {
                          await settingImage(avatar);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundColor: Colors.white,
                              backgroundImage: FileImage(pc.getImage(avatar!)),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          await settingImage(avatar);
                        },
                        child: SizedBox(
                            child: Lottie.network(
                                "https://assets6.lottiefiles.com/packages/lf20_kh9bsPprKK.json",
                                fit: BoxFit.cover,
                                height: 140)),
                      ),
                Text(
                  user!.name,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.0),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black45,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.black45,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(user!.name)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black45,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail,
                              color: Colors.black45,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(user!.email)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.black45,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.black45,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(user!.tel.toString())
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    MyActionButton(
                      label: "Your orders",
                      color: CupertinoColors.black,
                      icon: Icons.remove_red_eye,
                      onPressed: () {
                        showMaterialModalBottomSheet(
                            context: context,
                            expand: false,
                            builder: (context) {
                              return Container(
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: MyActionButton(
                                          onPressed: (){
                                            showMaterialModalBottomSheet(
                                                context: context,
                                                expand: true,
                                                builder: (context) {
                                                  return OrderReceived();
                                                });
                                          },
                                            label: "Orders received",
                                            color: CupertinoColors.systemGreen),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: MyActionButton(
                                          label: "Orders placed",
                                          color: CupertinoColors.activeBlue,
                                          onPressed: () {
                                            showMaterialModalBottomSheet(
                                                context: context,
                                                expand: true,
                                                builder: (context) {
                                                  return OrdersPlacedScreen();
                                                });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                    SizedBox(height: 10.0),
                    MyActionButton(
                      label: "Your exchange requests",
                      color: CupertinoColors.black,
                      icon: Icons.swap_horiz,
                      onPressed: () {
                        showMaterialModalBottomSheet(
                            context: context,
                            expand: false,
                            builder: (context) =>
                                SafeArea(child: MyExchangesSent()));
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //     ));
                      },
                    ),
                    SizedBox(height: 10.0),
                    MyActionButton(
                      label: "Delete your account",
                      color: Colors.redAccent.withOpacity(0.6),
                      icon: Icons.close,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
