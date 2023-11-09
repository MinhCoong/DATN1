// ignore_for_file: avoid_print, invalid_return_type_for_catch_error

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn().catchError((onError) => print(onError));

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print(e);
    throw FirebaseAuthException(
      code: 'failed',
      message: 'Đăng nhập bằng Google thất bại.',
    );
  }
}

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  if (loginResult.status == LoginStatus.success) {
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  } else if (loginResult.status == LoginStatus.cancelled) {
    // Đăng nhập bị hủy bỏ
    throw FirebaseAuthException(
      code: 'cancelled',
      message: 'Đăng nhập bằng Facebook đã bị hủy bỏ.',
    );
  } else {
    // Đăng nhập thất bại
    throw FirebaseAuthException(
      code: 'failed',
      message: 'Đăng nhập bằng Facebook thất bại.',
    );
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  await FacebookAuth.instance.logOut();
  await GoogleSignIn().signOut();
}
