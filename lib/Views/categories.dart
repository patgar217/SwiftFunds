import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/category_widget.dart';
import 'package:swiftfunds/Components/current_billers_list.dart';
import 'package:swiftfunds/Models/category.dart';
import 'package:swiftfunds/Models/current_biller.dart';
import 'package:swiftfunds/Services/authentication_service.dart';
import 'package:swiftfunds/Services/category_service.dart';
import 'package:swiftfunds/Services/current_biller_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  late List<CurrentBiller> currentBillers;
  late List<Category> categories;
  bool isLoaded = false;
  
  final authService = AuthenticationService();
  final currentBillerService = CurrentBillerService();
  final categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    loadCategoriesAndBillers();
  }

  loadCategoriesAndBillers() async {

    int loggedId = await authService.getLoggedId();

    currentBillers = await currentBillerService.getCurrentBillersByUserId(loggedId);
    categories = await categoryService.getCategories();

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoaded) {
      return CategoriesScreenWidget(currentBillers: currentBillers, categories: categories,);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class CategoriesScreenWidget extends StatelessWidget {
  const CategoriesScreenWidget({
    super.key,
    required this.currentBillers,
    required this.categories
  });

  final List<Category> categories;
  final List<CurrentBiller> currentBillers;

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
                      if (currentBillers.isNotEmpty) Positioned(
                        top: 70,
                        child: CurrentBillersList(currentBillers: currentBillers)
                      ),
                      Positioned(
                        top: currentBillers.isNotEmpty ? 205 : 70,
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
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Text("Categories",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5,),
                              GridView.count(
                                crossAxisCount: 3, // Adjust for desired number of columns
                                mainAxisSpacing: 15.0, // Spacing between rows
                                crossAxisSpacing: 15.0,
                                shrinkWrap: true,
                                children: categories.map((category) {
                                  return CategoryWidget(category: category);
                                }).toList(),
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