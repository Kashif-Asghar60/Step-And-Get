import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../provider/userauth.dart';
import '../screens/bottom_navBar.dart';

enum VerificationState {
  initial,
  sendingCode,
  verifyingCode,
  verified,
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  VerificationState _verificationState = VerificationState.initial;
  bool _isMounted = true;

  TextEditingController countryController = TextEditingController();

  TextEditingController phoneController =
      TextEditingController(text: "3558389477");
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_verificationState != VerificationState.verified)
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                ),
              SizedBox(height: 25),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "We need to register your phone to get stepping!",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      border: InputBorder.none,
                      hintText: 'Phone Number',
                      prefix: Text('+92'),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              Visibility(
                child: TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                    hintText: 'OTP',
                    prefix: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(''),
                    ),
                  ),
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),
                visible: otpVisibility,
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (otpVisibility) {
                      verifyOTP();
                    } else {
                      loginWithPhone();
                    }
                  },
                  child: Text(
                    otpVisibility ? "Verify" : "Send Verification Code",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              if (_verificationState != VerificationState.verified)
                SizedBox(
                  height: 16.0,
                ),
              if (_verificationState != VerificationState.verified)
                Text(
                  _verificationState == VerificationState.sendingCode
                      ? "Sending Verification Code..."
                      : _verificationState == VerificationState.verifyingCode
                          ? "Verifying OTP..."
                          : "",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
/*               if (_verificationState != VerificationState.verified)
                CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 5.0,
                ), */
            ],
          ),
        ),
      ),
    );
  }

  void loginWithPhone() async {
    if (!_isMounted) return;

    setState(() {
      _verificationState = VerificationState.sendingCode;
    });
    String phoneNumber = "+92" + phoneController.text;

    bool userExists = await checkIfUserExists(phoneNumber);

    if (userExists) {
      auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) async {
            print("You are logged in successfully");
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code sent: $verificationId");
          otpVisibility = true;
          verificationID = verificationId;
          if (_isMounted) {
            setState(() {
              _verificationState = VerificationState.initial;
            });
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout: $verificationId");
        },
      );
    } else {
      auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then(
            (value) async {
              setState(() {
                user = FirebaseAuth.instance.currentUser;
              });

              if (user != null) {
                context.read<UserProvider>().setUserId(user!.uid);
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .set({
                  'phone': user!.phoneNumber,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .collection('points')
                    .doc('totalpoints')
                    .set({
                  'points': 30,
                  'updatedAt': FieldValue.serverTimestamp(),
                });

                print("You are logged in successfully");

                if (_isMounted) {
                  setState(() {
                    _verificationState = VerificationState.initial;
                  });
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(),
                  ),
                );
              } else {
                print("Your login has failed");
                if (_isMounted) {
                  setState(() {
                    _verificationState = VerificationState.initial;
                  });
                }
                Fluttertoast.showToast(
                  msg: "Your login has failed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          showErrorMessage(
              "Error during OTP verification: $e"); // Show error message
          if (_isMounted) {
            setState(() {
              _verificationState = VerificationState.initial;
            });
          }

          print("Verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code sent: $verificationId");
          otpVisibility = true;
          verificationID = verificationId;
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout: $verificationId");
        },
      );
    }
  }

  Future<bool> checkIfUserExists(String phoneNumber) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void verifyOTP() async {
    if (!_isMounted) return;

    setState(() {
      _verificationState = VerificationState.verifyingCode;
    });

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationID,
      smsCode: otpController.text,
    );

    try {
      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        context.read<UserProvider>().setUserId(user.uid);

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'phone': user.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
          'byotp': "mmmmmm",
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('points')
            .doc('totalpoints')
            .set({
          'points': 40,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        print("You are logged in successfully");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(),
          ),
        );
      } else {
        if (_isMounted) {
          setState(() {
            _verificationState = VerificationState.initial;
          });
        }
        print("Your login has failed");

        Fluttertoast.showToast(
          msg: "Your login has failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print("Error during OTP verification: $e");
      showErrorMessage(
          "Error during OTP verification: $e"); // Show error message

      if (_isMounted) {
        setState(() {
          _verificationState = VerificationState.initial;
        });
      }
    }
  }

  // Method to show an error message using a SnackBar
  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 15), // Adjust the duration as needed
      ),
    );
  }
}
