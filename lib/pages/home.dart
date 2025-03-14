import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dailify/components/bottom_nav_bar.dart';
import 'package:dailify/pages/calendar.dart';
import 'package:dailify/pages/dashboard.dart';
import 'package:dailify/pages/email.dart';
import 'package:dailify/pages/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

    void signUserOut(){
    FirebaseAuth.instance.signOut();
  }

  final List<Widget> _pages = [
    const DashboardPage(),
    const EmailPage(),
    const CalendarPage(),
    const TodoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  //logo
                  DrawerHeader(child: Image.asset('lib/images/logo.png', color: Colors.white)),
          
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Divider(color: Colors.grey[800],),
                  ),
                  
                  //other pages
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text("H O M E"),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ),
          
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text("A B O U T"),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ),
          
                  const Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text("S E T T I N G S"),
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ),
          
                ],
              ),
              GestureDetector(
                onTap: signUserOut,
                child: Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("L O G O U T"),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: _pages[_selectedIndex],
    );
  }
}