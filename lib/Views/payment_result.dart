import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/button.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/paid_bill.dart';
import 'package:swiftfunds/Views/home.dart';

class PaymentResultScreen extends StatefulWidget {
  const PaymentResultScreen({super.key});

  @override
  State<PaymentResultScreen> createState() => _PaymentResultScreenState();
}

class _PaymentResultScreenState extends State<PaymentResultScreen> {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SafeArea(
          child: Container(
            color: primaryColor,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: secondaryDark,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        height: size.height * .55,
                      ),
                       Positioned(
                        top: 30,
                        child: Container(
                          width: size.width * .90,
                          height: size.height * .80,
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
                                  width: 200,
                                  decoration:  BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: backgroundColor,
                                    border: Border.all(
                                      color: primaryLight, 
                                      width: 10.0,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 50),
                                  child: const Icon(Icons.check_circle, size: 180, color: primaryDark,)
                                ),
                                const SizedBox(height: 20,),
                                const Text("Success!",style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                const Text.rich(
                                  TextSpan(
                                    style: TextStyle(fontSize: 20),
                                    children: [
                                      TextSpan(
                                        text: "Receipt No. ", 
                                      ),
                                      TextSpan(
                                        text: "000001",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                const PaidBill(
                                  billerId: "123456",
                                  billerName: "CAPELCO",
                                  amount: 1500.00,
                                  isPaid: true,
                                ),
                                const Divider(
                                  color: Colors.black, 
                                  height: 20, 
                                  thickness: 1,
                                ),
                                const PaidBill(
                                  billerId: "123456",
                                  billerName: "WATER",
                                  amount: 1000.00,
                                  isPaid: true,
                                ),
                                const Spacer(),
                                const Text("Total Amount", style: TextStyle(fontSize: 18),),
                                const Text("P2500.00",style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 50,),
                              ]
                            ),
                          )
                        )
                      ),
                      Positioned(
                        bottom: 30,
                        child: Button(label: "DONE", press: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                        }, backgroundColor: secondaryDark, textSize: 18, isRounded: true,),
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
