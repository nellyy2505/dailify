import 'package:dailify/components/button.dart';
import 'package:dailify/components/square_tiles.dart';
import 'package:dailify/components/textfield.dart';
import 'package:dailify/pages/forgot_pw_page.dart';
import 'package:dailify/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn()async{
    //try sign in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text, 
        password: passwordController.text,
      );
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
                  const SizedBox(height: 10,),
              
                  // forgot pw
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ForgotPwPage();
                          })) ;
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                  // sign in button
                  MyButton(
                    onTap: signUserIn,
                    text: 'Sign In'
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
                        'Not a member?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Register now',
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

