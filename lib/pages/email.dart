import 'package:flutter/material.dart';
import 'package:dailify/util/response_box.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //new email
          Stack(
            alignment: AlignmentDirectional(0, -1),
            children: [
              Expanded(
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
                  ),
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    width: 380,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "N E W  E M A I L",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ), 
                    //TODO Retrieve new emails' content
                  ),
                  
                  ElevatedButton.icon(
                    onPressed:() {}, //TODO view full email 
                    label: Text("View full email"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      elevation: 0,
                      textStyle: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
          Container(
            padding: const EdgeInsets.all(25),
          //generated response or display spam email alert
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Re: Subject: Headline",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor erat lacus, sit amet dignissim nulla tristique dignissim. Cras suscipit a mi ut gravida. Mauris aliquet, lacus sit amet congue lacinia, nisl augue auctor urna, in finibus diam velit a enim. Donec nec massa lacinia, placerat arcu in, mollis sapien. Aenean elementum dolor at massa ultricies hendrerit. Duis faucibus, sem sed aliquet lobortis, lacus augue bibendum neque, eu commodo lacus ipsum nec nibh. Morbi quis nisi ipsum. Quisque id lorem velit. Etiam quis mi arcu. Duis aliquam turpis et neque auctor, nec commodo nunc vehicula. Etiam sed diam metus. Vivamus tincidunt leo eu ante mollis ultrices.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),

          //edit response and send response to given email or option to delete spam email
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
            child: ResponseBox(),
          )
        ],
      )
    );
  }
}