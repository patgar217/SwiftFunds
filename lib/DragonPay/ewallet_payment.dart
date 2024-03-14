import 'package:flutter/material.dart';
import 'package:swiftfunds/Models/payment.dart';
import 'package:swiftfunds/Models/payment_methods.dart';
import 'package:swiftfunds/Views/payment_result.dart';

class EWalletPaymentScreen extends StatefulWidget {
  final PaymentMethod paymentMethod;
  final Payment payment;
  const EWalletPaymentScreen({super.key, required this.paymentMethod, required this.payment});

  @override
  State<EWalletPaymentScreen> createState() => _EWalletPaymentScreenState();
}

class _EWalletPaymentScreenState extends State<EWalletPaymentScreen> {
  final acctController = TextEditingController();
  final pinController = TextEditingController();
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
              Image.asset(
                widget.paymentMethod.imageFile,
                fit: BoxFit.cover, // This ensures the image fills the container
              ),
              const SizedBox(height: 15,),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontFamily: "Verdana",fontSize: 15.0, color: Colors.black),
                  children: [
                    const TextSpan(text: 'Pay using your '),
                    TextSpan(
                      text: widget.paymentMethod.name, style: const TextStyle(color: Color(0xFF003399))
                    ),
                    const TextSpan(text: ' account...'),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Table(
                columnWidths: const {
                  0: FixedColumnWidth(150.0),
                  1: FixedColumnWidth(5.0),
                  2: FixedColumnWidth(200.0),
                },
                children: [
                  TableRow(
                    children: [
                      const TableCell(
                        child: Align(
                          alignment: Alignment.centerRight, 
                          child: Text("Email or Mobile No", style: TextStyle(fontFamily: "Verdana",fontSize: 15.0,))
                        )
                      ),
                      const TableCell(child: SizedBox(width:5),),
                      TableCell(
                        child: SizedBox(
                          height: 25,
                          child: TextFormField(
                            obscureText: false,
                            controller: acctController,
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
                          alignment: Alignment.centerRight, 
                          child: Text("PIN", style: TextStyle(fontFamily: "Verdana",fontSize: 15.0,))
                        )
                      ),
                      const TableCell(child: SizedBox(width:5),),
                      TableCell(
                        child: SizedBox(
                          height: 25,
                          child: TextFormField(
                            obscureText: true,
                            controller: pinController,
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
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
                        child: Text("Pay ₱${widget.payment.totalAmount.toStringAsFixed(2)}", style: const TextStyle(fontFamily: "Verdana", fontSize: 13.0, color: Colors.black, height: 1)),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      width: 130,
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
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentResultScreen(isSuccess: false,payment: widget.payment)));
                        },
                        child: const Text("Cancel", style: TextStyle(fontFamily: "Verdana", fontSize: 13.0, color: Colors.black, height: 1)),
                      ),
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