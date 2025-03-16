import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'https://www.googleapis.com/auth/gmail.readonly', 'https://www.googleapis.com/auth/gmail.send']);

class AuthService {
  // Google sigin
  signInWithGoogle()async{
    // begin interactive sign in
    final GoogleSignInAccount? gUser = await googleSignIn.signIn();

    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    // create new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //Firebase exception when no internet
    final UserCredential authResult = await _auth.signInWithCredential(credential);

    // sign in
    return authResult;
  }

} 