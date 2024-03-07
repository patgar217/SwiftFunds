import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swiftfunds/DragonPay/bank_account.dart';
import 'package:swiftfunds/Models/payment_methods.dart';
import 'package:swiftfunds/Views/payment_result.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BankPaymentScreen extends StatefulWidget {
  final PaymentMethod paymentMethod;
  const BankPaymentScreen({super.key, required this.paymentMethod});

  @override
  State<BankPaymentScreen> createState() => _BankPaymentScreenState();
}

class _BankPaymentScreenState extends State<BankPaymentScreen> {

    final loginIdController = TextEditingController();
    final passwordController = TextEditingController();
    
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
                text: const TextSpan(
                  style: TextStyle(fontFamily: "Verdana",fontSize: 15.0, color: Colors.black),
                  children: [
                    TextSpan(text: 'Ref #: '),
                    TextSpan(
                      text: "MYLJKWWB98", style: TextStyle(color: Color(0xFF003399))
                    ),
                    TextSpan(text: ' : PHP'),
                    TextSpan(text: '2500'),
                    TextSpan(text: ' for Dragonpay payment.'),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(80.0),
                  1: FixedColumnWidth(5.0),
                  2: FixedColumnWidth(200.0),
                },
                children: [
                  TableRow(
                    children: [
                      const TableCell(
                        child: Align(
                          alignment: Alignment.centerLeft, 
                          child: Text("Login Id", style: TextStyle(fontFamily: "Verdana",fontSize: 15.0,))
                        )
                      ),
                      const TableCell(child: SizedBox(width:5),),
                      TableCell(
                        child: SizedBox(
                          height: 25,
                          child: TextFormField(
                            obscureText: false,
                            controller: loginIdController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(118, 118, 118, 1.0)// Set the border color to grey
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                  const TableRow(
                    children: [
                      TableCell(child: SizedBox(height: 5,)),
                      TableCell(child: SizedBox(height: 5,)),
                      TableCell(child: SizedBox(height: 5,))
                    ]
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Align(
                          alignment: Alignment.centerLeft, 
                          child: Text("Password", style: TextStyle(fontFamily: "Verdana",fontSize: 15.0,))
                        )
                      ),
                      const TableCell(child: SizedBox(width:5),),
                      TableCell(
                        child: SizedBox(
                          height: 25,
                          child: TextFormField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(118, 118, 118, 1.0)// Set the border color to grey
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  )
                ],
              ),
              const SizedBox(height: 10,),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> BankAccountScreen(paymentMethod: widget.paymentMethod)));
                      },
                      child: const Text("Continue", style: TextStyle(fontFamily: "Verdana", fontSize: 13.0, color: Colors.black, height: 1)),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const PaymentResultScreen(isSuccess: false,)));
                      },
                      child: const Text("Cancel", style: TextStyle(fontFamily: "Verdana", fontSize: 13.0, color: Colors.black, height: 1)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontFamily: "Verdana"),
                  children: [
                    TextSpan(
                      text: 'What is this?',
                      style: const TextStyle(
                        fontSize: 10.0,
                         color: Color(0xFF003399),
                         decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF003399),
                          decorationThickness: 1, 
                        ),
                        recognizer: TapGestureRecognizer()..onTap= () => launchUrlString('https://www.dragonpay.ph/faq')
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}