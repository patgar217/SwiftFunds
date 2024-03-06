import 'package:flutter/material.dart';
import 'package:swiftfunds/DragonPay/payment_method.dart';
import 'package:swiftfunds/Models/users.dart';
import 'package:swiftfunds/Components/bill.dart';
import 'package:swiftfunds/Components/header.dart';
import 'package:swiftfunds/Components/button.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/my_bills.dart';


class HomeScreen extends StatefulWidget {
  final Users? profile;
  const HomeScreen({super.key, this.profile});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                          color: backgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0), // Adjust radius as desired
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        height: 150,
                      ),
                      Positioned(
                        top: 15,
                        child: Header(size: size, widget: widget),
                      ),
                      Positioned(
                        top: 70,
                        child: MyBills(size: size),
                      ),
                      const Positioned(
                        top: 240,
                        child: Column(
                          children: [
                            Bill(billName: "CAPELCO", billId: "123456789", isChecked: true, dueDays: "3", amount: 1500.00, icon: Icons.lightbulb,),
                            Bill(billName: "WATER", billId: "123456789", isChecked: true, dueDays: "5", amount: 1000.00, icon: Icons.water_drop),
                            Bill(billName: "INTERNET", billId: "123456789", isChecked: false, dueDays: "7", amount: 500.00, icon: Icons.router)
                          ],
                        )
                      ),
                      Positioned(
                        top: size.height * .88,
                        child: Button(label: "PAY BILLS", press: (){ 
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const PaymentMethodScreen()));
                        }, backgroundColor: secondaryDark, textSize: 18, isRounded: true,)
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}
