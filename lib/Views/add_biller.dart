import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftfunds/Components/button_widget.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/textfield.dart';
import 'package:swiftfunds/Models/bill.dart';
import 'package:swiftfunds/Models/biller.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/Services/bill_service.dart';
import 'package:swiftfunds/Services/current_biller_service.dart';
import 'package:swiftfunds/Services/date_time_service.dart';
import 'package:swiftfunds/Views/home.dart';

class AddBillerScreen extends StatefulWidget {
  final Biller? biller;
  final String billerName;
  final Bill? bill;
  final CurrentBiller? currentBiller;
  const AddBillerScreen({super.key, this.biller, required this.billerName, this.bill, this.currentBiller});

  @override
  State<AddBillerScreen> createState() => _AddBillerScreenState();
}

class _AddBillerScreenState extends State<AddBillerScreen> {
  late final amountController = TextEditingController(text: widget.bill != null  ? widget.bill!.amount.toString() :  "");
  late final dueDateController = TextEditingController(text: widget.bill != null  ? widget.bill!.dueDate.toString() :  "");
  late final acctNumberController = TextEditingController(text: widget.currentBiller != null  ? widget.currentBiller!.acctNumber :  "");
  late final acctNameController = TextEditingController(text: widget.currentBiller != null  ? widget.currentBiller!.acctName :  "");
  late final billNameController = TextEditingController(text: widget.currentBiller != null  ? widget.currentBiller!.nickname :  "");
  late final noOfPaymentsController = TextEditingController(text: widget.bill != null && widget.bill!.isRepeating ? widget.bill!.noOfPayments.toString() :  "");

  bool isEditing = false;
  bool canEditBiller = false;

  List<String> billFrequency = [
    "WEEKLY",
    "MONTHLY",
    "QUARTERLY"
  ];
  late String selectedFrequency = billFrequency[1];
  late int loggedId;
  final billService = BillService();
  final currentBillerService = CurrentBillerService();
  final dateTimeService = DateTimeService();

  bool isRepeat = false;

  @override
  void initState() {
    super.initState();
    loadCategoriesAndBillers();
  }

  loadCategoriesAndBillers() async {

    final prefs = await SharedPreferences.getInstance();
    loggedId = prefs.getInt("loggedId")!;

    if(widget.bill == null) {
      setState(() {
        isEditing = true;
      },);
    } else {
      setState(() {
        isRepeat = widget.bill!.isRepeating;
      },);
    }

    if((widget.bill != null && widget.currentBiller != null) || (widget.bill == null && widget.currentBiller == null)){
      setState(() {
        canEditBiller = true;
      });
    }
    if(widget.bill != null && widget.bill!.isRepeating && widget.bill!.frequency != null) {
      setState(() {
        selectedFrequency = billFrequency.firstWhere((element) => element == widget.bill!.frequency!);
      });
    }
  }
  bool isAmountCorrect = true;
  String amountError = "";

  bool isDueDateCorrect = true;
  String dueDateError = "";

  bool isNoOfPaymentsCorrect = true;
  String noOfPaymentsError = "";

  bool isNickNameCorrect = true;

  bool isAcctNumberCorrect = true;

  bool isAcctNameCorrect = true;
  
  bool validateBill() {
    checkAmount(amountController.text);
    checkDueDate(dueDateController.text);
    if(isRepeat){
      checkNoOfPayments(noOfPaymentsController.text);
    }
    setState(() {
      isNickNameCorrect = billNameController.text.isNotEmpty;
      isAcctNameCorrect = acctNameController.text.isNotEmpty;
      isAcctNumberCorrect = acctNumberController.text.isNotEmpty;
    });
    return isAmountCorrect && isDueDateCorrect && isNoOfPaymentsCorrect && isNickNameCorrect && isAcctNumberCorrect && isAcctNameCorrect;
  }

  void checkAmount(String amount){
    if(amount.isEmpty){
      setState(() {
        isAmountCorrect = false;
        amountError = "Please input the amount to be paid.";
      });
      return;
    }

    final regex = RegExp(r"^\s*[-+]?\d+(\.\d*)?\s*$");
    setState(() {
      isAmountCorrect = regex.hasMatch(amount);
      amountError = "Input is not a valid amount.";
    });
  }

  void checkDueDate(String dueDate){
    if(dueDate.isEmpty){
      setState(() {
        isDueDateCorrect = false;
        dueDateError = "Please input the due date of the bill.";
      });
      return;
    }

    final regex = RegExp(r"^(0?[1-9]|1[0-2])-(0?[1-9]|[12]\d|3[01])-\d{4}$");
    if(!regex.hasMatch(dueDate)){
      setState(() {
        isDueDateCorrect = false;
        dueDateError = "Invalid due date. Please follow the format: MM-DD-YYYY.";
      });
      return;
    }

    final now = DateTime.now();
    final parsedDate = dateTimeService.convertStringToNumberFormat(dueDate);
    setState(() {
      isDueDateCorrect = !parsedDate.isBefore(now);
      dueDateError = "Due date cannot be due.";
    });
  }
  
  void checkNoOfPayments(String noOfPayments){
     if(noOfPayments.isEmpty){
      setState(() {
        isNoOfPaymentsCorrect = false;
        noOfPaymentsError = "Field is required.";
      });
      return;
    }

    final regex = RegExp(r"^[0-9]+$");
    setState(() {
      isNoOfPaymentsCorrect = regex.hasMatch(noOfPayments);
      noOfPaymentsError = "Input is not a number.";
    });
  }

  
  void addBill() async {
    var res = 0;
    if(widget.biller != null){
      res = await billService.addBillWithBiller(widget.biller!, loggedId, billNameController.text, acctNameController.text, acctNumberController.text, dueDateController.text, double.parse(amountController.text), isRepeat, isRepeat ? selectedFrequency : "", noOfPaymentsController.text != '' ? int.parse(noOfPaymentsController.text) : 0);
    }else{
      res = await billService.addBillWithCurrentBiller(widget.currentBiller!, loggedId, dueDateController.text, double.parse(amountController.text), isRepeat, isRepeat ? selectedFrequency : "", noOfPaymentsController.text != '' ? int.parse(noOfPaymentsController.text) : 0);
    }
    if(res>0){
      if(!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
    }
  }


  void editBill() async {
    var res = await billService.editBill(widget.bill!, loggedId, dueDateController.text, double.parse(amountController.text), isRepeat, selectedFrequency, int.parse(noOfPaymentsController.text));
    var res1 = await currentBillerService.updateCurrentBiller(widget.currentBiller!, loggedId, widget.biller!, billNameController.text, acctNameController.text, acctNumberController.text);

    if(res>0 && res1>0){
      if(!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
    }
  }


  deleteBill() async {
    var res = await billService.deleteBill(widget.bill!);
    if(res>0){
      if(!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
    }
  }

  Future<bool> checkCurrentBiller() async {
    CurrentBiller currBiller = widget.currentBiller!;
    int billsLength = await currentBillerService.getBillsSize(currBiller);

    bool hasChanged = currBiller.acctName != acctNameController.text || currBiller.acctNumber != acctNumberController.text || currBiller.nickname != billNameController.text;

    return billsLength == 1 || !hasChanged;
  }

  void editAction() async {
    bool canEdit = await checkCurrentBiller();

    if(canEdit){
      editBill();
    }else{
      showEditAlert();
    }
  }

  void showEditAlert(){
    final yesButton = TextButton(
      child: const Text("Yes", style: TextStyle(color: Colors.red, fontSize: 15),),
      onPressed: () {
        Navigator.pop(context);
        editBill();
      },
    );

    final noButton = TextButton(
      child: const Text("No", style: TextStyle(color: Colors.grey, fontSize: 15),),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    final alert = AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      title: const Text("Warning", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),),
      content: const Text("Current Biller has other bills. Editing this would affect other bills. Would you like to procees?", style: TextStyle(fontSize: 15)),
      actions: [
        noButton,
        yesButton
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );

  }

  showDeleteAlert() {
    final yesButton = TextButton(
      child: const Text("Yes", style: TextStyle(color: Colors.red, fontSize: 15),),
      onPressed: () {
        Navigator.pop(context);
        deleteBill();
      },
    );

    final noButton = TextButton(
      child: const Text("No", style: TextStyle(color: Colors.grey, fontSize: 15),),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    final alert = AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      title: const Text("Warning", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),),
      content: const Text("Are you sure you want to delete this bill?", style: TextStyle(fontSize: 15)),
      actions: [
        noButton,
        yesButton
      ],
    );

    showDialog(
      context: context,
      builder: (context) => alert,
    );
  }

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
                        height: size.height - 120 - MediaQuery.of(context).viewInsets.bottom,
                        child: SingleChildScrollView(
                          child: Container(
                            width: size.width * .95,
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
                                isEditing ? 
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * .80,
                                      child: Text(widget.billerName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: secondaryDark), overflow: TextOverflow.ellipsis,)
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: 10,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0), 
                                        onPressed: (){}, 
                                        icon: const Icon(Icons.save, size: 10, color: backgroundColor)
                                      ),
                                    )
                                  ],
                                )
                                :
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * .65,
                                      child: Text(widget.billerName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: secondaryDark), overflow: TextOverflow.ellipsis,)
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: 40,
                                      child: IconButton(
                                        onPressed: (){
                                          setState(() {
                                            isEditing = true;
                                          });
                                        }, 
                                        icon: const Icon(Icons.edit, size: 25, color: tertiaryDark)
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0), 
                                        onPressed: (){
                                          showDeleteAlert();
                                        }, 
                                        icon: const Icon(Icons.delete, size: 25, color: quarternaryColor)
                                      ),
                                    )
                                  ],
                                ),
                                const Text("Bill Details", style: TextStyle(fontSize: 12, color: secondaryDark)),
                                const Divider(
                                  color: secondaryColor, 
                                  height: 5, 
                                  thickness: 1,
                                ),
                                const SizedBox(height: 5,),
                                const Text("Amount", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                                InputField(hint: "0.00", icon: Icons.monetization_on, controller: amountController, height: 50, isEditable: isEditing, isError: !isAmountCorrect,),
                                if(!isAmountCorrect) Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(amountError, textAlign: TextAlign.left, style: const TextStyle(color: Colors.red),),
                                ),
                                
                                const SizedBox(height: 5,),
                                const Text("Due Date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                                InputField(hint: "MM-DD-YYYY", icon: Icons.calendar_month, controller: dueDateController, height: 50, isEditable: isEditing, isError: !isDueDateCorrect,),
                                if(!isDueDateCorrect) Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(dueDateError, textAlign: TextAlign.left, style: const TextStyle(color: Colors.red),),
                                ),

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
                                            if(isEditing && canEditBiller){
                                              isRepeat = !isRepeat;
                                            }
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
                                              color: isEditing && canEditBiller ? primaryDark : backgroundColor, // Set the desired border color
                                              width: 1, // Optional: Set the border width (default is 1.0)
                                            ),
                                          ),
                                          child: IgnorePointer(
                                            ignoring: !(isEditing && canEditBiller) ,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                value: selectedFrequency,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    selectedFrequency = newValue?? "MONTHLY";
                                                  });
                                                },
                                                items: billFrequency.map((String kv) {
                                                  return DropdownMenuItem<String>(
                                                    value: kv,
                                                    child: Text(kv, style: (isEditing && canEditBiller) ? const TextStyle(fontSize: 15, color: Colors.black) : const TextStyle(color: primaryDark, fontSize: 18, fontWeight: FontWeight.w600)),
                                                  );
                                                }).toList(),
                                                isExpanded: true,
                                              )
                                            ),
                                          )
                                        ),
                                        if(!isNoOfPaymentsCorrect) const Padding(
                                            padding: EdgeInsets.only(bottom: 10.0),
                                            child: Text("", textAlign: TextAlign.left, style: TextStyle(color: Colors.red),),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("No. of Payments", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                                        InputField(hint: "10", controller: noOfPaymentsController, height: 50, width: (size.width * .85)/2 , isEditable: isEditing && canEditBiller, isError: !isNoOfPaymentsCorrect,),
                                        if(!isNoOfPaymentsCorrect) Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Text(noOfPaymentsError, textAlign: TextAlign.left, style: const TextStyle(color: Colors.red),),
                                        ),
                                      ],
                                    ),
                                  ],
                                ) : const SizedBox(),
                                const SizedBox(height: 15,),
                                const Text("Biller Details", style: TextStyle(fontSize: 12, color: secondaryDark)),
                                const Divider(
                                  color: secondaryColor, 
                                  height: 5, 
                                  thickness: 1,
                                ),
                                const SizedBox(height: 5,),
                                const Text("Bill Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                                InputField(hint: "Name of bill", icon: Icons.badge, controller: billNameController, height: 50, isEditable: isEditing && canEditBiller, isError: !isNickNameCorrect,),
                                if(!isNickNameCorrect) const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text("Bill name is required.", textAlign: TextAlign.left, style: TextStyle(color: Colors.red),),
                                ),
                                        
                                const SizedBox(height: 5,),
                                const Text("Account Number", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                                InputField(hint: "Account Number", icon: Icons.account_balance_wallet, controller: acctNumberController, height: 50, isEditable: isEditing && canEditBiller, isError: !isAcctNumberCorrect,),
                                if(!isAcctNumberCorrect) const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text("Account number is required.", textAlign: TextAlign.left, style: TextStyle(color: Colors.red),),
                                ),
                                        
                                const SizedBox(height: 5,),
                                const Text("Account Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryDark)),
                                InputField(hint: "Account Name", icon: Icons.account_balance, controller: acctNameController, height: 50, isEditable: isEditing && canEditBiller, isError: !isAcctNameCorrect,),
                                if(!isAcctNameCorrect) const Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text("Account name is required.", textAlign: TextAlign.left, style: TextStyle(color: Colors.red),),
                                ),
                                isEditing ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Button(label: "CANCEL", press: (){
                                      if(widget.bill != null){
                                        setState(() {
                                          isEditing = false;
                                        });
                                      }else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                                      }
                                    }, backgroundColor: secondaryColor, textSize: 15, isRounded: true, widthRatio: .25, marginTop: 10),
                                    const SizedBox(width: 5,),
                                    Button(label: "SAVE", press: (){
                                      bool isValidated = validateBill();
                                      if(isValidated){
                                        if(widget.bill != null){
                                          editAction();
                                        }else{
                                          addBill();
                                        }
                                      }
                                    }, backgroundColor: secondaryDark, textSize: 15, isRounded: true, widthRatio: .25, marginTop: 10,),
                                  ],
                                ) : const SizedBox(),
                              ]
                            )
                          ),
                        )
                      ),
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