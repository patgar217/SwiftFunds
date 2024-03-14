import 'package:flutter/material.dart';
import 'package:swiftfunds/Models/user.dart';
import 'package:swiftfunds/Views/categories.dart';
import 'package:swiftfunds/Components/colors.dart';


class MyBills extends StatelessWidget {
  const MyBills({
    super.key, required this.profile, required this.totalBills
  });

  final User? profile;
  final double totalBills;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("My Bills", style: TextStyle(color: Colors.white, fontSize: 20),),
                const Spacer(),
                const Text("Total Bills Due", style: TextStyle(color: Colors.white, fontSize: 15)),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold),
                    children: [
                      const TextSpan(text: '₱'),
                      TextSpan(
                        text: totalBills.toStringAsFixed(2)
                      )
                    ],
                  ),
                )
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
                Text(profile!.swiftpoints!.toStringAsFixed(2), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}