import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/under-construction.png",
                fit: BoxFit.cover,
              ),
              const Text("Under construction", style: TextStyle(color: secondaryDark, fontSize: 40, fontWeight: FontWeight.bold),),
              const Text("This page is coming soon", style: TextStyle(color: secondaryDark, fontSize: 20, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
      );
  }
}