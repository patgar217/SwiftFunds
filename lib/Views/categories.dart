import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/category.dart';
import 'package:swiftfunds/Components/current_billers_list.dart';



class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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
                      const Positioned(
                        top: 75,
                        child: CurrentBillersList()
                      ),
                      Positioned(
                        top:205,
                        child: Container(
                          width: size.width * .95,
                          height: 405,
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: const BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Categories",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5,),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Category(icon: Icons.lightbulb, categoryName: "Electric Utilities"),
                                  Category(icon: Icons.water_drop, categoryName: "Water Utilities"),
                                  Category(icon: Icons.router, categoryName: "Internet"),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Category(icon: Icons.cable, categoryName: "Cable"),
                                  Category(icon: Icons.credit_card, categoryName: "Credit Card"),
                                  Category(icon: Icons.real_estate_agent, categoryName: "Loans"),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Category(icon: Icons.sim_card, categoryName: "Telecoms"),
                                  const Category(icon: Icons.phone_in_talk, categoryName: "Mobile Load"),
                                  Container(
                                    width: (size.width * .80)/3,
                                    height: 110,
                                    color: backgroundColor,
                                    padding: const EdgeInsets.all(5.0)
                                    )
                                ],
                              ),
                            ],
                          )
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}