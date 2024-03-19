import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swiftfunds/DragonPay/payment_method.dart';
import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/payment.dart';
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
  late User profile;
  bool isProfileLoaded = false;
  late List<Bill> pendingBills;

  final db = DatabaseService();
  
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String loggedUserName = prefs.getString("loggedUserName") ?? "";

    profile = (await db.getUser(loggedUserName))!;

    prefs.setInt("loggedId", profile.userId!);

    pendingBills = await db.getBillsByUserIdAndStatus(profile.userId!, "PENDING");

    pendingBills.sort((a, b) {
      final dateFormatter = DateFormat('MM-dd-yyyy');
      final dateA = dateFormatter.parse(a.dueDate);
      final dateB = dateFormatter.parse(b.dueDate);
      return dateA.compareTo(dateB);
    });
    setState(() {
      isProfileLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isProfileLoaded) {
      return HomeWidget(profile: profile, pendingBills: pendingBills,);
    } else {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key, this.profile, required this.pendingBills,
  });

  final User? profile;
  final List<Bill> pendingBills;

  int getDaysUntilDate(String dateString) {
    final formattedDate = DateFormat('MM-dd-yyyy').parse(dateString);

    final now = DateTime.now();

    final difference = formattedDate.difference(now);

    return difference.inDays;
  }

  double getTotalBill() {
    double total = 0.0;
    for (var bill in pendingBills) {
      total += bill.amount;
    }
    return total;
  }

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final db = DatabaseService();
  bool isRedeem = false;
  bool isAll = false;

  List<Bill> checkedBills = [];
  double checkedTotal = 0.00;
  double redeemLimit = 0.00;
  double canRedeemAmount = 0.00;
  double totalWithPoints = 0.00;

  void triggerCheck(bool isChecked, Bill bill ){
    if(isChecked){
      setState(() {
        checkedBills.add(bill);
        checkedTotal += bill.amount;
        redeemLimit = checkedTotal * 0.01;
      });
    }else{
      setState(() {
        checkedBills.remove(bill);
        checkedTotal -= bill.amount;
        redeemLimit = checkedTotal * 0.01;
      });
    }

    redeemPoints();
  }

  void redeemPoints(){
    if(widget.profile!.swiftpoints! >= 1){
      setState(() {
        canRedeemAmount = redeemLimit < widget.profile!.swiftpoints! ? redeemLimit : widget.profile!.swiftpoints!;
        totalWithPoints = isRedeem ? checkedTotal - canRedeemAmount : checkedTotal;
      });
    }else{
      setState(() {
        totalWithPoints = checkedTotal;
      });
    }
  }
  

  void createPayment() async {
    Payment initialPayment =  Payment(
      userId: widget.profile!.userId!, 
      totalAmount: checkedTotal,
      pointsEarned: 0.00,
      pointsRedeemed: isRedeem ? canRedeemAmount : 0.00,
      paymentDate: "",
      status: "PENDING",
      bills: checkedBills,
      totalAmountWithPoints: totalWithPoints
    );

    Payment result = await db.createPayment(initialPayment);
    result.bills = checkedBills;

    if(!mounted)return;
    Navigator.push(context, MaterialPageRoute(builder: (context)  => PaymentMethodScreen(payment: result)));
  }

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
                      child: Header(size: size, profile: widget.profile),
                    ),
                    Positioned(
                      top: 80,
                      child: MyBills(profile: widget.profile, totalBills: widget.getTotalBill(),),
                    ),
                    if (widget.pendingBills.isNotEmpty) Positioned(
                      top: 250,
                      height: size.height - 360,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: widget.pendingBills.map((bill) {
                            final currentBiller = bill.currentBiller;
                            if(currentBiller != null){
                            return BillWidget(
                                currNickname: currentBiller.nickname,
                                currId: currentBiller.acctNumber,
                                isChecked: false,
                                dueDays: widget.getDaysUntilDate(bill.dueDate),
                                amount: bill.amount,
                                image: currentBiller.logo,
                                triggerCheck: triggerCheck,
                                bill: bill
                              );}
                              return Text(bill.currentBillerId.toString());
                          }).toList(),
                        ),
                      )
                    ) else Positioned( 
                      top: 250,
                      height: size.height - 360,
                       child: Center(
                         child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             const Icon(Icons.fact_check_outlined, size: 150, color: primaryLight),
                             SizedBox(
                              width: size.width *.70, 
                              child: const Text("You don't have any pending bills",textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: primaryLight), overflow: TextOverflow.clip,)),
                           ],
                         ),
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
                                Text("Redeem ${canRedeemAmount.toStringAsFixed(2)} SwiftPoints", style: const TextStyle(fontSize: 15),),
                                const Spacer(),
                                Transform.scale(
                                  scale: 0.7,
                                  child: CupertinoSwitch(
                                    value: isRedeem,
                                    onChanged: (value) { 
                                      if(canRedeemAmount > 0.00){
                                        setState(() => isRedeem = value);
                                        redeemPoints();
                                      }
                                    },
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
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Total ", 
                                        style: TextStyle(color: primaryDark, fontSize: 18),
                                      ),
                                      TextSpan(
                                        text: "₱${totalWithPoints.toStringAsFixed(2)}",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: secondaryDark),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  decoration:  BoxDecoration(color: checkedBills.isEmpty ? Colors.grey : secondaryDark),
                                  child: TextButton(
                                    onPressed: (){
                                      checkedBills.isEmpty ? null : createPayment();
                                      },
                                    child: Text("Pay Bills (${checkedBills.length})", style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold), ),
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
