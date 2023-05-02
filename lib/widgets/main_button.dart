import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  String? buttonText;
  Color? color;
  Color? borderColor;
  Color? textColor;
  Function tapFunction;

  MainButton(this.buttonText, this.color, this.borderColor, this.textColor,
      this.tapFunction,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => tapFunction(),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 40,
        decoration: BoxDecoration(
          color: color ?? Colors.red,
          border: Border.all(
            width: 1,
            color: borderColor ?? Colors.red,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          buttonText ?? 'null',
          style: TextStyle(
            fontSize: 16,
            color: textColor ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
