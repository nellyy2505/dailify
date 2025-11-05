import 'package:flutter/material.dart';
import 'package:dailify/util/chatbox.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> messages = []; // Stores chat messages
  final ScrollController _scrollController = ScrollController();
  bool _showingChat = false;

  void _addMessage(String text, bool isUser) {
    setState(() {
      if (!_showingChat) {
        _showingChat = true;
      }
      messages.add({"text": text, "isUser": isUser});
    });
    FocusScope.of(context).unfocus(); // Hide keyboard after sending message

    // Scroll to bottom after the new message is added
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
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
                    fontSize: 30,
                  ),
                ),
                Text(
                  _showingChat ? "Your Chat" : "Your Dashboard",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Either show dashboard widgets or chat
            Expanded(
              child: _showingChat 
                ? _buildChatArea() 
                : _buildDashboardWidgets(),
            ),
            
            //Chatbox
            ChatBox(
              onSendMessage: _addMessage,
              text: 'Ask me something',
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        bool isUser = messages[index]["isUser"];
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7, // 70% width
            ),
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUser ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              messages[index]["text"],
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDashboardWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}