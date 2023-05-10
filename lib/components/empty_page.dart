import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class EmptyScreen extends StatefulWidget {
  late String text;

  EmptyScreen({super.key, required this.text});

  @override
  State<EmptyScreen> createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 260,
          height: 270,
          child: Lottie.network(
              'https://assets1.lottiefiles.com/private_files/lf30_e3pteeho.json',
              repeat: true,
              frameRate: FrameRate(30),
              fit: BoxFit.contain),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          widget.text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    );
    ;
  }
}
