import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/biller_widget.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Models/biller.dart';
import 'package:swiftfunds/Services/biller_service.dart';

class BillerListScreen extends StatefulWidget {
  final String categoryName;
  final IconData icon;
  final int categoryId; 
  
  const BillerListScreen({super.key, required this.categoryName, required this.icon, required this.categoryId});

  @override
  State<BillerListScreen> createState() => _BillerListScreenState();
}

class _BillerListScreenState extends State<BillerListScreen> {
  late List<Biller> billers;
  bool isLoaded = false;

  final billerService = BillerService();

  @override
  void initState() {
    super.initState();
    loadBillers();
  }

  loadBillers() async {
    billers = await billerService.getBillersByCategory(widget.categoryId);

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return BillerListWidget(widget: widget, billers: billers);
    } else {
      return const Center(child: CircularProgressIndicator());
    }

  }
}

class BillerListWidget extends StatelessWidget {
  const BillerListWidget({
    super.key,
    required this.widget,
    required this.billers,
  });

  final BillerListScreen widget;
  final List<Biller> billers;

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
                        top: 70,
                        child: Container(
                          width: size.width * .95,
                          height: size.height * .85,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: const BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.categoryName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
                              const SizedBox(height: 10),
                              SizedBox(
                                height: size.height * .85 - 50,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: billers.map((biller) {
                                      return Column(
                                        children: [
                                          BillerWidget(biller: biller, categoryIcon: widget.icon,),
                                          const BillerDivider(),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ]
                          )
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

class BillerDivider extends StatelessWidget {
  const BillerDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: secondaryColor, 
      height: 20, 
      thickness: 1,
      indent: 10,
      endIndent: 10,
    );
  }
}
