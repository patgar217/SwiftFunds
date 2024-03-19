import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final bool passwordInvisible;
  final TextEditingController controller;
  final double? height;
  final double? width;
  final bool isEditable;
  final bool? isError;
  
  const InputField({super.key,
    required this.hint,
    this.icon,
    required this.controller,
    this.passwordInvisible = false, this.height, this.width, required this.isEditable, this.isError});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool isWrong = isError != null && isError!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: width ?? size.width *.9,
      height: height ?? 55,
      decoration: BoxDecoration(
        color: primaryLightest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all( // Add a border around all sides
          color: isWrong ? Colors.red : (isEditable ? primaryDark : backgroundColor), // Set the desired border color
          width: 1, // Optional: Set the border width (default is 1.0)
        ),
      ),

      child: Center(
        child: TextFormField(
          readOnly: !isEditable,
          obscureText: passwordInvisible,
          controller: controller,
          style: isEditable ? const TextStyle() : const TextStyle(color: primaryDark, fontSize: 18, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            icon: icon != null ? Icon(icon, color: primaryDark) : null,
            hintStyle: const TextStyle(color: primaryColor)
          ),
        ),
      ),
    );
  }
}