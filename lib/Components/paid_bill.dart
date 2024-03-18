
import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';

class PaidBill extends StatelessWidget {
  final bool isPaid;
  final String billerName;
  final String billerId;
  final double amount;
  const PaidBill({
    super.key, required this.isPaid, required this.billerName, required this.billerId, required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(isPaid ? Icons.check_box : Icons.disabled_by_default, color: isPaid ? primaryDark: quarternaryDark, size:60),
        const SizedBox(width: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(billerName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1),), 
            Text("ID: $billerId", style: const TextStyle(fontSize: 12))
          ]
        ),
        const Spacer(),
        Text("₱${amount.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black, fontSize: 27, fontWeight: FontWeight.bold, height: 1)),
      ],
    );
  }
}