import 'package:flutter/material.dart';
import 'package:dailify/util/chatbox.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // This widget is the root of your application.
  void chatBot(){}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Welcome user
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Welcome user
                Text(
                  "Hello User,",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:30,
                  ),
                ),
                Text(
                  "Your Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize:30,
                  ),
                ),
              ],
            ),
            
            //Block widgets 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[200],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(3, 3), // changes position of shadow
                          ),
                        ]
                      ),
                      height: 170,
                      width: 170,
                    ),
      
                    const SizedBox(height: 25),
      
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[400],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(3, 3), // changes position of shadow
                          ),
                        ]
                      ),
                      height: 170,
                      width: 170,
                    ),
                  ],
                ),
            
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[800],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(3, 3), // changes position of shadow
                            ),
                          ]
                        ),
                      height: 230,
                      width: 170,
                    ),
      
                    const SizedBox(height: 25),
      
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(3, 3), // changes position of shadow
                            ),
                          ]
                        ),
                      height: 170,
                      width: 170,
                    )
                  ],
                )
              ],
            ),     
            //Chatbox
            ChatBox(
              onPressed: chatBot,
              text: 'Ask me something',
            ),
          ]
        ),
      ),
    );
  }
}