import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/biller.dart';
import 'package:swiftfunds/SQLite/database_service.dart';
import 'package:swiftfunds/Views/add_biller.dart';

class BillWidget extends StatefulWidget {
  final String currNickname;
  final String currId;
  final int dueDays;
  final bool isChecked;
  final double amount;
  final String image;
  final Bill bill;
  final Function(bool, Bill) triggerCheck;

  const BillWidget({super.key, required this.currNickname, required this.currId, required this.dueDays, required this.isChecked, required this.amount, required this.image, required this.triggerCheck, required this.bill});

  @override
  State<BillWidget> createState() => _BillWidgetState();
}

class _BillWidgetState extends State<BillWidget> {
  late bool isBillPaid = widget.isChecked;
  late Biller biller;
  final db = DatabaseService();
  
  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  loadProfile() async {
    biller = await db.getBillerById(widget.bill.currentBiller!.billerId);
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddBillerScreen(
          billerName: biller.name,
          bill: widget.bill,
          biller: biller,
          currentBiller: widget.bill.currentBiller!,
        ), ),);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size.width * .9,
        height: 110,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SizedBox(
          width: size.width * .9,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: secondaryDark,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: widget.image != "" ? CircleAvatar(
                          backgroundImage: AssetImage(widget.image),
                          radius: 10,
                        ): const Icon(Icons.account_balance_wallet, color: backgroundColor, size:45),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.currNickname, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, height: 1),), 
                          Text("ID: ${widget.currId}", style: const TextStyle(fontSize: 15))
                        ]
                      )
                    ],
                  ),
                  const Spacer(),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                      children: [
                        const TextSpan(
                          text: "Due in ", 
                        ),
                        TextSpan(
                          text: widget.dueDays.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: " days",
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Transform.scale(
                    scale: 1.6,
                    child: Checkbox(
                      activeColor: secondaryDark,
                      value: isBillPaid,
                      onChanged: (value){
                        widget.triggerCheck(!isBillPaid, widget.bill);
                        setState(() {
                          isBillPaid = !isBillPaid;
                        });
                      },
                    ),
                   ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 27, fontWeight: FontWeight.bold),
                      children: [
                        const TextSpan(text: '₱'),
                        TextSpan(
                          text: widget.amount.toStringAsFixed(2)
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
