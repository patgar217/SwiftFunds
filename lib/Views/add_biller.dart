import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/button.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/textfield.dart';
import 'package:swiftfunds/Views/home.dart';

class AddBillerScreen extends StatefulWidget {
  final String billerName;
  final String? amount;
  final String? acctNumber;
  final String? dueDate;
  final String? acctName;
  final String? billName;
  const AddBillerScreen({super.key, required this.billerName, this.amount, this.acctNumber, this.dueDate, this.acctName, this.billName});

  @override
  State<AddBillerScreen> createState() => _AddBillerScreenState();
}

class _AddBillerScreenState extends State<AddBillerScreen> {
  late final amountController = TextEditingController(text: widget.amount ?? "");
  late final dueDateController = TextEditingController(text: widget.dueDate ?? "");
  late final acctNumberController = TextEditingController(text: widget.acctNumber ?? "");
  late final acctNameController = TextEditingController(text: widget.acctName ?? "");
  late final billNameController = TextEditingController(text: widget.billName ?? "");

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
                        child: const Text("Add Bill",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),)
                      ),
                       Positioned(
                        top: 75,
                        child: Container(
                          width: size.width * .95,
                          height: 620,
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
                              const Text("Bill Details", style: TextStyle(fontSize: 12, color: secondaryDark)),
                              const Divider(
                                color: secondaryColor, 
                                height: 10, 
                                thickness: 1,
                              ),
                              const SizedBox(height: 5,),
                              const Text("Amount", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                              InputField(hint: "P0.00", icon: Icons.monetization_on, controller: amountController),

                              const Spacer(),
                              const Text("Due Date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                              InputField(hint: "MM/DD/YYYY", icon: Icons.calendar_month, controller: dueDateController),

                              const SizedBox(height: 20,),
                              const Text("Biller Details", style: TextStyle(fontSize: 12, color: secondaryDark)),
                              const Divider(
                                color: secondaryColor, 
                                height: 10, 
                                thickness: 1,
                              ),
                              const SizedBox(height: 5,),
                              const Text("Bill Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                              InputField(hint: "Name of bill", icon: Icons.badge, controller: billNameController),

                              const Spacer(),
                              const Text("Account Number", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                              InputField(hint: "12 digit account number", icon: Icons.account_balance_wallet, controller: acctNumberController),

                              const Spacer(),
                              const Text("Account Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                              InputField(hint: "Account Name", icon: Icons.account_balance, controller: acctNameController),
                            ]
                          )
                        )
                      ),
                      Positioned(
                        bottom: 20,
                        child: Column(
                          children: [
                            Button(label: "SAVE", press: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                            }, backgroundColor: secondaryDark, textSize: 18, isRounded: true, widthRatio: .95,),
                            Button(label: "CANCEL", press: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                            }, backgroundColor: secondaryColor, textSize: 18, isRounded: true, widthRatio: .95,),
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