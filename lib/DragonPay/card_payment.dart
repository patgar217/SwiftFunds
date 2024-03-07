
import 'package:flutter/material.dart';
import 'package:swiftfunds/Models/payment_methods.dart';
import 'package:swiftfunds/Views/payment_result.dart';

class CardPaymentScreen extends StatefulWidget {
  final PaymentMethod paymentMethod;
  const CardPaymentScreen({super.key, required this.paymentMethod});

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  
  final cardNumController = TextEditingController();
  final validDateController = TextEditingController();
  final cvvController = TextEditingController();
  final cardNameController = TextEditingController();
  final emailController = TextEditingController();
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              color: const Color(0xFFE84855),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Text(
                    "You are in Test Mode and any transactions made are simulated and not real.", 
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: "OpenSans"),),
                ),
              )
            ),
            Container(
              height: 50,
              color: const Color(0xFF4573FF),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'assets/logo-negative.png',
                        height: 35,
                        width: 35,
                      ),
                    ),
                    const SizedBox(width: 10,),
                    const Text(
                      "SwiftFunds", 
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: "OpenSans"),),
                  ],
                ),
              )
            ),
            Container(
              height: 50,
              color: const Color(0xFFF2F2F2).withOpacity(0.7),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 20,),
                    SizedBox(width: 10,),
                    Text(
                      "ORDER SUMMARY", 
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black, fontFamily: "OpenSans"),
                      ),
                  ],
                ),
              )
            ),
            const SizedBox(height: 30,),
            const Center(
              child: Text(
                "PAY BEFORE MARCH 6, 2024 at 3:20 PM",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF3D3D3D), fontFamily: "OpenSans"),
              ),
            ),
            const SizedBox(height: 3,),
            const Center(
              child: Text(
                "PHP 2500.00",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w300, color: Color(0xFF4573FF), fontFamily: "OpenSans"),
              )
            ),
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PAYMENT METHOD",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF3D3D3D), fontFamily: "OpenSans"),
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    color: const Color(0xFFEBEBEB).withOpacity(0.4), 
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.credit_card_outlined, size: 25, color: Color(0xFF4573FF),),
                              SizedBox(width: 5,),
                              Text(
                                "Credit / Debit Card", 
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: "OpenSans"),
                                ),
                            ],
                          ),
                          const SizedBox(height: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Card Number", 
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: "OpenSans"),
                              ),
                              const SizedBox(width: 3,),
                              Container(
                                height: 40,
                                color: Colors.white,
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 15, fontFamily: "OpenSans"),
                                  controller: cardNumController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(219, 219, 219, 1.0),
                                        width: 2
                                      ),
                                    ),
                                    hintText:"4000 0000 0000 1091",
                                    hintStyle: TextStyle(color: Color.fromRGBO(61, 61, 61, 0.2)),
                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10)
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Valid Thru", 
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: "OpenSans"),
                                      ),
                                      const SizedBox(width: 3,),
                                      Container(
                                        height: 40,
                                        width: 200,
                                        color: Colors.white,
                                        child: TextFormField(
                                          style: const TextStyle(fontSize: 15, fontFamily: "OpenSans"),
                                          controller: validDateController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(219, 219, 219, 1.0),
                                                width: 2
                                              ),
                                            ),
                                            hintText:"MM/YY",
                                            hintStyle: TextStyle(color: Color.fromRGBO(61, 61, 61, 0.2)),
                                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "CVN", 
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: "OpenSans"),
                                      ),
                                      const SizedBox(width: 3,),
                                      Container(
                                        width: 140,
                                        height: 40,
                                        color: Colors.white,
                                        child: TextFormField(
                                          style: const TextStyle(fontSize: 15, fontFamily: "OpenSans"),
                                          controller: cardNumController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromRGBO(219, 219, 219, 1.0),
                                                width: 2
                                              ),
                                            ),
                                            hintText:"CVN",
                                            hintStyle: TextStyle(color: Color.fromRGBO(61, 61, 61, 0.2)),
                                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10)
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              const Text(
                                "Cardholder Name", 
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: "OpenSans"),
                              ),
                              const SizedBox(width: 3,),
                              Container(
                                height: 40,
                                color: Colors.white,
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 15, fontFamily: "OpenSans"),
                                  controller: cardNameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(219, 219, 219, 1.0),
                                        width: 2
                                      ),
                                    ),
                                    hintText:"Juan dela Cruz",
                                    hintStyle: TextStyle(color: Color.fromRGBO(61, 61, 61, 0.2)),
                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10)
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15,),
                              const Text(
                                "Email Address", 
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: "OpenSans"),
                              ),
                              const SizedBox(width: 3,),
                              Container(
                                height: 40,
                                color: Colors.white,
                                child: TextFormField(
                                  style: const TextStyle(fontSize: 15, fontFamily: "OpenSans"),
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(219, 219, 219, 1.0),
                                        width: 2
                                      ),
                                    ),
                                    hintText:"payer@email.com",
                                    hintStyle: TextStyle(color: Color.fromRGBO(61, 61, 61, 0.2)),
                                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10)
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Center(
                                child: Container(
                                  width: 150,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00CF99), 
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: TextButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const PaymentResultScreen()));
                                    },
                                    child: const Text(
                                      "Pay Now", 
                                      style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 15.0, color: Colors.white, height: 1)),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}
