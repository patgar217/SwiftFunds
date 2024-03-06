import '../Models/users.dart';
import 'package:flutter/material.dart';
import '../SQLite/database_helper.dart';
import 'package:swiftfunds/Views/home.dart';
import 'package:swiftfunds/Views/signup.dart';
import 'package:swiftfunds/Components/button.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/textfield.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({ super.key });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final usrNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoginTrue = false;

  final db = DatabaseHelper();
    login()async{
      Users? usrDetails = await db.getUser(usrNameController.text);
      var res = await db.authenticate(Users(usrName: usrNameController.text, password: passwordController.text));
      if(res == true){
        //If result is correct then go to profile or home
        if(!mounted)return;
        Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen(profile: usrDetails)));
      }else{
        //Otherwise show the error message
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