import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputField extends StatefulWidget {
  String hinttext;
  TextEditingController controller;
  final Function(String) onValueChanged;

  PhoneInputField(this.hinttext, this.controller, this.onValueChanged,
      {Key? key})
      : super(key: key);

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        keyboardType: TextInputType.phone,
        controller: widget.controller,
        onChanged: (value) => widget.onValueChanged(value),
        inputFormatters: [
          LengthLimitingTextInputFormatter(9),
        ],
        validator: (value) {
          if (value!.isEmpty) {
            return 'Zəhmət olmasa nömrəni daxil edin';
          } else if (value.toString()[0] != '5' &&
                  value.toString()[0] != '7' &&
                  value.toString()[0] != '1' &&
                  value.toString()[0] != '6' &&
                  value.toString()[0] != '9' ||
              value.toString().length != 9) {
            return 'Nömrə düzgün daxil edilməyib';
          }
          return null;
        },
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
            fillColor: Colors.white,
            focusColor: const Color(0XFFF7F9FC),
            filled: true,
            hintText: widget.hinttext,
            hintStyle: const TextStyle(
              color: Color(0xff8F9BB3),
              fontSize: 16,
              height: 1,
            ),
            errorText: null,
            errorStyle: const TextStyle(
              color: Color(0xffFF3D71),
              fontSize: 12,
              height: 0.01,
              overflow: TextOverflow.ellipsis,
            ),
            errorMaxLines: 1,
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              width: 48,
              height: 48,
              child: const Text(
                '+994',
                style: TextStyle(
                  color: Color(0xff222B45),
                  fontSize: 16,
                  height: 1,
                ),
              ),
            )),
        cursorColor: const Color(0xff222B45),
        style: const TextStyle(
          color: Color(0xff222B45),
          fontSize: 16,
        ),
      ),
    );
  }
}
