import 'package:swiftfunds/SQLite/database_service.dart';

import '../Models/user.dart';
import 'package:flutter/material.dart';
import 'package:swiftfunds/Views/home.dart';
import 'package:swiftfunds/Views/signup.dart';
import 'package:swiftfunds/Components/button_widget.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({ super.key });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final usrNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoginTrue = false;

  final db = DatabaseService();
  
  login() async{
      final prefs = await SharedPreferences.getInstance();
      var res = await db.authenticate(User(username: usrNameController.text, password: passwordController.text));
      if(res == true){
        if(!mounted)return;
        prefs.setString("loggedUserName", usrNameController.text);
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
      }else{
        setState(() {
          isLoginTrue = true;
        });
      }
    }
    
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                    backgroundImage: AssetImage("assets/logo-negative.png"),
                    radius: 80,
                  ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: Text("Welcome to SwiftFunds!", style: TextStyle(fontSize: 30, color: primaryDark, fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text("Please sign in to continue", style: TextStyle(fontSize: 18, color: primaryDark)),
                ),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrNameController),
                InputField(hint: "Password", icon: Icons.lock, controller: passwordController, passwordInvisible: true,),

                isLoginTrue ? Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * .05, vertical: 5),
                      child: Text(
                        "Username or password is incorrect.",
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ) : const SizedBox(),
                Button(label: "LOGIN", backgroundColor: primaryDark, textSize: 20, press: (){
                  login();
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",style: TextStyle(color: Colors.grey),),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpScreen()));
                      },
                      child: const Text("SIGN UP", style: TextStyle(color: primaryDark),))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}