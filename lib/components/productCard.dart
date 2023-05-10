import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Product.dart';
import 'package:swap_store/screens/product_screen.dart';

class ProductCard extends StatefulWidget {
  late Product product;

  ProductCard({required this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation =
        Tween<double>(begin: 1, end: 0.95).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    ProductController ctrl = new ProductController(context: context);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        _animationController.reverse();
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductScreen(
                product: widget.product,
              ),
            ));
      },
      child: SizedBox(
        width: 150,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15.0),
                          ),
                          child: Hero(
                            tag: widget.product.title,
                            child: Image.file(
                              ctrl.getImage(widget.product.image),
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.07),
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product.title.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),

                              SizedBox(height: 10.0),
                              Text(
                                '${widget.product.price.toStringAsFixed(2)} TND',
                                textAlign: TextAlign.end,
                                style: kPriceStyle.copyWith(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold,),

                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
