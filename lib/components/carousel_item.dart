import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselItem extends StatefulWidget {
  late String image;
  late String? text;

  CarouselItem({super.key, required this.image, this.text});

  @override
  State<CarouselItem> createState() => _CarouselItemState();
}

class _CarouselItemState extends State<CarouselItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("${widget.image}"), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white),
    );
  }
}
