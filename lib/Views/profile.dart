import 'package:flutter/material.dart';
import 'package:swiftfunds/Models/user.dart';
import 'package:swiftfunds/Components/colors.dart';
import 'package:swiftfunds/SQLite/database_service.dart';
import 'package:swiftfunds/Services/authentication_service.dart';
import 'package:swiftfunds/Views/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final db = DatabaseService();
  final authService = AuthenticationService();
  User? profile;
  bool isProfileLoaded = false;

  @override
  void initState() {
    super.initState();
    loadProfile(); 
  }

  loadProfile() async {
    User? user = await authService.getCurrentUser();

    if(user != null){
      profile = user;

      setState(() {
        isProfileLoaded = true;
      });
    }else{
      if(!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (context)  => const LoginScreen()));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    if (isProfileLoaded) {
      return ProfileWidget(profile: profile);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    super.key,
    required this.profile,
  });

  final User? profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 45.0,horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    backgroundColor: primaryDark,
                    radius: 77,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/profile.png"),
                      radius: 70,
                    ),
                  ),
    
                  const SizedBox(height: 10),
              
                  Text(profile?.fullName??"",style: const TextStyle(fontSize: 28,color: primaryDark),),
    
                  Text(profile?.email??"",style: const TextStyle(fontSize: 17,color: primaryDark),),
    
                  const SizedBox(height: 30),
    
                  ListTile(
                    leading: const Icon(Icons.person,size: 40),
                    subtitle: const Text("Full name", style: TextStyle(color: Colors.grey),),
                    title: Text(profile?.fullName??""),
                  ),
    
                  ListTile(
                    leading: const Icon(Icons.email,size: 40),
                    subtitle: const Text("Email", style: TextStyle(color: Colors.grey),),
                    title: Text(profile?.email??""),
                  ),
    
                  ListTile(
                    leading: const Icon(Icons.account_circle,size: 40),
                    subtitle: const Text("Username", style: TextStyle(color: Colors.grey),),
                    title: Text(profile?.username??""),
                  ),
              ],
            ),
          )
        ),
      ),
    );
  }
}