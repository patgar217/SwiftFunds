import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:swiftfunds/DragonPay/bank_payment.dart';
import 'package:swiftfunds/DragonPay/card_payment.dart';
import 'package:swiftfunds/DragonPay/ewallet_payment.dart';
import 'package:swiftfunds/Models/payment_methods.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {

  late PaymentMethod selectedValue = paymentMethods.first;
  late bool isAgree = false;
  late bool isSubmit = false;

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
                'assets/dragon-pay-logo.png',
                fit: BoxFit.cover, // This ensures the image fills the container
              ),
              const SizedBox(height: 15,),
              const Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 15, fontFamily: "Verdana"),
                  children: [
                    TextSpan(
                      text: "SwiftFunds is requesting for ", 
                    ),
                    TextSpan(
                      text: "PHP 2500.00",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: " [TEST ONLY]",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  const Text("Source ", style: TextStyle(fontSize: 15, fontFamily: "Verdana")),
                  const Spacer(),
                  Container(
                    width: 300,
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border.all( // Add a border around all sides
                        color: const Color.fromRGBO(133, 133, 133, 1.0), // Set the desired border color
                        width: 1, // Optional: Set the border width (default is 1.0)
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<PaymentMethod>(
                        value: selectedValue,
                        onChanged: (PaymentMethod? newValue) {
                          setState(() {
                            selectedValue = newValue?? paymentMethods.first;
                          });
                        },
                        items: paymentMethods.map((PaymentMethod kv) {
                          return DropdownMenuItem<PaymentMethod>(
                            value: kv,
                            child: Text(" ${kv.value}", style: TextStyle(fontSize: 15, color:(kv.type == PaymentType.others ? Colors.grey : Colors.black ))),
                          );
                        }).toList(),
                        isExpanded: true,
                      )
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10),
              selectedValue.key == "" && isSubmit ? const Text("Select from the available fund sources", style: TextStyle(fontSize: 15, fontFamily: "Verdana", color: Colors.red)) : const SizedBox(),
              selectedValue.key != "" && !isAgree && isSubmit ? const Text("You must accept our terms and conditions first before proceeding", style: TextStyle(fontSize: 15, fontFamily: "Verdana", color: Colors.red)) : const SizedBox(),
              selectedValue.key != "" && selectedValue.type == PaymentType.others && isAgree && isSubmit ? const Text("Source is not available for testing. Please select another source.", style: TextStyle(fontSize: 15, fontFamily: "Verdana", color: Colors.red)) : const SizedBox(),
              selectedValue.key == "" && isSubmit || (selectedValue.key != "" && !isAgree && isSubmit) ? const SizedBox(height: 10) : const SizedBox(),
              Row(
                children: [
                  SizedBox(
                    height: 15,
                    width: 15,
                    child: Checkbox(
                      activeColor: const Color(0xFF003399),
                      value: isAgree,
                      onChanged: (value){
                        setState(() {
                          isAgree = !isAgree;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10,),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontFamily: "Verdana",fontSize: 15.0),
                      children: [
                        const TextSpan(text: 'I agree to the ', style: TextStyle(color: Colors.black)),
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: const TextStyle(
                             color: Color(0xFF003399),
                             decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF003399),
                              decorationThickness: 1, 
                            ),
                            recognizer: TapGestureRecognizer()..onTap= () => launchUrlString('https://www.dragonpay.ph/terms-and-conditions')
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15,),
              Container(
                width: 100,
                height: 35,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF), 
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all( // Add a border around all sides
                    color: const Color.fromRGBO(118, 118, 118, 1.0), // Set the desired border color
                    width: 2, // Optional: Set the border width (default is 1.0)
                  ),
                ),
                child: TextButton(
                  onPressed: (){
                    setState(() {
                      isSubmit = true;
                    });
                    if(isAgree){
                      if(selectedValue.type == PaymentType.bank){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> BankPaymentScreen(paymentMethod: selectedValue)));
                      } else if(selectedValue.type == PaymentType.card){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CardPaymentScreen(paymentMethod: selectedValue)));
                      } else if(selectedValue.type == PaymentType.eWallet){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> EWalletPaymentScreen(paymentMethod: selectedValue)));
                      }
                    }
                  },
                  child: const Text("Select", style: TextStyle(fontFamily: "Verdana", fontSize: 13.0, color: Colors.black, height: 1)),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}