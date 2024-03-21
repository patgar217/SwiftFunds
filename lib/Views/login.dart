import 'package:swiftfunds/SQLite/database_service.dart';
import 'package:swiftfunds/Services/authentication_service.dart';

import '../Models/user.dart';
import 'package:flutter/material.dart';
import 'package:swiftfunds/Views/home.dart';
import 'package:swiftfunds/Views/signup.dart';
import 'package:swiftfunds/Components/button_widget.dart';
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

  final db = DatabaseService();
  final authService = AuthenticationService();

  String error = "";
  bool isLoginCorrect = true;

  validate() async {
    if(usrNameController.text.isEmpty || passwordController.text.isEmpty){
      setState(() {
        isLoginCorrect = false;
        error="Please input username and password.";
      });
    }else{
      login();
    }
  }
  
  login() async{
      var res = await db.authenticate(User(username: usrNameController.text, password: passwordController.text));
      if(res == true){
        User user = (await db.getUser(usrNameController.text))!;
        authService.setLoggedUser(user.username, user.userId!);

        if(!mounted)return;
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
      }else{
        setState(() {
          isLoginCorrect = false;
          error="Username or password is incorrect.";
        });
      }
    }
    
  @override
  Widget build(BuildContext context) {

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
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrNameController, isEditable: true, isError: !isLoginCorrect,),
                InputField(hint: "Password", icon: Icons.lock, controller: passwordController, passwordInvisible: true, isEditable: true, isError: !isLoginCorrect),
                if(!isLoginCorrect) Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(error, textAlign: TextAlign.left, style: const TextStyle(color: Colors.red),),
                ),

                Button(label: "LOGIN", backgroundColor: primaryDark, textSize: 20, press: (){
                  validate();
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