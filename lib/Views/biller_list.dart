import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/biller.dart';
import 'package:swiftfunds/Components/colors.dart';

class BillerListScreen extends StatelessWidget {
  final String categoryName;
  final IconData icon;
  const BillerListScreen({super.key, required this.categoryName, required this.icon});

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
                              Text(categoryName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), 
                              const SizedBox(height: 10),
                              Biller(icon: icon, billerName: "Capiz Electrical Cooperative",),
                              const BillerDivider(),
                              Biller(icon: icon, billerName: "Capiz Electrical Cooperative",),
                              const BillerDivider(),
                              Biller(icon: icon, billerName: "Capiz Electrical Cooperative",),
                              const BillerDivider(),
                              Biller(icon: icon, billerName: "Capiz Electrical Cooperative",),
                              const BillerDivider(),
                              Biller(icon: icon, billerName: "Capiz Electrical Cooperative",),
                              const BillerDivider(),
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
