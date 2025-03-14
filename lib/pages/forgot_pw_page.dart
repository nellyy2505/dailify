import 'package:dailify/components/button.dart';
import 'package:dailify/components/textfield.dart';
import 'package:dailify/pages/login_or_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPwPage extends StatefulWidget {
  const ForgotPwPage({super.key});

  @override
  State<ForgotPwPage> createState() => _ForgotPwPageState();
}
class _ForgotPwPageState extends State<ForgotPwPage> {
  final _emailController = TextEditingController();
  
  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  Future resetPassword()async{
    try{
      await FirebaseAuth.instance.
      sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context, builder: (context){
          return AlertDialog(
            content: Text('Reset password link has been sent to  ${_emailController.text.trim()}. Please check your email!'),
          );
        }
      );
    }on FirebaseAuthException catch(e){
      showDialog(
        context: context, builder: (context){
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        }
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          children: [
            //logo
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Image.asset(
                'lib/images/logo.png',
                height: 100,
              ),
            ),
          
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forgot your password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter the email address you\'d like to receive your password reset link',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Enter email address',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10,),
                
                  MyTextfield(
                    controller: _emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 30),
                  
                  MyButton(onTap: resetPassword, text: 'Request reset link'),
                  const SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return LoginOrSignupPage();
                        })) ;
                      },
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}