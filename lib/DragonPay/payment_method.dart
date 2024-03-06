import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentMethod {
  final String key;
  final String value;

  const PaymentMethod(this.key, this.value);
}

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  List<PaymentMethod> data = [
    const PaymentMethod("", "--- SELECT A PAYMENT OPTION ---"),
    const PaymentMethod("DPAY", "Dragonpay Prepaid Credits"),
    const PaymentMethod("DPWL", "Dragonpay Wallet"),
    const PaymentMethod("CC", "Credit/Debit Cards"),
    const PaymentMethod("", "--- ONLINE BANKING / E-WALLET ---"),
    const PaymentMethod("BOC", "Bank of Commerce Online"),
    const PaymentMethod("BDO", "BDO Internet Banking"),
    const PaymentMethod("BPIA", "BPI Online/Mobile"),
    const PaymentMethod("CEBB", "Cebuana Lhuillier Rural Bank"),
    const PaymentMethod("CBCB", "China Bank Online Bills Payment"),
    const PaymentMethod("CBDD", "China Bank Online Direct Debit (NEW)"),
    const PaymentMethod("INPY", "Instapay using any bank/ewallet (NEW)"),
    const PaymentMethod("LBPA", "Landbank ATM Online"),
    const PaymentMethod("MAYB", "Maybank Online Banking"),
    const PaymentMethod("MBTC", "Metrobankdirect"),
    const PaymentMethod("PBCM", "PBCom Online Banking"),
    const PaymentMethod("PSNT", "PESONet from any bank/ewallet (NEW)"),
    const PaymentMethod("PSB", "PSBank Online"),
    const PaymentMethod("RCBC", "RCBC Online Banking"),
    const PaymentMethod("RCDD", "RCBC Online Direct Debit (NEW)"),
    const PaymentMethod("RSB", "RobinsonsBank Online Bills Payment"),
    const PaymentMethod("SBC", "Security Bank Online Bills Payment"),
    const PaymentMethod("BOG", "Test Bank Online"),
    const PaymentMethod("UCPB", "UCPB Connect/Mobile"),
    const PaymentMethod("UBP5", "Unionbank Internet Banking"),
    const PaymentMethod("UBDD", "Unionbank Online Direct Debit (NEW)"),
    const PaymentMethod("ABQR", "(NEW) QR PH"),
    const PaymentMethod("AAA", "Bitcoin / Ethereum / Tether"),
    const PaymentMethod("BITC", "Coins.ph"),
    const PaymentMethod("BTCN", "Coins.ph (New)"),
    const PaymentMethod("FTPY", "Fortune Pay"),
    const PaymentMethod("GCSB", "GCash Bills Pay"),
    const PaymentMethod("MRCO", "MarCoPay Wallet"),
    const PaymentMethod("MNYB", "Moneybees"),
    const PaymentMethod("PYMB", "PayMaya Bills Pay"),
    const PaymentMethod("POCH", "Pouch Wallet"),
    const PaymentMethod("RCDK", "RCBC Diskartech"),
    const PaymentMethod("XNPY", "SG/HK Online Banking"),
    const PaymentMethod("TAYO", "TayoCash"),
    const PaymentMethod("MNYG", "Togetech Moneygment"),
    const PaymentMethod("", "--- OVER-THE-COUNTER/ATM BANKING ---"),
    const PaymentMethod("AUB", "AUB Online/Cash Payment"),
    const PaymentMethod("BNRX", "BDO Network Bank (formerly ONB) Cash Dep"),
    const PaymentMethod("BPXB", "BPI Bills Payment"),
    const PaymentMethod("CBXB", "China Bank Cash Payment"),
    const PaymentMethod("EWXB", "EastWest Online/Cash Payment"),
    const PaymentMethod("I2I", "I2I Rural Banks"),
    const PaymentMethod("LBXB", "Landbank Cash Payment"),
    const PaymentMethod("MBXB", "Metrobank Cash Payment"),
    const PaymentMethod("NTB", "Netbank Notebook"),
    const PaymentMethod("PNXB", "PNB Cash Payment"),
    const PaymentMethod("PNBB", "PNB e-Banking Bills Payment"),
    const PaymentMethod("RCXB", "RCBC ATM/Cash Payment"),
    const PaymentMethod("RSBB", "RobinsonsBank Over-the-Counter"),
    const PaymentMethod("SBCB", "Security Bank Cash Payment"),
    const PaymentMethod("BOGX", "Test Bank Over-the-Counter"),
    const PaymentMethod("UCXB", "UCPB ATM/Cash Payment"),
    const PaymentMethod("UBXB", "Unionbank Cash Payment"),
    const PaymentMethod("","--- OVER-THE-COUNTER OTHERS ---"),
    const PaymentMethod("711", "7-Eleven"),
    const PaymentMethod("CEBL", "Cebuana Lhuillier"),
    const PaymentMethod("CVM", "CVM Pawnshop"),
    const PaymentMethod("ECPY", "ECPay (GCash/Payment Centers)"),
    const PaymentMethod("MLH", "M. Lhuillier"),
    const PaymentMethod("PLWN", "Palawan Pawnshop"),
    const PaymentMethod("PRHB", "Perahub"),
    const PaymentMethod("POSB", "Posible Partners (Family Mart, Phoenix)"),
    const PaymentMethod("RDP", "RD Pawnshop"),
    const PaymentMethod("RDS", "Robinsons Dept Store"),
    const PaymentMethod("RLNT", "RuralNet Banks and Coops"),
    const PaymentMethod("SMR", "SM Dept/Supermarket/Savemore Counter"),
    const PaymentMethod("TBTG", "Tambunting Pawnshop"),
    const PaymentMethod("USSC", "USSC"),
    const PaymentMethod("VLRC", "Villarica Pawnshop")
  ];
  late PaymentMethod selectedValue = data.first;
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
                            selectedValue = newValue?? data.first;
                          });
                        },
                        items: data.map((PaymentMethod kv) {
                          return DropdownMenuItem<PaymentMethod>(
                            value: kv,
                            child: Text(" ${kv.value}", style: const TextStyle(fontSize: 15)),
                          );
                        }).toList(),
                        isExpanded: true,
                      )
                    )
                  ),
                ],
              ),
              const SizedBox(height: 10),
              selectedValue.key == "" ? const Text("Select from the available fund sources", style: TextStyle(fontSize: 15, fontFamily: "Verdana", color: Colors.red)) : const SizedBox(),
              selectedValue.key != "" && !isAgree && isSubmit ? const Text("You must accept our terms and conditions first before proceeding", style: TextStyle(fontSize: 15, fontFamily: "Verdana", color: Colors.red)) : const SizedBox(),
              selectedValue.key == "" || (selectedValue.key != "" && !isAgree && isSubmit) ? const SizedBox(height: 10) : const SizedBox(),
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
                            fontSize: 16.0,
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
                padding: const EdgeInsets.symmetric(horizontal: 6),
                width: 150,
                height: 40,
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
                  },
                  child: const Text("Select", style: TextStyle(fontFamily: "Verdana", fontSize: 15.0, color: Colors.black)),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}