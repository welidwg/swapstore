import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swap_store/constants.dart';

class Input extends StatefulWidget {
  late String label;
  late bool is_Password;
  late bool? isTextArea = false;
  late bool? isNumber = false;
  final Function(String value) onChange;

  Input(
      {super.key,
      required this.label,
      required this.is_Password,
      required this.onChange,
      this.isTextArea,
      this.isNumber});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'Please enter your name';
        }
        return null;
      },
      maxLines: widget.isTextArea != null ? null : 1,
      controller: _controller,
      obscureText: widget.is_Password,
      style: GoogleFonts.adventPro(
        textStyle: TextStyle(color: CupertinoColors.black),
      ),
      onChanged: (value) {
        widget.onChange(value);
      },
      keyboardType: widget.isTextArea != null
          ? TextInputType.multiline
          : widget.isNumber == true
              ? TextInputType.number
              : TextInputType.emailAddress,
      decoration: InputDecoration(
        label: Text(widget.label),
        labelStyle: const TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black45, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }
}
