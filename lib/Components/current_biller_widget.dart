import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/Views/add_biller.dart';


class CurrentBillerWidget extends StatelessWidget {
  final CurrentBiller biller;
  
  const CurrentBillerWidget({super.key, 
   required this.biller});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddBillerScreen(billerName: biller.nickname, currentBiller: biller,)),);
      },
      child: Column(
        children: [
          Container(
            width: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: secondaryDark,
            ),
            padding: const EdgeInsets.all(5.0),
            child: biller.logo != "" ? CircleAvatar(
              backgroundImage: AssetImage(biller.logo),
              radius: 20,
            ) : const Icon(
              Icons.account_balance_wallet_outlined,
              color: backgroundColor,
              size: 35.0
            ),
          ),
          const SizedBox(height: 5,),
          Text(biller.nickname, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}