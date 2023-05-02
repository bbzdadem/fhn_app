import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  String hinttext;
  TextEditingController controller;
  final Function(String) onValueChanged;

  TextInputField(this.hinttext, this.controller, this.onValueChanged,
      {Key? key})
      : super(key: key);

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: widget.controller,
        keyboardType: TextInputType.multiline,
        onChanged: (value) => widget.onValueChanged(value),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Boş buraxıla bilməz!';
          }
          return null;
        },
        maxLines: null,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffD9D9D9),
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff222B45),
              width: 1,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffFF3D71),
              width: 1,
            ),
          ),
          fillColor: Colors.white,
          focusColor: const Color(0XFFF7F9FC),
          filled: true,
          hintText: widget.hinttext,
          hintStyle: const TextStyle(
            color: Color(0xff8F9BB3),
            fontSize: 16,
          ),
          // labelText: widget.hinttext,
          // labelStyle: const TextStyle(
          //   color: Color(0xff8F9BB3),
          // ),
          errorText: null,
          errorStyle: const TextStyle(
            color: Color(0xffFF3D71),
            fontSize: 12,
            height: 0.5,
            overflow: TextOverflow.ellipsis,
          ),
          errorMaxLines: 2,
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffFF3D71),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        cursorColor: const Color(0xff222B45),
        style: const TextStyle(
          color: Color(0xff222B45),
          fontSize: 16,
        ),
      ),
    );
  }
}
