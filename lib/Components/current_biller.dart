import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Views/add_biller.dart';


class CurrentBiller extends StatelessWidget {
  final IconData icon;
  final String billerName;
  
  const CurrentBiller({
    super.key, required this.icon, required this.billerName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddBillerScreen(billerName: billerName,)),);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: secondaryDark,
            ),
            padding: const EdgeInsets.all(5.0), // Adjust padding as needed
            child: Icon(
              icon,
              color: backgroundColor,
              size: 35.0,
            ),
          ),
          const SizedBox(height: 5,),
          Text(billerName, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}