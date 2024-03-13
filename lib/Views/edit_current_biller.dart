import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/button_widget.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/textfield.dart';
import 'package:swiftfunds/Views/home.dart';

class EditCurrentBiller extends StatefulWidget {
  final String billerName;
  final String? acctNumber;
  final String? acctName;
  final String? billName;
  const EditCurrentBiller({super.key, required this.billerName, this.acctNumber, this.acctName, this.billName});

  @override
  State<EditCurrentBiller> createState() => _EditCurrentBillerState();
}

class _EditCurrentBillerState extends State<EditCurrentBiller> {
  late final acctNumberController = TextEditingController(text: widget.acctNumber ?? "");
  late final acctNameController = TextEditingController(text: widget.acctName ?? "");
  late final billNameController = TextEditingController(text: widget.billName ?? "");
  late final noOfPaymentsController = TextEditingController();

  List<String> billFrequency = [
    "Select",
    "Weekly",
    "Monthly",
    "Quarterly"
  ];
  late String selectedFrequency = billFrequency.first;

  bool isRepeat = false;

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
                        child: const Text("Add Bill", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
                      ),
                       Positioned(
                        top: 70,
                        child: Container(
                          width: size.width * .95,
                          height: isRepeat ? 470 : 400,
                          padding: const EdgeInsets.fromLTRB( 10, 5, 10, 10),
                          decoration: const BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(widget.billerName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: secondaryDark)),
                                  const Spacer(),
                                  IconButton(onPressed: (){}, icon: const Icon(Icons.edit, size: 25, color: tertiaryDark))
                                ],
                              ),
                              const SizedBox(height: 10,),
                              const Text("Biller Details", style: TextStyle(fontSize: 12, color: secondaryDark)),
                              const Divider(
                                color: secondaryColor, 
                                height: 5, 
                                thickness: 1,
                              ),
                              const SizedBox(height: 5,),
                              const Text("Bill Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                              InputField(hint: "Name of bill", icon: Icons.badge, controller: billNameController, height: 50),

                              const Spacer(),
                              const Text("Account Number", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                              InputField(hint: "12 digit account number", icon: Icons.account_balance_wallet, controller: acctNumberController, height: 50),

                              const Spacer(),
                              const Text("Account Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                              InputField(hint: "Account Name", icon: Icons.account_balance, controller: acctNameController, height: 50),

                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: Checkbox(
                                      activeColor: secondaryDark,
                                      value: isRepeat,
                                      onChanged: (value){
                                        setState(() {
                                          isRepeat = !isRepeat;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10,), 
                                  const Text("Repeat Payments", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              isRepeat ? Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Frequency", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                                      Container(
                                        width: (size.width * .9)/2,
                                        height: 50,
                                        padding: const EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: primaryLightest,
                                          border: Border.all( // Add a border around all sides
                                            color: primaryDark, // Set the desired border color
                                            width: 1, // Optional: Set the border width (default is 1.0)
                                          ),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: selectedFrequency,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedFrequency = newValue?? "Select";
                                              });
                                            },
                                            items: billFrequency.map((String kv) {
                                              return DropdownMenuItem<String>(
                                                value: kv,
                                                child: Text(kv, style: TextStyle(fontSize: 15, color: kv == "Select" ? primaryColor : Colors.black)),
                                              );
                                            }).toList(),
                                            isExpanded: true,
                                          )
                                        )
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("No. of Payments", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                                      InputField(hint: "10", controller: noOfPaymentsController, height: 50, width: (size.width * .85)/2 ),
                                    ],
                                  )
                                ],
                              ) : const SizedBox()
                            ]
                          )
                        )
                      ),
                      Positioned(
                        bottom: 10,
                        child: Column(
                          children: [
                            Button(label: "SAVE", press: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                            }, backgroundColor: secondaryDark, textSize: 18, isRounded: true, widthRatio: .95, marginTop: 10,),
                            Button(label: "CANCEL", press: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                            }, backgroundColor: secondaryColor, textSize: 18, isRounded: true, widthRatio: .95, marginTop: 10),
                          ],
                        ),
                      )
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