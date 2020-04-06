import 'package:covid_19/myScreens/authAssesment.dart';
import 'package:covid_19/myScreens/myAssesment.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return MyAssesment();
        }
        else
          return AuthAssesment();
      },
    );
  }

  signOut(){
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCred){
    FirebaseAuth.instance.signInWithCredential(authCred);
  }

  signInWithOTP(smsCode,verID){
    AuthCredential authCreds=PhoneAuthProvider.getCredential(verificationId: verID, smsCode: smsCode);
    signIn(authCreds);
  }
}
