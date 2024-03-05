import 'package:flutter/material.dart';
import 'package:swiftfunds/Views/categories.dart';
import 'package:swiftfunds/Components/colors.dart';


class MyBills extends StatelessWidget {
  const MyBills({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * .9,
      height: 150,
      decoration: const BoxDecoration(
        color: secondaryDark,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: SizedBox(
        width: size.width * .9,
        child: Row(
          children: [
            const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("My Bills", style: TextStyle(color: Colors.white, fontSize: 20),),
                Spacer(),
                Text("Total Bills Due", style: TextStyle(color: Colors.white, fontSize: 15)),
                Text("P3000", style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () {
                     Navigator.of(context).push( MaterialPageRoute(builder: (context) => const CategoriesScreen(), ),);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(5.0), 
                      child: Icon(Icons.add_rounded, color: secondaryDark, size: 30,), 
                    ),
                  ),
                ),
                const Spacer(),
                const Text("SwiftPoints", style: TextStyle(color: Colors.white, fontSize: 15)),
                const Text("0.00", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}