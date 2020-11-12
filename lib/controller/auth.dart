import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();
UserCredential userCredential;

Future<User> signInAcc() async {
  final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
  userCredential = await auth.signInWithCredential(credential);
  final user = userCredential.user;
  print(user);
  return user;
}

Future<void> signOutUser() async {
  await auth.signOut();
  await googleSignIn.disconnect();
  await googleSignIn.signOut();
  // await googleSignIn.signOut();
}
