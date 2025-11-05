import 'package:http/http.dart' as http;
import 'package:googleapis/gmail/v1.dart' as gMail;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class GmailApiScreen{
  gMail.GmailApi? _gmailApi;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/gmail.readonly',
    'https://www.googleapis.com/auth/gmail.send'
  ]);

  Future<void> initialize() async {
    try {
      // Get the current Firebase user
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("No user is currently signed in");
      }

      // Check if the user signed in with Google
      final isGoogleUser = currentUser.providerData
          .any((provider) => provider.providerId == 'google.com');

      if (!isGoogleUser) {
        throw Exception("Gmail access is only available with Google Sign-In");
      }

      // Get the Google user
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) {
        googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw Exception("Failed to get Google user");
        }
      }

      // Get auth headers and create Gmail API client
      final authHeaders = await googleUser.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      _gmailApi = gMail.GmailApi(authenticateClient);
    } catch (e) {
      throw Exception("Error initializing Gmail API: ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> fetchEmails({String query = "label:STARRED"}) async {
    if (_gmailApi == null) {
      throw Exception("Gmail API is not initialized. Call initialize() first.");
    }

    List<Map<String, dynamic>> parsedMessagesList = [];

    try {
      final gMail.ListMessagesResponse results =
          await _gmailApi!.users.messages.list("me", q: query);

      if (results.messages != null) {
        for (gMail.Message message in results.messages!) {
          // Get the full message details
          gMail.Message messageData = await _gmailApi!.users.messages.get(
            "me",
            message.id!,
            format: "full",
          );

          // Extract subject, sender, and body
          String subject = '';
          String from = '';
          String body = _extractMessageBody(messageData.payload);

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

          parsedMessagesList.add({
            'id': messageData.id,
            'subject': subject,
            'from': from,
            'snippet': messageData.snippet ?? '',
            'body': body,
            'labels': messageData.labelIds ?? [],
          });
        }
      }
    } catch (e) {
      throw Exception("Error fetching emails: ${e.toString()}");
    }

    return parsedMessagesList;
  }

  String _extractMessageBody(gMail.MessagePart? payload) {
    if (payload == null) return '';

    if (payload.body?.data != null) {
      try {
        return utf8.decode(base64Url.decode(payload.body!.data!));
      } catch (e) {
        return '';
      }
    }

    if (payload.parts != null) {
      for (var part in payload.parts!) {
        if (part.mimeType == 'text/plain' || part.mimeType == 'text/html') {
          if (part.body?.data != null) {
            try {
              return utf8.decode(base64Url.decode(part.body!.data!));
            } catch (e) {}
          }
        }

        String nestedBody = _extractMessageBody(part);
        if (nestedBody.isNotEmpty) {
          return nestedBody;
        }
      }
    }

    return '';
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
