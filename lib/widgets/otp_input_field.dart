import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputField extends StatelessWidget {
  String hinttext;
  TextEditingController controller;
  final Function(String) onValueChanged;

  OtpInputField(this.hinttext, this.controller, this.onValueChanged, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        // obscureText: isVisible,
        controller: controller,
        onChanged: (value) => onValueChanged(value),
        inputFormatters: [
          LengthLimitingTextInputFormatter(4),
        ],
        enableSuggestions: false,
        autocorrect: false,
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
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffFF3D71),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.only(left: 16),
          fillColor: Colors.white,
          focusColor: const Color(0XFFF7F9FC),
          filled: true,
          hintText: hinttext,
          hintStyle: const TextStyle(
            color: Color(0xff8F9BB3),
            fontSize: 16,
          ),
          errorText: null,
          errorStyle: const TextStyle(
            color: Color(0xffFF3D71),
            fontSize: 12,
            height: 0.5,
            overflow: TextOverflow.ellipsis,
          ),
          errorMaxLines: 2,
          suffixIcon: Container(
            width: 70,
            height: 14,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: const Text(
              '',
              style: TextStyle(
                color: Color(0XFF3366FF),
                fontSize: 14,
              ),
            ),
          ),
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
