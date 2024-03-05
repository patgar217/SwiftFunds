import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Views/biller_list.dart';

class Category extends StatelessWidget {
  const Category({
    super.key, required this.icon, required this.categoryName,
  });

  final String categoryName;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){Navigator.of(context).push( MaterialPageRoute(builder: (context) => BillerListScreen(categoryName: categoryName, icon: icon,), ),);},
      child: Container(
        width: (size.width * .80)/3,
        height: 110,
        decoration: const BoxDecoration(
          color: secondaryDark,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        padding: const EdgeInsets.all(5.0), // Adjust padding as needed
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: backgroundColor,),
            const SizedBox(height: 5,),
            Text(categoryName,style: const TextStyle(fontSize: 15, color: Colors.white, height: 1), textAlign: TextAlign.center,)
          ],
        )
      ),
    );
  }
}
