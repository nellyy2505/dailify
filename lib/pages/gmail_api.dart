import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/gmail/v1.dart' as gMail;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class GmailApiScreen extends StatefulWidget {
  const GmailApiScreen({super.key});

  @override
  State<GmailApiScreen> createState() => _GmailApiScreenState();
}

class _GmailApiScreenState extends State<GmailApiScreen> {
  gMail.GmailApi? gmailApi;
  List<Map> parsedMessagesList = [];
  late Future waitForInit;
  bool isLoading = true;
  String? errorMessage;

  // Reference to your existing GoogleSignIn instance
  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/gmail.readonly',
    'https://www.googleapis.com/auth/gmail.send'
  ]);

  @override
  void initState() {
    super.initState();
    waitForInit = init();
  }

  Future<void> init() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Get the current Firebase user
      final User? currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) {
        throw Exception("No user is currently signed in");
      }

      // Check if the user signed in with Google
      final isGoogleUser = currentUser.providerData
          .any((provider) => provider.providerId == 'google.com');

      if (!isGoogleUser) {
        setState(() {
          errorMessage = "Gmail access is only available with Google Sign-In";
          isLoading = false;
        });
        return;
      }

      // Get the Google user that's already signed in
      GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
      
      // If not available silently, the token might have expired
      if (googleUser == null) {
        // This will show the UI if needed
        googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          throw Exception("Failed to get Google user");
        }
      }

      // Get auth headers for API calls
      final authHeaders = await googleUser.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      gmailApi = gMail.GmailApi(authenticateClient);

      // Fetch messages
      final gMail.ListMessagesResponse results = 
          await gmailApi!.users.messages.list("me",q: "label:STARRED",);
      
      if (results.messages != null) {
        for (gMail.Message message in results.messages!) {
          // Get the full message
          gMail.Message messageData = await gmailApi!.users.messages.get(
            "me", 
            message.id!,
            format: "full"  // Request full message format
          );
          
          // Extract subject from headers
          String subject = '';
          String from = '';
          String body = '';
          
          // Parse headers
          if (messageData.payload?.headers != null) {
            for (var header in messageData.payload!.headers!) {
              if (header.name == 'Subject') {
                subject = header.value ?? '';
              }
              if (header.name == 'From') {
                from = header.value ?? '';
              }
            }
          }
          
          // Extract body content
          String getMessageBody(gMail.MessagePart? payload) {
            if (payload == null) return '';
            
            // Check if this part has a body
            if (payload.body?.data != null) {
              // Decode from base64
              try {
                String decoded = utf8.decode(base64Url.decode(payload.body!.data!));
                return decoded;
              } catch (e) {
                return '';
              }
            }
            
            // Check for multipart messages
            if (payload.parts != null) {
              for (var part in payload.parts!) {
                // Look for text/plain or text/html parts
                if (part.mimeType == 'text/plain' || part.mimeType == 'text/html') {
                  if (part.body?.data != null) {
                    try {
                      return utf8.decode(base64Url.decode(part.body!.data!));
                    } catch (e) {
                      // Continue if this part fails
                    }
                  }
                }
                
                // Recursively check nested parts
                String nestedBody = getMessageBody(part);
                if (nestedBody.isNotEmpty) {
                  return nestedBody;
                }
              }
            }
            
            return '';
          }
          body = getMessageBody(messageData.payload);
          
          // Create a more usable message object
          var emailMessage = {
            'id': messageData.id,
            'subject': subject,
            'from': from,
            'snippet': messageData.snippet ?? '',
            'body': body,
            'labels': messageData.labelIds ?? [],
          };

          print(emailMessage);
          
          setState(() {
            parsedMessagesList.add(emailMessage);
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error: ${e.toString()}";
        isLoading = false;
      });
      print('Error initializing Gmail API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Email")),
      body: buildFutureBuilder(),
    );
  }

  Widget buildFutureBuilder() {
    return FutureBuilder<void>(
        future: waitForInit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (errorMessage != null) {
              return Center(child: Text(errorMessage!));
            }
            
            if (parsedMessagesList.isEmpty) {
              return Center(child: Text('No messages found'));
            }
            
            return ListView.builder(
              itemCount: parsedMessagesList.length,
              itemBuilder: (context, index) {
                final message = parsedMessagesList[index];
                return Text(message['body']);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = new http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}