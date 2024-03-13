
import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Views/add_biller.dart';

class BillerWidget extends StatelessWidget {
  final IconData icon;
  final String billerName;
  
  const BillerWidget({
    super.key, required this.icon, required this.billerName,
  });


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap:() {
        Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddBillerScreen(billerName: billerName,)),);
      },
      child: SizedBox(
        width: size.width * .90,
        child: Row(
          children: [
            Container(width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: secondaryDark,
              ),
              padding: const EdgeInsets.all(5.0),
              child: Icon(icon, size: 30, color: backgroundColor,)
            ),
            const SizedBox(width: 5,),
            Text(billerName, style: const TextStyle(fontSize: 18, color: secondaryDark),),
            const Spacer(),
            const Icon(Icons.arrow_right, size: 40, color: secondaryDark,)
          ],
        )
      ),
    );
  }
}