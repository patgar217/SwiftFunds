import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';

class InputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool passwordInvisible;
  final TextEditingController controller;
  const InputField({super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.passwordInvisible = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      width: size.width *.9,
      height: 55,
      decoration: BoxDecoration(
        color: primaryLightest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all( // Add a border around all sides
          color: primaryDark, // Set the desired border color
          width: 1, // Optional: Set the border width (default is 1.0)
        ),
      ),

      child: Center(
        child: TextFormField(
           obscureText: passwordInvisible,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            icon: Icon(icon),
            iconColor: primaryDark,
            hintStyle: const TextStyle(color: primaryColor)
          ),
        ),
      ),
    );
  }
}