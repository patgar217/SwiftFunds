
import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Views/add_biller.dart';

class BillerWidget extends StatelessWidget {
  final String logo;
  final String billerName;
  final IconData categoryIcon;
  
  const BillerWidget({
    super.key, required this.logo, required this.billerName, required this.categoryIcon,
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
              child: logo != "" ? CircleAvatar(
                    backgroundImage: AssetImage(logo),
                    radius: 17,
                  ) : Icon(categoryIcon, size: 30, color: backgroundColor,),
            ),
            const SizedBox(width: 5,),
            SizedBox(
              width: (size.width * .90) - 100,
              child: Text(billerName, style: const TextStyle(fontSize: 18, color: secondaryDark),overflow: TextOverflow.ellipsis)),
            const Spacer(),
            const Icon(Icons.arrow_right, size: 40, color: secondaryDark,)
          ],
        )
      ),
    );
  }
}