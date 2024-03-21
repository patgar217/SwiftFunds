import 'package:flutter/material.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Services/authentication_service.dart';
import 'package:swiftfunds/Views/under_construction.dart';
import 'package:swiftfunds/Views/login.dart';
import 'package:swiftfunds/Views/transaction_history.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  final authService = AuthenticationService();

  logout() {
    authService.logout();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 45.0,horizontal: 20),
              child: SizedBox(
                height: size.height*.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10,),
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/logo-negative.png"),
                      radius: 70,
                    ),
                    const Spacer(),
                    ListTile(
                      leading: const Icon(Icons.assignment,size: 30),
                      trailing: const Icon(Icons.arrow_right,size: 30),
                      title: const Text("Transaction History", style: TextStyle(fontSize: 18)),
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const TransactionHistoryScreen()));
                      }
                    ),
                    const Divider(
                      height: 7,
                      thickness: 1, 
                      color: primaryLight, 
                      indent: 10, 
                      endIndent: 10,),
                    ListTile(
                      leading: const Icon(Icons.monetization_on,size: 30),
                      trailing: const Icon(Icons.arrow_right,size: 30),
                      title: const Text("SwiftPoints", style: TextStyle(fontSize: 18)),
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const UnderConstructionScreen()));
                      }
                    ),
                    const Divider(
                      height: 5,
                      thickness: 1, 
                      color: primaryLight, 
                      indent: 10, 
                      endIndent: 10,),
                    ListTile(
                      leading: const Icon(Icons.settings,size: 30),
                      trailing: const Icon(Icons.arrow_right,size: 30),
                      title: const Text("Settings", style: TextStyle(fontSize: 18)),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const UnderConstructionScreen()));
                      }
                    ),
                    const Divider(
                      height: 7,
                      thickness: 1, 
                      color: primaryLight, 
                      indent: 10, 
                      endIndent: 10,),
                    ListTile(
                      leading: const Icon(Icons.help,size: 30),
                      trailing: const Icon(Icons.arrow_right,size: 30),
                      title: const Text("Help", style: TextStyle(fontSize: 18)),
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const UnderConstructionScreen()));
                      }
                    ),
                    const Divider(
                      height: 7,
                      thickness: 1, 
                      color: primaryLight, 
                      indent: 10, 
                      endIndent: 10,),
                    ListTile(
                      leading: const Icon(Icons.description,size: 30),
                      trailing: const Icon(Icons.arrow_right,size: 30),
                      title: const Text("Terms and Conditions", style: TextStyle(fontSize: 18)),
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const UnderConstructionScreen()));
                      }
                    ),
                    const Divider(
                      height: 7,
                      thickness: 1, 
                      color: primaryLight, 
                      indent: 10, 
                      endIndent: 10,),
                    ListTile(
                      leading: const Icon(Icons.logout,size: 30),
                      trailing: const Icon(Icons.arrow_right,size: 30),
                      title: const Text("Logout", style: TextStyle(fontSize: 18)),
                      onTap: (){
                        logout();
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                      }
                    ),
                    const Spacer(),
                    const Text("Conceptualized by: ", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                    const Text(
                      "Leanne Marie Joy Delfin, Kyle Faeldonia, \nLouise Marie F. Ignacio, Reemah Magbanua", 
                      textAlign: TextAlign.center,
                      style: TextStyle(color: primaryColor)
                    ),
                
                    const SizedBox(height: 20,),
                    const Text("Developed by:", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                    const Text("Patricia Marie Garcia", style: TextStyle(color: primaryColor)),

                    const SizedBox(height: 20,),
                    const Text("SwiftFunds © 2024", style: TextStyle(color: primaryDark, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 20,),
                
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}