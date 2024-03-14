import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Views/edit_current_biller.dart';


class CurrentBillerWidget extends StatelessWidget {
  final String image;
  final String billerName;
  
  const CurrentBillerWidget({
    super.key, required this.image, required this.billerName,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.of(context).push( MaterialPageRoute(builder: (context) => EditCurrentBiller(billerName: billerName,)),);
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
            child: image != "" ? CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 20,
            ) : const Icon(
              Icons.account_balance_wallet_outlined,
              color: backgroundColor,
              size: 35.0
            ),
          ),
          const SizedBox(height: 5,),
          Text(billerName, style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}