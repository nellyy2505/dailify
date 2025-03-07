import 'package:dailify/components/button.dart';
import 'package:dailify/components/square_tiles.dart';
import 'package:dailify/components/textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // controller
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // logo
              const SizedBox(height: 50),
              Image.asset(
                  'lib/images/logo.png',
                  height: 100,
              ),         
              const SizedBox(height: 50),
              // welcome back
              Text(
                "Welcome back",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 50),
              // username tf
              MyTextfield(
                controller: userNameController,
                hintText: "Username",
                obscureText: false,
              ),
              const SizedBox(height: 20,),

              // password tf
              MyTextfield(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 10,),

              // forgot pw
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              // sign in button
              MyButton(
                onTap: signUserIn,
              ),
              const SizedBox(height: 50,),

              // continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(
                          color: Colors.grey[700]
                        )
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50,),

              // google + apple
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    SquareTile(imagepath: 'lib/images/google.png'),
                    const SizedBox(width: 10,),
                    SquareTile(imagepath: 'lib/images/apple.png'),
                ],
              )
          
              // register
            ],
          ),
        ),
      ),
    );
  }
}

