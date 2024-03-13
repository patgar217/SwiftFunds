import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swiftfunds/DragonPay/payment_method.dart';
import 'package:swiftfunds/Models/user.dart';
import 'package:swiftfunds/Components/bill_widget.dart';
import 'package:swiftfunds/Components/header.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/my_bills.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftfunds/SQLite/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? profile;
  bool isProfileLoaded = false;

  final db = DatabaseService();
  
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String loggedUserName = prefs.getString("loggedUserName") ?? "";

    profile = await db.getUser(loggedUserName);
    setState(() {
      isProfileLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isProfileLoaded) {
      return HomeWidget(size: size, profile: profile);
    } else {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
    required this.size,
    required this.profile,
  });

  final Size size;
  final User? profile;

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  bool isRedeem = false;
  bool isAll = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
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
                      top: 30,
                      child: Header(size: widget.size, profile: widget.profile),
                    ),
                    Positioned(
                      top: 80,
                      child: MyBills(size: widget.size),
                    ),
                    const Positioned(
                      top: 250,
                      child: Column(
                        children: [
                          BillWidget(billName: "CAPELCO", billId: "123456789", isChecked: true, dueDays: "3", amount: 1500.00, icon: Icons.lightbulb,),
                          BillWidget(billName: "WATER", billId: "123456789", isChecked: true, dueDays: "5", amount: 1000.00, icon: Icons.water_drop),
                          BillWidget(billName: "INTERNET", billId: "123456789", isChecked: false, dueDays: "7", amount: 500.00, icon: Icons.router)
                        ],
                      )
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: size.width,
                        color: primaryLight,
                        child: Column(
                          children: [
                            const Divider(height:1, thickness: 1, color: primaryLightest,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 15,),
                                const Text("Redeem 0 SwiftPoints", style: TextStyle(fontSize: 15),),
                                const Spacer(),
                                Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                    value: isRedeem,
                                    onChanged: (value) { setState(() => isRedeem = value);},
                                    activeColor: secondaryDark,
                                    trackColor: const Color.fromARGB(255, 214, 214, 214),
                                  ),
                                )
                              ],
                            ),
                            const Divider(height:1, thickness: 1, color: primaryLightest,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 15,),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 15,
                                      width: 15,
                                      child: Checkbox(
                                        value: isAll, 
                                        onChanged: (value){setState(() => isAll = !isAll);}
                                      )
                                    ),
                                    const SizedBox(width: 10,),
                                    const Text("All", style: TextStyle(fontSize: 15),)
                                  ],
                                ),
                                const Spacer(),
                                const Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Total ", 
                                        style: TextStyle(color: primaryDark, fontSize: 15),
                                      ),
                                      TextSpan(
                                        text: "P2500",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: secondaryDark),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  decoration: const BoxDecoration(color: secondaryDark),
                                  child: TextButton(
                                    onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> const PaymentMethodScreen()));},
                                    child: const Text("Pay Bills (2)", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold), ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
