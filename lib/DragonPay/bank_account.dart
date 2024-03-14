import 'package:flutter/material.dart';
import 'package:swiftfunds/Models/bank_accounts.dart';
import 'package:swiftfunds/Models/payment.dart';
import 'package:swiftfunds/Models/payment_methods.dart';
import 'package:swiftfunds/Views/payment_result.dart';

class BankAccountScreen extends StatefulWidget {
  final PaymentMethod paymentMethod;
  final Payment payment;
  const BankAccountScreen({super.key, required this.paymentMethod, required this.payment});

  @override
  State<BankAccountScreen> createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
    late BankAccount selectedValue = bankAccounts.first;
    
    @override
    Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    widget.paymentMethod.imageFile,
                    fit: BoxFit.cover, // This ensures the image fills the container
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/dragon-pay-logo.png',
                    width: 100,
                    height: 50
                  ),
                ],
              ),
              const SizedBox(height: 15,),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontFamily: "Verdana",fontSize: 15.0, color: Colors.black),
                  children: [
                    const TextSpan(text: 'Choose from your available bank accounts below where to charge the '),
                    const TextSpan(
                      text: "PHP ", style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                      text: widget.payment.totalAmount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold)
                    ),
                    const TextSpan(text: ' to. Press the '),
                    const TextSpan(
                      text: "Pay", style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    const TextSpan(text: ' button only '),
                    const TextSpan(
                      text: "once", style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    const TextSpan(text: ' and wait for result.'),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              const Text("Select Account", style: TextStyle(fontFamily: "Verdana",fontSize: 15.0,)),
              Container(
                width: 320,
                height: 25,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  border: Border.all( // Add a border around all sides
                    color: const Color.fromRGBO(133, 133, 133, 1.0), // Set the desired border color
                    width: 1, // Optional: Set the border width (default is 1.0)
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<BankAccount>(
                    value: selectedValue,
                    onChanged: (BankAccount? newValue) {
                      setState(() {
                        selectedValue = newValue?? bankAccounts.first;
                      });
                    },
                    items: bankAccounts.map((BankAccount kv) {
                      return DropdownMenuItem<BankAccount>(
                        value: kv,
                        child: Text("PHP ${kv.type} x-${kv.endNum} | ${kv.amount}", style: const TextStyle(fontSize: 15, color: Colors.black)),
                      );
                    }).toList(),
                    isExpanded: true,
                  )
                )
              ),
              const SizedBox(height: 30,),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF), 
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all( // Add a border around all sides
                        color: const Color.fromRGBO(118, 118, 118, 1.0), // Set the desired border color
                        width: 1, // Optional: Set the border width (default is 1.0)
                      ),
                    ),
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentResultScreen(isSuccess: true, payment: widget.payment)));
                      },
                      child: const Text("Pay", style: TextStyle(fontFamily: "Verdana", fontSize: 13.0, color: Colors.black, height: 1)),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Container(
                    width: 100,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEFEF), 
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all( // Add a border around all sides
                        color: const Color.fromRGBO(118, 118, 118, 1.0), // Set the desired border color
                        width: 1, // Optional: Set the border width (default is 1.0)
                      ),
                    ),
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentResultScreen(isSuccess: false, payment: widget.payment)));
                      },
                      child: const Text("Cancel", style: TextStyle(fontFamily: "Verdana", fontSize: 13.0, color: Colors.black, height: 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}