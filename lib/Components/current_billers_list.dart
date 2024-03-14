import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/current_biller_widget.dart';
import 'package:swiftfunds/Models/current_biller.dart';


class CurrentBillersList extends StatefulWidget {
  const CurrentBillersList({
    super.key,
    required this.currentBillers
  });

  final List<CurrentBiller> currentBillers;

  @override
  State<CurrentBillersList> createState() => _CurrentBillersListState();
}

class _CurrentBillersListState extends State<CurrentBillersList> {

  @override
  void initState() {
    super.initState();
  }

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Current Billers",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: widget.currentBillers.map((biller) {
                return CurrentBillerWidget(image: biller.logo, billerName: biller.nickname);
              }).toList(),
            ),
          )
        ],
      )
    );
  }
}

