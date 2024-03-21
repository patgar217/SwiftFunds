
import 'package:swiftfunds/Services/user_service.dart';

import '../Components/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:swiftfunds/Views/login.dart';
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
  bool isFullNameCorrect = true;
  bool isEmailCorrect = true;
  bool isUserNameCorrect = true;
  bool isPasswordCorrect = true;
  bool isRetypePasswordCorrect = true;

  String emailError = "";
  String usernameError = "";
  String passwordError = "";
  String confirmPasswordError = "";

  final userService = UserService();

  validateSignUp() async {
    setState(() {
      isFullNameCorrect = fullName.text.isNotEmpty;
    });

    checkUsername(usrName.text);
    checkEmail(email.text);
    checkPassword(password.text, confirmPassword.text);

    if(isFullNameCorrect && isEmailCorrect && isUserNameCorrect && isPasswordCorrect && isRetypePasswordCorrect){
      signUp();
    }
  }

  void checkUsername(String username) async {
    if (username.isEmpty) {
      setState(() {
        isUserNameCorrect = false;
        usernameError = "Username is required.";
      });
      return; // Early exit if username is empty
    }

    try {
      bool hasDuplicateUsername = await userService.hasDuplicateUsername(username);
      setState(() {
        isUserNameCorrect = !hasDuplicateUsername;
        usernameError = "Username is already used.";
      });
    } on Exception catch (e) {
      setState(() {
        isUserNameCorrect = false;
        usernameError = "Error fetching users: $e";
      });
    }
  }

  void checkEmail(String email) async {
    if (email.isEmpty) {
      setState(() {
        isEmailCorrect = false;
        emailError = "Email is required.";
      });
      return; // Early exit if username is empty
    }

    try {
      bool hasDuplicateEmail = await userService.hasDuplicateEmail(email);
      setState(() {
        isEmailCorrect = !hasDuplicateEmail;
        emailError = "Email is already used.";
      });
    } on Exception catch (e) {
      setState(() {
        isEmailCorrect = false;
        emailError = "Error fetching users: $e";
      });
    }
  }

  void checkPassword(String password, String confirmPassword) async {
    final RegExp regExp = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$'); // Minimum 8 characters, 1 uppercase, 1 lowercase, 1 digit
    if (password.isEmpty) {
      setState(() {
        isPasswordCorrect = false;
        passwordError = "Password is required.";
      });
      return;
    } else if (!regExp.hasMatch(password)) {
      setState(() {
        isPasswordCorrect = false;
        passwordError = "Password must be at least 8 characters and contain at least one uppercase letter, one lowercase letter, and one digit.";
      });
      return;
    }else{
      setState(() {
        isPasswordCorrect = true;
      });
    }

    setState(() {
      isRetypePasswordCorrect = password == confirmPassword;
      confirmPasswordError = "Password and re-typed password are different.";
    });
  }

  signUp() async {
    try{
      var res = await userService.createNewUser(fullName.text, email.text, usrName.text, password.text);
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/logo-negative.png"),
                      radius: 80,
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 5),
                      child: Text("Create Account", style: TextStyle(fontSize: 30, color: primaryDark, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Text("Please fill the input below.", style: TextStyle(fontSize: 18, color: primaryDark)),
                    ),
                  ),
                  InputField(hint: "Full Name", icon: Icons.person, controller: fullName, isEditable: true, isError: !isFullNameCorrect,),
                  if(!isFullNameCorrect) const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text("Full name is required.", textAlign: TextAlign.left, style: TextStyle(color: Colors.red),),
                  ),

                  InputField(hint: "Email", icon: Icons.email, controller: email, isEditable: true, isError: !isEmailCorrect),
                  if(!isEmailCorrect) Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(emailError, textAlign: TextAlign.left, style: const TextStyle(color: Colors.red),),
                  ),

                  InputField(hint: "Username", icon: Icons.account_circle, controller: usrName, isEditable: true, isError: !isUserNameCorrect),
                  if(!isUserNameCorrect) Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(usernameError, textAlign: TextAlign.left, style: const TextStyle(color: Colors.red),),
                  ),
                  
                  InputField(hint: "Password", icon: Icons.lock, controller: password, passwordInvisible: true, isEditable: true, isError: !isPasswordCorrect),
                  if(!isPasswordCorrect) Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(passwordError, textAlign: TextAlign.left, style: const TextStyle(color: Colors.red),),
                  ),

                  InputField(hint: "Re-enter password", icon: Icons.lock, controller: confirmPassword, passwordInvisible: true, isEditable: true, isError: !isRetypePasswordCorrect),
                  if(!isRetypePasswordCorrect) Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(confirmPasswordError, textAlign: TextAlign.left, style: const TextStyle(color: Colors.red),),
                  ),

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
                    validateSignUp();
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
      ),
    );
  }
}