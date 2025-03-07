import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.grey.shade700,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.white,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 50,
        onTabChange:(value) => onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Dashboard",
          ),
          GButton(
            icon: Icons.mail,
            text: "Email",
          ),
          GButton(
            icon: Icons.calendar_month,
            text: "Calendar",
          ),
          GButton(
            icon: Icons.list,
            text: "To Do",
          ),
        ]
      ),
    );
  }
}