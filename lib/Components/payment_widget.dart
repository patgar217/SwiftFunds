import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/payment.dart';

class PaymentWidget extends StatefulWidget {
  const PaymentWidget({super.key, required this.payment});

  final Payment payment;

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {

  String formatDate(String dateString) {
    final parsedDate = DateFormat('MM-dd-yyyy hh:mm a').parse(dateString);

    // Format the parsed date using a desired format pattern
    final formattedDate = DateFormat('MMMM dd, yyyy HH:mm a').format(parsedDate);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {

    bool isSuccess = widget.payment.status == "SUCCESS";
    double pointsRedeemed = widget.payment.totalAmount - widget.payment.totalAmountWithPoints;
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * .9,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        const TextSpan(text: 'Receipt No.: '),
                        TextSpan(
                          text:'${widget.payment.id}'.padLeft(7, '0'), style: const TextStyle(fontWeight: FontWeight.bold)
                        )
                      ],
                    ),
                  ),
                  Text(formatDate(widget.payment.paymentDate), style: const TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
              const Spacer(),
              Text(widget.payment.status, style: TextStyle(color: isSuccess ? primaryDark : quarternaryDark, fontWeight: FontWeight.bold, fontSize: 20),)
            ],
          ),
          const Divider(color: secondaryLightest, thickness: 1, height: 5,),
          Column(
            children: widget.payment.bills.map((bill) {
              return PaymentBillWidget(isSuccess: isSuccess, bill: bill);
            }).toList(),
          ),
          const SizedBox(height: 5),
          if(pointsRedeemed > 0) Row(
            children: [
              Text("Redeemed ${pointsRedeemed.toStringAsFixed(2)} SwiftPoints", style: const TextStyle(fontSize: 15, color: Colors.grey)),
              const Spacer(),
              Text("-₱${pointsRedeemed.toStringAsFixed(2)}", style: const TextStyle(fontSize: 15, color: Colors.grey))
            ],
          ),
          const Divider(color: secondaryLightest, thickness: 1, height: 5,),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text("Order Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text("₱${widget.payment.totalAmountWithPoints.toStringAsFixed(2)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ],
          ),
          Row(
            children: [
              const Text("SwiftPoints Earned", style: TextStyle(fontSize: 15, color: Colors.grey)),
              const Spacer(),
              Text("${widget.payment.pointsEarned.toStringAsFixed(2)} Points", style: const TextStyle(fontSize: 15, color: Colors.grey))
            ],
          ),
          
        ],
      ),
    );
  }
}

class PaymentBillWidget extends StatelessWidget {
  const PaymentBillWidget({
    super.key,
    required this.isSuccess, required this.bill,
  });

  final bool isSuccess;
  final Bill bill;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:5),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: isSuccess ? primaryDark : quarternaryDark,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Icon(isSuccess ? Icons.check_circle : Icons.cancel, color: backgroundColor, size:30),
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bill.currentBiller!.nickname, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1),), 
              Text("ID# ${bill.currentBiller!.acctNumber}", style: const TextStyle(fontSize: 15)),
            ]
          ),
          const Spacer(),
          Text("₱${bill.amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, height: 1),),
        ],
      ),
    );
  }
} 