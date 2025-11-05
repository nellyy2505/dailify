import 'package:dailify/services/gmail_api.dart';
import 'package:dailify/pages/open_gmail.dart';
import 'package:dailify/util/chatbox.dart';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final List<Map<String, dynamic>> messages = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  bool isProcessing = false;
  String? errorMessage;
  
  // Email data
  Map<String, dynamic>? currentEmail;
  String emailSummary = "Loading emails...";
  String generatedResponse = "";
  bool isSpam = false;

  @override
  void initState() {
    super.initState();
    _initOpenAI();
    _fetchEmails();
  }

  void _initOpenAI() {
    OpenAI.apiKey = "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";
  }

  Future<void> _fetchEmails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Create a temporary instance to fetch emails
      final gmailScreen = GmailApiScreen();
      await gmailScreen.initialize();
      
      List<Map<String, dynamic>>? parsedMessagesList = await gmailScreen.fetchEmails();

      if (parsedMessagesList.isNotEmpty) {
        setState(() {
          currentEmail = parsedMessagesList[-1];
          parsedMessagesList.removeLast();
          isLoading = false;
        });
        
        // Use GPT to summarize and generate response
        await _generateGPTSummaryAndResponse();
      } else {
        setState(() {
          emailSummary = "No new emails found";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching emails: ${e.toString()}";
        isLoading = false;
      });
      print('Error fetching emails: $e');
    }
  }

  Future<void> _generateGPTSummaryAndResponse() async {
    if (currentEmail == null) return;
    
    setState(() {
      isProcessing = true;
    });
    
    try {
      // Prepare email content
      String from = currentEmail!['from'] ?? 'Unknown';
      String subject = currentEmail!['subject'] ?? 'No subject';
      String body = currentEmail!['body'] ?? '';
      
      // Generate summary using GPT
      final summaryResponse = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "Summarize the following email in 3-4 concise sentences. Also, determine if this email is likely spam (yes/no) and explain why briefly."
              )
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "From: $from\nSubject: $subject\n\nBody:\n$body"
              )
            ],
          ),
        ],
      );
      
      String summaryText = summaryResponse.choices.first.message.content?.first.text ?? "Could not generate summary";
      
      // Check if it contains spam assessment
      bool detectedAsSpam = summaryText.toLowerCase().contains("spam: yes") || 
                         summaryText.toLowerCase().contains("likely spam") ||
                         summaryText.toLowerCase().contains("is spam");
      
      // Generate response based on email content
      final responsePrompt = detectedAsSpam
          ? "Generate a polite response declining this email as it appears to be spam. Keep it short and professional."
          : "Generate a professional response to this email. Be concise and helpful.";
      
      final responseGPT = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(responsePrompt)
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                "From: $from\nSubject: $subject\n\nBody:\n$body"
              )
            ],
          ),
        ],
      );
      
      String responseText = responseGPT.choices.first.message.content?.first.text ?? "Could not generate response";
      
      setState(() {
        emailSummary = "From: $from\nSubject: $subject\n\n$summaryText";
        generatedResponse = responseText;
        isSpam = detectedAsSpam;
        isProcessing = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error generating content: ${e.toString()}";
        isProcessing = false;
      });
      print('Error with GPT: $e');
    }
  }

  void editResponse(String text, bool isUser) {
    if (isUser) {
      setState(() {
        generatedResponse = text;
      });
      
      // Here you would typically send the response
      // For now, we'll just add it to the messages list
      messages.add({
        "text": "Response edited and sent to ${currentEmail?['from'] ?? 'recipient'}",
        "isUser": false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Email message summary
          Stack(
            alignment: const AlignmentDirectional(0, -1),
            children: [
              Expanded(
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(50)),
                  ),
                )
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: 380,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "N E W  E M A I L",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        isLoading || isProcessing
                          ? const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(color: Colors.white),
                                  SizedBox(height: 10),
                                  Text("Processing email...", style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            )
                          : errorMessage != null
                            ? Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              )
                            : Text(
                                emailSummary,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                        if (isSpam && !isLoading && !isProcessing && errorMessage == null)
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "⚠️ This email may be spam",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => FullEmailPage(), 
                        )
                      );
                    },
                    icon: const Icon(Icons.email, color: Colors.black),
                    label: const Text("View full email"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      elevation: 0,
                      foregroundColor: Colors.black,
                      textStyle: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Generated response or spam alert
          Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Re: ${currentEmail?['subject'] ?? 'Loading...'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  generatedResponse.isEmpty ? "Generating response..." : generatedResponse,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 20),
                if (isSpam && !isLoading && !isProcessing && errorMessage == null)
                  ElevatedButton.icon(
                    onPressed: () {
                      // Here you would delete the email
                      setState(() {
                        messages.add({
                          "text": "Email deleted",
                          "isUser": false
                        });
                        // Fetch next email
                        _fetchEmails();
                      });
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text("Delete Spam Email"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
              ],
            ),
          ),

          // Chat messages area (if any)
          if (messages.isNotEmpty)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  bool isUser = messages[index]["isUser"];
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blueAccent : Colors.grey[600],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        messages[index]["text"],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Edit response and send
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
            child: Column(
              children: [
                ChatBox(
                  onSendMessage: editResponse, 
                  text: 'Edit generated response'
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (generatedResponse.isNotEmpty) {
                          editResponse(generatedResponse, true);
                        }
                      },
                      icon: const Icon(Icons.send),
                      label: const Text("Send Response"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}