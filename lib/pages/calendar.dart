import 'package:flutter/material.dart';
import 'package:dailify/util/chatbox.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final List<Map<String, dynamic>> messages = []; // Stores chat messages
  final ScrollController _scrollController = ScrollController();

  void _addMessage(String text, bool isUser) {
    setState(() {
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
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    reverse: true, // Keeps the latest message visible when keyboard appears
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight, // Ensures it takes full space
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end, // Keeps messages at the bottom
                        children: messages.map((msg) {
                          bool isUser = msg["isUser"];
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
                                msg["text"],
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            ChatBox(onSendMessage: _addMessage, text: 'Say something',), // Chat input box always at the bottom
          ],
        ),
      ),
    );
  }
}
