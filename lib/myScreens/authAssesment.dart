import 'package:covid_19/myServices/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthAssesment extends StatefulWidget {
  @override
  _AuthAssesmentState createState() => _AuthAssesmentState();
}

class _AuthAssesmentState extends State<AuthAssesment> {
  String phoneNo, verificationID, smsCode;
  bool codeSent = false;
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.blueAccent,
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        key: formKey,
                        keyboardType: TextInputType.phone,
                        decoration:
                            InputDecoration(hintText: 'Enter phone number'),
                        onChanged: (val) {
                          setState(() {
                            this.phoneNo = val;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                codeSent
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              key: formKey,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  hintText: 'One time password'),
                              onChanged: (val) {
                                setState(() {
                                  this.smsCode = val;
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.white,
                    child: Center(
                      child: codeSent ? Text("Login") : Text("Verify"),
                    ),
                    onPressed: () {
                      codeSent
                          ? AuthService().signInWithOTP(smsCode, verificationID)
                          : verifyPhone(phoneNo);
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    print(phoneNo);
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authResult) {
      //TO DO
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationID = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationID = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}
