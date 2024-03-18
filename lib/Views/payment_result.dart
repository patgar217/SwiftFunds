import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swiftfunds/Components/button_widget.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/paid_bill.dart';
import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/Models/payment.dart';
import 'package:swiftfunds/SQLite/database_service.dart';
import 'package:swiftfunds/Views/home.dart';

class PaymentResultScreen extends StatefulWidget {
  final bool isSuccess;
  final Payment payment;
  const PaymentResultScreen({super.key, required this.isSuccess, required this.payment});

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  final db = DatabaseService();
  double pointsToBeRedeemed = 0.00;
  
  @override
  void initState() {
    super.initState();
    updatePayment();
  }

  void updatePayment() async{
    setState(() {
      pointsToBeRedeemed = widget.payment.pointsRedeemed;
    });

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('MM-dd-yyyy HH:mm a');
    String formattedDateTime = formatter.format(now);

    Payment payment = widget.payment;
    payment.paymentDate = formattedDateTime;
    payment.pointsEarned = widget.isSuccess ? payment.totalAmount * 0.0001 : 0.00;
    payment.pointsRedeemed = widget.isSuccess ? payment.pointsRedeemed : 0.00;
    payment.status = widget.isSuccess ? "SUCCESS" : "FAILED";
    
    var res = await db.updatePayment(widget.payment.id!, payment);

    if(res>0){
      await db.updateUserPoints(payment.userId, payment.pointsEarned, payment.pointsRedeemed);
    }

    if(widget.isSuccess){
      for(final bill in widget.payment.bills){
        if(bill.isRepeating && bill.noOfPaidPayments! + 1 < bill.noOfPayments!){
          createNextBill(bill);
        }
      }
    }
  }

  void createNextBill(Bill bill) async {
    CurrentBiller currentBiller = bill.currentBiller!;

    String nextDueDate = "";

    final format = DateFormat('MM-dd-yyyy');
    final DateTime date = format.parse(bill.dueDate);
    if(bill.frequency == "WEEKLY"){
      final nextDate = date.add(const Duration(days: 7));
      nextDueDate = format.format(nextDate);
    } else if(bill.frequency == "MONTHLY"){
      final nextDate = date.add(const Duration(days: 30));
      nextDueDate = format.format(nextDate);
    } else {
      final nextDate = date.add(const Duration(days: 90));
      nextDueDate = format.format(nextDate);
    }

    Bill newBill = Bill(currentBillerId: currentBiller.id!, userId: bill.userId, dueDate: nextDueDate, amount: bill.amount, status: "PENDING", isRepeating: bill.isRepeating, frequency:bill.frequency, noOfPayments: bill.noOfPayments, noOfPaidPayments: bill.noOfPaidPayments! + 1);
    var res = await db.createBill(newBill);
    if(res>0){
      if(!mounted) return;
    }

  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SafeArea(
          child: Container(
            color: (widget.isSuccess ? primaryColor : quarternaryColor),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: (widget.isSuccess ? secondaryDark : quarternaryDark),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        height: size.height * .55,
                      ),
                       Positioned(
                        top: 20,
                        child: Container(
                          width: size.width * .90,
                          height: size.height * .83,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: const BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 120,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: backgroundColor,
                                    border: Border.all(
                                      color: (widget.isSuccess ? primaryLight : quarternaryLight), 
                                      width: 10.0,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 20),
                                  child: Icon(
                                    (widget.isSuccess ? Icons.check_circle : Icons.cancel), 
                                    size: 100, 
                                    color: (widget.isSuccess ? primaryDark : quarternaryDark),
                                  )
                                ),
                                const SizedBox(height: 20,),
                                Text(
                                  (widget.isSuccess ? "Success!" : "Failed!"),
                                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                                Text.rich(
                                  TextSpan(
                                    style: const TextStyle(fontSize: 20),
                                    children: [
                                      const TextSpan(
                                        text: "Receipt No. ", 
                                      ),
                                      TextSpan(
                                        text: '${widget.payment.id}'.padLeft(7, '0'),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Column(
                                  children: widget.payment.bills.map((bill) {
                                    return PaidBill(billerId: bill.currentBiller!.acctNumber.toString(), billerName: bill.currentBiller!.nickname, amount: bill.amount, isPaid: widget.isSuccess,);
                                  }).toList(),
                                ),
                                const SizedBox(height: 10,),
                                if(pointsToBeRedeemed > 0) Row(
                                  children: [
                                    Icon( Icons.monetization_on , color: widget.isSuccess ? primaryDark : quarternaryDark, size: 40),
                                    const SizedBox(width: 10,),
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("SwiftPoints", style: TextStyle(fontSize: 15),),
                                        Text("Redeemed", style: TextStyle(fontSize: 15),),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text('-₱${pointsToBeRedeemed.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                const Spacer(),
                                const Text("Total Amount", style: TextStyle(fontSize: 18),),
                                Text("₱${widget.payment.totalAmountWithPoints.toStringAsFixed(2)}",style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                                if(widget.isSuccess) Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Text("SwiftPoints Earned: ${widget.payment.pointsEarned.toStringAsFixed(2)}", style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),),
                                ),
                                const SizedBox(height: 30,),
                              ]
                            ),
                          )
                        )
                      ),
                      Positioned(
                        bottom: 20,
                        child: Button(label: "DONE", press: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                        }, backgroundColor: (widget.isSuccess ? secondaryDark : quarternaryDark), textSize: 18, isRounded: true,),
                      ),
                    ]
                  )
                )
              ]
            )
          )
        )
      )
    );
  }
}
