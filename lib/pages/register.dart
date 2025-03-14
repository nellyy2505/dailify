import 'package:dailify/components/button.dart';
import 'package:dailify/components/square_tiles.dart';
import 'package:dailify/components/textfield.dart';
import 'package:dailify/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final Function()? onTap;
  const SignupPage({super.key, required this.onTap});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // controller
  final emailController = TextEditingController();
  final cfPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserUp()async{
    //try creating the user
    try{
      // check if password is confirmed
      if(passwordController.text == cfPasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
        );
      }else{
        showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: Text('Incorrect password confirmation!'),
              titleTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: Colors.black,
            );
          }
        );
      }
    } on FirebaseAuthException catch (e){
      if(e.code == 'invalid-credential'){
        showDialog(
          context: context, 
          builder: (context){
            return AlertDialog(
              title: Text('Incorrect email or password!'),
              titleTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: Colors.black,
            );
          }
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  // logo
                  const SizedBox(height: 25),
                  Image.asset(
                      'lib/images/logo.png',
                      height: 100,
                  ),         
                  const SizedBox(height: 25),
                  // welcome back
                  Text(
                    "Create account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // username tf
                  MyTextfield(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 20,),
              
                  // password tf
                  MyTextfield(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20,),
              
                  // confirm password tf
                  MyTextfield(
                    controller: cfPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 50,),
              
                  // sign in button
                  MyButton(
                    onTap: signUserUp,
                    text: 'Sign Up'
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
                  const SizedBox(height: 20,),
              
                  // google
                  SquareTile(
                          imagepath: 'lib/images/google.png',
                          onTap: () => AuthService().signInWithGoogle(),
                        ),
                  const SizedBox(height: 20,),
                  
                  // register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Log in now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      )
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

