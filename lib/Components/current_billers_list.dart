import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/current_biller.dart';


class CurrentBillersList extends StatelessWidget {
  const CurrentBillersList({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * .95,
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Current Billers",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                CurrentBiller(icon: Icons.lightbulb, billerName: "CAPEL"),
                CurrentBiller(icon: Icons.water_drop, billerName: "WATER"),
                CurrentBiller(icon: Icons.router, billerName: "INTERNET"),
                CurrentBiller(icon: Icons.lightbulb, billerName: "CAPELCO"),
                CurrentBiller(icon: Icons.water_drop, billerName: "WATER"),
                CurrentBiller(icon: Icons.router, billerName: "INTERNET"),
              ],
            ),
          )
        ],
      )
    );
  }
}

