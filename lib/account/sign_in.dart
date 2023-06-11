// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:step_n_get/account/signup.dart';
// import 'package:step_n_get/account/signup.dart';
//
// import '../screens/bottom_navBar.dart';
//
// class SignInScreen extends StatefulWidget {
//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> {
//   DateTime? selectedDate;
//   String? _signInError;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: SizedBox(
//                   width: 250,
//                   child: Image.asset(
//                     'assets/logo.png',
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         controller: _emailController,
//                         keyboardType: TextInputType.phone,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           labelStyle: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 16,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Please Enter Email";
//                           } else if (_signInError != null) {
//                             return _signInError;
//                           } else {
//                             return null;
//                           }
//                         },
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           labelText: 'Password',
//                           labelStyle: TextStyle(
//                             color: Colors.grey[400],
//                             fontSize: 16,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade300),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "Please Enter Password";
//                           } else if (_signInError != null) {
//                             return _signInError;
//                           } else {
//                             return null;
//                           }
//                         },
//                       ),
//                       SizedBox(height: 40),
//                       Container(
//                         width: double.infinity,
//                         height: 50,
//                         child: ElevatedButton(
//                           onPressed: _signIn,
//                           child: Text(
//                             'Sign In',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             primary: Colors.orange,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Didn't have an account?",
//                             style: TextStyle(color: Colors.grey[600]),
//                           ),
//                           SizedBox(width: 5),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => SignupScreen()),
//                               );
//                             },
//                             child: Text(
//                               'Sign Up',
//                               style: TextStyle(
//                                 color: Colors.orange,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _signIn() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         UserCredential userCredential =
//             await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _emailController.text.trim(),
//           password: _passwordController.text.trim(),
//         );
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => BottomNavBar(),
//           ),
//         );
//
//         // User sign-in successful, navigate to home screen or perform any other actions
//       } on FirebaseAuthException catch (e) {
//         if (e.code == 'user-not-found' || e.code == 'wrong-password') {
//           setState(() {
//             _signInError = 'Invalid email or password.';
//           });
//         }
//         // Handle other FirebaseAuthException errors
//       } catch (e) {
//         print(e.toString());
//         // Handle other exceptions
//       }
//     }
//   }
// }
