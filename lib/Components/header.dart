import 'package:flutter/material.dart';
import 'package:swiftfunds/Models/users.dart';
import 'package:swiftfunds/Views/menu.dart';
import 'package:swiftfunds/Views/profile.dart';
import 'package:swiftfunds/Components/colors.dart';


class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.size, this.profile,
  });

  final Size size;
  final Users? profile;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * .9,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Optional: Prevents excessive width
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileScreen())); },
            child: const CircleAvatar(
              backgroundColor: secondaryDark,
              radius: 17,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/profile.png"),
                radius: 15,
              ),
            ),
          ),
          TextButton(
            onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProfileScreen())); }, 
            child: Text("Hi, ${profile?.fullName ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, color: secondaryDark),),
          ),
          
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.menu, color: secondaryDark,), 
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const MenuScreen()));
            },
          )
        ],
      ),
    );
  }
}
