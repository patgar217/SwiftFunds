import 'package:flutter/material.dart';
import 'package:swiftfunds/Views/home.dart';
import 'package:swiftfunds/Views/profile.dart';
import 'package:swiftfunds/Components/colors.dart';


class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.size,
    required this.widget,
  });

  final Size size;
  final HomeScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * .9,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Optional: Prevents excessive width
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap:(){ Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(profile: widget.profile))); },
            child: const CircleAvatar(
              backgroundColor: secondaryDark,
              radius: 17,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/profile.png"),
                radius: 15,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(profile: widget.profile))); }, 
            child: Text("Hi, ${widget.profile?.fullName ?? 'Admin'}", style: const TextStyle(fontWeight: FontWeight.bold, color: secondaryDark),),
          ),
          
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.menu, color: secondaryDark,), 
            onPressed: (){},
          )
        ],
      ),
    );
  }
}
