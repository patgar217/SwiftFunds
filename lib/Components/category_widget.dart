import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Models/category.dart';
import 'package:swiftfunds/Views/biller_list.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key, required this.category
  });
  final Category category;

  @override
  Widget build(BuildContext context) {
    IconData icon = IconData(int.parse(category.logo), fontFamily: 'MaterialIcons');
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){Navigator.of(context).push( MaterialPageRoute(builder: (context) => BillerListScreen(categoryId: category.id, categoryName: category.name, icon: icon,), ),);},
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
            Icon(icon, size: 50, color: backgroundColor,),
            const SizedBox(height: 5,),
            Text(category.name, style: const TextStyle(fontSize: 15, color: Colors.white, height: 1), textAlign: TextAlign.center,)
          ],
        )
      ),
    );
  }
}
