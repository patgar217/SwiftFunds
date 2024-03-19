import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/payment_widget.dart';
import 'package:swiftfunds/Models/payment.dart';
import 'package:swiftfunds/SQLite/database_service.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  bool isPaymentsLoaded = false;
  late List<Payment> payments;

  final db = DatabaseService();
  
  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  loadPayments() async {
    final prefs = await SharedPreferences.getInstance();
    int loggedId = prefs.getInt("loggedId")!;

    payments = await db.getPayments(loggedId);
    
    setState(() {
      isPaymentsLoaded = true;
    });
  }
  
  @override
  Widget build(BuildContext context) {

    if (isPaymentsLoaded) {
      return Transactions(payments: payments);
    } else {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }
  }
}

class Transactions extends StatelessWidget {
  const Transactions({
    super.key,
    required this.payments,
  });

  final List<Payment> payments;

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
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                        ),
                        height: 60,
                      ),
                      Positioned(
                        top: 20,
                        left: size.width * .05,
                        child: const Text("Transaction History", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
                      ),
                      if (payments.isNotEmpty) Positioned(
                        top: 70,
                        height: size.height - 100,
                        child: SingleChildScrollView(
                          child: Column(
                            children: payments.map((payment) {
                              return PaymentWidget(payment: payment);
                            }).toList(),
                          ),
                        )
                      ) else Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.receipt_long, size: 150, color: primaryLight),
                            SizedBox(
                              width: size.width *.70, 
                              child: const Text("You don't have any transactions yet",textAlign: TextAlign.center, style: TextStyle(fontSize: 25, color: primaryLight), overflow: TextOverflow.clip,)),
                          ],
                        ),
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
