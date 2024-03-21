import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/button_widget.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/paid_bill.dart';
import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/payment.dart';
import 'package:swiftfunds/Services/bill_service.dart';
import 'package:swiftfunds/Services/payment_service.dart';
import 'package:swiftfunds/Services/user_service.dart';
import 'package:swiftfunds/Views/home.dart';

class PaymentResultScreen extends StatefulWidget {
  final bool isSuccess;
  final Payment payment;
  const PaymentResultScreen({super.key, required this.isSuccess, required this.payment});

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  double pointsToBeRedeemed = 0.00;

  final paymentService = PaymentService();
  final userService = UserService();
  final billService = BillService();

  @override
  void initState() {
    super.initState();
    updatePayment();
  }

  void updatePayment() async{
    setState(() {
      pointsToBeRedeemed = widget.payment.pointsRedeemed;
    });
    
    Payment payment = await paymentService.updatePayment(widget.payment, widget.isSuccess);
    userService.updateSwiftPoint(payment.userId, payment.pointsEarned, payment.pointsRedeemed);

    if(widget.isSuccess){
      for(final bill in widget.payment.bills){
        if(bill.isRepeating && bill.noOfPaidPayments! + 1 < bill.noOfPayments!){
          createNextBill(bill);
        }
      }
    }
  }

  void createNextBill(Bill bill) async {
    var res = await billService.createNextBill(bill);
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
