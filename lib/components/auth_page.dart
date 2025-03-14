import 'package:dailify/pages/home.dart';
import 'package:dailify/pages/login_or_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(), //if user is logged in or not
        builder: (context, snapshot){
          //logged in
          if (snapshot.hasData){
            return HomePage();
          }
          //or not
          else{
            return LoginOrSignupPage();
          }
        }
      ),
    );
  }
}