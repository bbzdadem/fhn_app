import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

String openeye = 'assets/eye-open.svg';
String closeeye = 'assets/eye-closed.svg';

class PasswordInputField extends StatefulWidget {
  String hinttext;
  TextEditingController controller;
  final Function(String) onValueChanged;

  PasswordInputField(this.hinttext, this.controller, this.onValueChanged,
      {Key? key})
      : super(key: key);

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool isVisible = true;
  void makeItVisible() {
    if (isVisible) {
      setState(() {
        isVisible = false;
      });
    } else {
      setState(() {
        isVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        obscureText: isVisible,
        enableSuggestions: false,
        autocorrect: false,
        onChanged: (value) => widget.onValueChanged(value),
        validator: (value) {
          if (value!.isEmpty || value.length < 8) {
            return 'Şifrə minimum 8 hərfdən ibarət olmalıdır';
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
            contentPadding: const EdgeInsets.only(left: 16),
            fillColor: Colors.white,
            focusColor: const Color(0XFFF7F9FC),
            filled: true,
            hintText: widget.hinttext,
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
            suffixIcon: InkWell(
              onTap: makeItVisible,
              child: Container(
                width: 48,
                height: 12,
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  isVisible ? closeeye : openeye,
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
