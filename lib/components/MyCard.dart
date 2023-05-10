import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/constants.dart';

class MyCard extends StatefulWidget {
  late String title;
  late String value;
   MyCard({super.key, required this.title,required this.value});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 1.0,
              spreadRadius: 1.0,
            ),
          ],
          color: Colors.white.withOpacity(0.8)),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Expanded(
                flex: 2,
                child: Text(
                  widget.value,
                  style: kPriceStyle,
                ))
          ],
        ),
      ),
    );
  }
}
