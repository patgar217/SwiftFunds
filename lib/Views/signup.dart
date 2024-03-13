import 'package:swiftfunds/SQLite/database_service.dart';

import '../Components/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:swiftfunds/Views/login.dart';
import 'package:swiftfunds/Models/user.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/Components/textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ super.key });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  
  bool isSignUpTrue = false;

  final db = DatabaseService();
  signUp()async{
    try{
      var res = await db.createUser(User(fullName: fullName.text,email: email.text,username: usrName.text, password: password.text, swiftpoints: 0.00));
      if(res>0){
        if(!mounted)return;
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
      }
    }catch(error){
      setState(() {
        isSignUpTrue = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                  child: Text("Create Account", style: TextStyle(fontSize: 30, color: primaryDark, fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text("Please fill the input below.", style: TextStyle(fontSize: 18, color: primaryDark)),
                ),
                InputField(hint: "Full Name", icon: Icons.person, controller: fullName),
                InputField(hint: "Email", icon: Icons.email, controller: email),
                InputField(hint: "Username", icon: Icons.account_circle, controller: usrName),
                InputField(hint: "Password", icon: Icons.lock, controller: password, passwordInvisible: true,),
                InputField(hint: "Re-enter password", icon: Icons.lock, controller: confirmPassword, passwordInvisible: true,),
                isSignUpTrue ? Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: size.width * .05, vertical: 5),
                      child: Text(
                        "Email or username already exists",
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ) : const SizedBox(),
                Button(label: "SIGN UP", backgroundColor: primaryDark, textSize: 20, press: (){
                  signUp();
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?",style: TextStyle(color: Colors.grey),),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
                      },
                      child: const Text("LOGIN", style: TextStyle(color: primaryDark)))
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