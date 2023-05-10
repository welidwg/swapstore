import 'package:flutter/cupertino.dart';
import 'package:swap_store/Controllers/ProductController.dart';

class FullScreenImageScreen extends StatefulWidget {
  FullScreenImageScreen({super.key, required this.image,required this.tag});

  late String image;
  late String tag="";
  static String id = "fullscreen_screen";

  @override
  State<FullScreenImageScreen> createState() => _FullScreenImageScreenState();
}

class _FullScreenImageScreenState extends State<FullScreenImageScreen> {
  @override
  Widget build(BuildContext context) {
    ProductController ctrl = new ProductController(context: context);

    return GestureDetector(
      onTap: () {
        // Navigate back to the main screen
        Navigator.pop(context);
      },
      child: Hero(
        tag: widget.tag,
        child:
            InteractiveViewer(child: Image.file(ctrl.getImage(widget.image)),boundaryMargin: EdgeInsets.all(20),
              minScale: 0.1,
              maxScale: 10,),
      ),
    );
  }
}
