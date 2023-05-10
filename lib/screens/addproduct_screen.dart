import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/Controllers/UserController.dart';
import 'package:swap_store/components/Input.dart';
import 'package:swap_store/components/MyActionButton.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Product.dart';
import 'package:swap_store/models/Utilisateur.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late String prodName;
  late double price;
  late String image;
  late double age;
  late String condition = "Old";
  late String desc;
  late int type = 0;
  late String owner;
  late int owner_tel;
  final _formKey = GlobalKey<FormState>();

  String? dropdownTypeValue = 'Furniture';
  XFile? img;

  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media) async {
    var imgg = await picker.pickImage(source: media);

    setState(() {
      img = imgg;
      image = img!.name.toString();
    });
  }

  Future<String>? _directoryPath;

  // List of items in our dropdown menu
  var items_type = [
    'Furniture',
    'Toy',
  ];
  var items_condition = [
    'Old',
    'Good',
    'New',
  ];
  String? dropdownConditionValue = "Old";
  bool showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _directoryPath = getApplicationDocumentsDirectory().then((dir) => dir.path);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Add new product",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(1, 1), // This will create a shadow above the box
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Input(
                              label: "Product name",
                              is_Password: false,
                              onChange: (value) {
                                setState(() {
                                  prodName = value;
                                });
                              }),
                          SizedBox(
                            height: 13,
                          ),
                          Input(
                              label: "Description",
                              is_Password: false,
                              isTextArea: true,
                              onChange: (value) {
                                setState(() {
                                  desc = value;
                                });
                              }),
                          SizedBox(
                            height: 13,
                          ),
                          Input(
                              isNumber: true,
                              label: "Price",
                              is_Password: false,
                              onChange: (value) {
                                setState(() {
                                  price = double.parse(value);
                                });
                              }),
                          SizedBox(
                            height: 13,
                          ),
                          Input(
                              label: "Age",
                              isNumber: true,
                              is_Password: false,
                              onChange: (value) {
                                setState(() {
                                  age = double.parse(value);
                                });
                              }),
                          SizedBox(
                            height: 13,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Type",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                DropdownButton(
                                  underline: Container(),
                                  value: dropdownTypeValue,
                                  style: TextStyle(color: kPrimaryColor),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items_type.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      type = newValue == "Fourniture" ? 0 : 1;
                                      dropdownTypeValue = newValue;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 13),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 20.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Condition",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                DropdownButton(
                                  underline: Container(),
                                  value: condition,
                                  style: TextStyle(color: kPrimaryColor),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: items_condition.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      condition = newValue!;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 13),


                          SizedBox(
                            height: 5,
                          ),
                          img != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20,vertical: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      //to show image, you type like this.
                                      File(img!.path),
                                      fit: BoxFit.contain,
                                      width: MediaQuery.of(context).size.width,
                                      height: 90,
                                    ),
                                  ),
                                )
                              : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: const Text(
                                    "No Image Selected yet",
                                    style: TextStyle(fontSize: 14),
                                  ),
                              ),
                          MyActionButton(label: "Choose product image", color: CupertinoColors.activeBlue,icon: Icons.image,onPressed:  () {
                            Alert(
                                context: context,
                                content: Container(
                                  height:
                                  MediaQuery.of(context).size.height / 6,
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          getImage(ImageSource.gallery);
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(Icons.image),
                                            Text('From Gallery'),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        //if user click this button. user can upload image from camera
                                        onPressed: () {
                                          Navigator.pop(context);
                                          getImage(ImageSource.camera);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.camera),
                                            Text('From Camera'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )).show();
                          }),
                          SizedBox(height: 8,),

                          FutureBuilder<String>(
                            future: _directoryPath,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final directoryPath = snapshot.data!;
                                final uploadsDirectory =
                                    Directory('$directoryPath/uploads');

                                return SizedBox(
                                  width: double.infinity,
                                  child:  MyActionButton(label: "Add product", color: Colors.black,icon: Icons.add,onPressed: ()async{
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    UserController ctrl = UserController();
                                    Utilisateur user = await ctrl.getUser();
                                    try {
                                      Directory directory =
                                      await getApplicationDocumentsDirectory();

                                      final uploadsDirectory = Directory(
                                          '${directory.path}/uploads/');
                                      if (!await uploadsDirectory.exists()) {
                                        await uploadsDirectory
                                            .create(recursive: true)
                                            .then((dir) {});
                                      }
                                      final fileName =
                                          '${DateTime.now().millisecondsSinceEpoch}.jpg';
                                      final filePath =
                                          '${uploadsDirectory.path}/$fileName';

                                      ProductController productCtrl =
                                      ProductController(context: context);
                                      Product product;
                                      product = Product(
                                          title: prodName,
                                          image: fileName,
                                          description: desc,
                                          price: price,
                                          age: age,
                                          condition: condition,
                                          owner: user.name,
                                          ownerTel: user.tel,
                                          ownerUid: user.uid,
                                          type: type,
                                          statue: 1);
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        productCtrl.CreateProduct(product);
                                        await File(img!.path).copy(filePath);
                                        Navigator.pop(context);
                                        // Alert(context: context,type: AlertType.success,title: "Done",desc: "product successfully added").show();
                                      }
                                    } catch (e, stack) {
                                      Alert(
                                          context: context,
                                          type: AlertType.error,
                                          title: "Error",
                                          desc:
                                          "You can't leave an empty field !")
                                          .show();
                                    }
                                    setState(() {
                                      showSpinner = false;
                                    });
                                  },)
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
