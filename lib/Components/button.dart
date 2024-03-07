import 'package:flutter/material.dart';

class Button extends StatelessWidget {

    final String label;
    final VoidCallback press;
    final Color backgroundColor;
    final double textSize;
    final bool? isRounded;
    final double? widthRatio;
    final double? marginTop;
    const Button({ super.key, required this.label, required this.press, required this.backgroundColor, required this.textSize, this.isRounded, this.widthRatio, this.marginTop });

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: marginTop?? 15),
      width: widthRatio != null ? size.width * widthRatio! :  size.width * .9,
      height: textSize * 2 + 10,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: isRounded != null ? BorderRadius.circular(12) : null),
      child: TextButton(
        onPressed: press,
        child: Text(label, style: TextStyle(color: Colors.white, fontSize: textSize, fontWeight: FontWeight.bold), ),
      ),
    );
  }
}