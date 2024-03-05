import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Views/add_biller.dart';


class Bill extends StatefulWidget {
  final String billName;
  final String billId;
  final String dueDays;
  final bool isChecked;
  final double amount;
  final IconData icon;

  const Bill({super.key, required this.billName, required this.billId, required this.dueDays, required this.isChecked, required this.amount, required this.icon});

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {

  @override
  Widget build(BuildContext context) {
    bool isBillPaid = widget.isChecked;
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){Navigator.of(context).push( MaterialPageRoute(builder: (context) => AddBillerScreen(billerName: widget.billName,), ),);},
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
                        decoration: const BoxDecoration(
                          color: secondaryDark,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Icon(widget.icon, color: backgroundColor, size:45),
                      ),
                      const SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.billName, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, height: 1),), 
                          Text("ID: ${widget.billId}", style: const TextStyle(fontSize: 15))
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
                          text: widget.dueDays,
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
                        setState(() {
                          isBillPaid = !isBillPaid;
                        });
                      },
                    ),
                   ),
                  const Spacer(),
                  Text("P${widget.amount}", style: const TextStyle(color: Colors.black, fontSize: 27, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
